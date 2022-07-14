/datum/role/cultist
	name = CULTIST
	id = CULTIST

	required_pref = ROLE_CULTIST
	restricted_jobs = list("Security Cadet", "Chaplain", "AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Internal Affairs Agent")
	restricted_species_flags = list(NO_BLOOD)

	antag_hud_type = ANTAG_HUD_CULT
	antag_hud_name = "hudcultist"

	logo_state = "cult-logo"

	var/holy_rank = CULT_ROLE_HIGHPRIEST
	skillset_type = /datum/skillset/cultist
	change_to_maximum_skills = FALSE

/datum/role/cultist/CanBeAssigned(datum/mind/M, laterole)
	if(laterole == FALSE) // can be null
		return ..() // religion has all necessary checks, but they are not applicable to mind, as here
	return TRUE

/datum/role/cultist/RemoveFromRole(datum/mind/M, msg_admins)
	..()
	var/datum/faction/cult/C = faction
	if(istype(C))
		C.religion?.remove_member(M.current)

/datum/role/cultist/proc/equip_cultist(mob/living/carbon/human/mob)
	if(!istype(mob))
		return

	if(mob.mind)
		if(mob.mind.assigned_role == "Clown")
			to_chat(mob, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
			mob.mutations.Remove(CLUMSY)

	mob.equip_to_slot_or_del(new /obj/item/device/cult_camera(mob), SLOT_IN_BACKPACK)

	var/datum/faction/cult/C = faction
	if(istype(C))
		C.religion.give_tome(mob)

/datum/role/cultist/OnPostSetup(laterole)
	..()
	if(!laterole)
		equip_cultist(antag.current)
	var/datum/faction/cult/C = faction
	if(istype(C))
		C.religion.add_member(antag.current, holy_rank)

/datum/role/cultist/extraPanelButtons()
	var/dat = ..()
	dat += " - <a href='?src=\ref[antag];mind=\ref[antag];role=\ref[src];cult_tome=1;'>(Give Tome)</a>"
	dat += " - <a href='?src=\ref[antag];mind=\ref[antag];role=\ref[src];cult_heaven=1;'>(TP to Heaven)</a>"
	dat += " - <a href='?src=\ref[antag];mind=\ref[antag];role=\ref[src];cult_cheating=1;'>(Cheating Religion)</a>"
	dat += " - <a href='?src=\ref[antag];mind=\ref[antag];role=\ref[src];cult_leader=1;'>(Make Leader)</a>"
	return dat

/datum/role/cultist/RoleTopic(href, href_list, datum/mind/M, admin_auth)
	var/datum/faction/cult/C = faction
	if(istype(C))
		if(href_list["cult_tome"])
			var/mob/living/carbon/human/H = M.current
			if(istype(H))
				if(C.religion)
					C.religion.give_tome(H)

		if(href_list["cult_heaven"])
			var/area/A = locate(C.religion.area_type)
			var/turf/T = get_turf(pick(A.contents))
			M.current.forceMove(T)

		if(href_list["cult_cheating"])
			C.religion.favor = 100000
			C.religion.piety = 100000
			// All aspects
			var/list/L = subtypesof(/datum/aspect)
			for(var/type in L)
				L[type] = 1
			C.religion.add_aspects(L)

		if(href_list["cult_leader"])
			var/mob/living/carbon/human/H = M.current
			H.mind.holy_role = CULT_ROLE_MASTER
			add_antag_hud("hudheadcultist")
	else
		to_chat(M.current, "Сначала добавьте культиста во фракцию культа")

/datum/role/cultist/leader
	name = CULT_LEADER

	antag_hud_type = ANTAG_HUD_CULT
	antag_hud_name = "hudheadcultist"

	holy_rank = CULT_ROLE_MASTER
	skillset_type = /datum/skillset/cultist/leader
	change_to_maximum_skills = FALSE

	var/datum/action/innate/cult/master/finalreck/reckoning = new// /datum/action/innate/cult/master/finalreck(owner)

/datum/role/cultist/leader/OnPostSetup(laterole=TRUE)
	. = ..()
	if(!cult_religion.reckoning_complete)
		reckoning.Grant(antag.current)

/datum/role/cultist/leader/Destroy()
	QDEL_NULL(reckoning)

/*
/obj/effect/proc_holder/spell/targeted/communicate
	name = "Сообщить"
	desc = "Позволяет отправить сообщение всем в твоей религии"

	charge_max = 400
	clothes_req = 0
	range = -1
	max_targets = 1
	include_user = 1

	action_icon_state = "cult_comms"
	action_background_icon_state = "bg_cult"
	*/
	/*var/obj/effect/proc_holder/spell/targeted/communicate/spell = locate(/obj/effect/proc_holder/spell/targeted/communicate) in M.spell_list
	if(spell)
		M.RemoveSpell(spell)*/
/datum/action/innate/cult/master/IsAvailable()
	if(!owner.mind || !iscultist(owner) || cult_religion.reckoning_complete)
		return FALSE
	return ..()

/datum/action/innate/cult/master/finalreck
	name = "Final Reckoning"
	//desc = "A single-use spell that brings the entire cult to the master's location."
	button_icon_state = "sintouch"
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUNNED | AB_CHECK_ALIVE
	action_type = AB_INNATE

/datum/action/innate/cult/master/finalreck/Grant(mob/living/T)
	if(T)
		target = T //Useless shit. Feel free to delete it anytime if you have solution to it
	..()

/datum/action/innate/cult/master/finalreck/Activate()
	var/datum/role/cultist/R = owner.mind.GetRole(CULTIST)
	//var/datum/antagonist/cult/antag = iscultist(owner)//owner.mind.has_antag_datum(/datum/antagonist/cult,TRUE)
	if(!R)
		return
	/*var/place = get_area(owner)
	var/datum/objective/eldergod/summon_objective = locate() in antag.cult_team.objectives
	if(place in summon_objective.summon_spots)//cant do final reckoning in the summon area to prevent abuse, you'll need to get everyone to stand on the circle!
		to_chat(owner, "<span class='cult'>The veil is too weak here! Move to an area where it is strong enough to support this magic.</span>")
		return*/
	for(var/i in 1 to 4)
		chant(i)
		to_chat(world,"[i]")
		var/list/destinations = list()
		for(var/turf/T in orange(1, owner))
			if(!T.is_blocked_turf(TRUE))
				destinations += T
		if(!destinations.len)
			to_chat(owner, "<span class='warning'>You need more space to summon your cult!</span>")
			return
		to_chat(world,"do after")
		if(do_after(owner, 30, target = owner))
			for(var/datum/mind/B in cult_religion.members)
				if(B.current && B.current.stat != DEAD)
					var/turf/mobloc = get_turf(B.current)
					switch(i)
						if(1)
							new /obj/effect/temp_visual/cult/sparks(mobloc, B.current.dir)
							playsound(mobloc, "sparks", 50, VOL_EFFECTS_MASTER, extrarange = -3)
						if(2)
							new /obj/effect/temp_visual/dir_setting/cult/phase/out(mobloc, B.current.dir)
							playsound(mobloc, "sparks", 75, VOL_EFFECTS_MASTER)
						if(3)
							new /obj/effect/temp_visual/dir_setting/cult/phase(mobloc, B.current.dir)
							playsound(mobloc, "sparks", 100, VOL_EFFECTS_MASTER, extrarange = 5)
						if(4)
							playsound(mobloc, 'sound/magic/exit_blood.ogg', 100, TRUE)
							if(B.current != owner)
								var/turf/final = pick(destinations)
								if(istype(B.current.loc, /obj/item/device/soulstone))
									var/obj/item/device/soulstone/S = B.current.loc
									for(var/mob/living/simple_animal/shade/A in S)
										A.remove_status_flags(GODMODE)
										A.canmove = TRUE
										to_chat(A, "<b>Вы были освобождены из своей тюрьмы, но вы остаётесь привязанным к [owner.name] и его союзникам. Помогайте им добиться их целей любой ценой.</b>")
										A.forceMove(get_turf(owner))
										A.cancel_camera()
										S.icon_state = "soulstone"
								B.current.set_dir(SOUTH)
								new /obj/effect/temp_visual/cult/blood(final)
								addtimer(CALLBACK(B.current, /mob/.proc/reckon, final), 10)
					to_chat(world,"[B]")
		else return
	cult_religion.reckoning_complete = TRUE
	//owner.religion.reckoning_complete = TRUE
	Remove(owner)

/mob/proc/reckon(turf/final)
	new /obj/effect/temp_visual/cult/blood/out(get_turf(src))
	forceMove(final)

/datum/action/innate/cult/master/finalreck/proc/chant(chant_number)
	switch(chant_number)
		if(1)
			owner.say("C'arta forbici!", 50, VOL_EFFECTS_MASTER, extrarange = -3)
		if(2)
			owner.say("Pleggh e'ntrath!")
			playsound(get_turf(owner),'sound/magic/narsie_attack.ogg', 50, VOL_EFFECTS_MASTER)
		if(3)
			owner.say("Barhah hra zar'garis!")
			playsound(get_turf(owner),'sound/magic/narsie_attack.ogg', 75, VOL_EFFECTS_MASTER, extrarange = 1)
		if(4)
			owner.say("N'ath reth sh'yro eth d'rekkathnor!!")
			playsound(get_turf(owner),'sound/magic/narsie_attack.ogg', 100, VOL_EFFECTS_MASTER, extrarange = 5)
	to_chat(world,"[chant_number]")
