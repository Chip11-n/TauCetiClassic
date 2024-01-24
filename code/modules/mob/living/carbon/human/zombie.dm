/obj/item/weapon/melee/zombie_hand
	name = "zombie claw"
	desc = "A zombie's claw is its primary tool, capable of infecting \
			humans, butchering all other living things to \
			sustain the zombie, smashing open airlock doors and opening \
			child-safe caps on bottles."
	flags = NODROP | ABSTRACT | DROPDEL
	icon = 'icons/effects/blood.dmi'
	icon_state = "bloodhand_left"
	force = 16
	w_class = SIZE_BIG
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	hitsound = list('sound/voice/growl1.ogg')

	attack_verb = list("bitten and scratched", "scratched")

/obj/item/weapon/melee/zombie_hand/right
	icon_state = "bloodhand_right"

/obj/item/weapon/melee/zombie_hand/afterattack(atom/target, mob/user, proximity, params)
	if(!proximity)
		return

	if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = target

		if(A.welded || A.locked)
			breakairlock(user, A)
		else
			opendoor(user, A)

	if(istype(target, /obj/machinery/door/firedoor))
		var/obj/machinery/door/firedoor/A = target

		if(A.blocked)
			breakfiredoor(user, A)
		else
			opendoor(user, A)

	if(isobj(target))
		var/obj/O = target
		if(O.can_buckle && O.buckled_mob)
			O.user_unbuckle_mob(user)

/obj/item/weapon/melee/zombie_hand/proc/opendoor(mob/user, obj/machinery/door/A)
	if(!A.density)
		return
	else if(!user.is_busy(A))
		user.visible_message("<span class='warning'>[user] starts to force the door to open with [src]!</span>",\
							 "<span class='warning'>You start forcing the door to open.</span>",\
							 "<span class='warning'>You hear metal strain.</span>")
		playsound(A, 'sound/effects/metal_creaking.ogg', VOL_EFFECTS_MASTER, null, FALSE)
		if(do_after(user, 70, target = A))
			if(A.density && user.Adjacent(A))
				user.visible_message("<span class='warning'>[user] forces the door to open with [src]!</span>",\
									 "<span class='warning'>You force the door to open.</span>",\
									 "<span class='warning'>You hear a metal screeching sound.</span>")
				A.open(1)

/obj/item/weapon/melee/zombie_hand/proc/breakairlock(mob/user, obj/machinery/door/airlock/A)
	if(!A.density)
		return
	else if(!user.is_busy(A))
		var/attempts = 0
		while(A)
			user.visible_message("<span class='warning'>[user] attempts to break open the airlock with [src]!</span>",\
								 "<span class='warning'>You attempt to break open the airlock.</span>",\
								 "<span class='warning'>You hear metal strain.</span>")
			playsound(A, 'sound/effects/metal_creaking.ogg', VOL_EFFECTS_MASTER, null, FALSE)
			if(do_after(user, 100, target = A))
				if(A && A.density && user.Adjacent(A))
					if(attempts >= 2 && prob(attempts*5))
						user.visible_message("<span class='warning'>[user] broke the airlock with [src]!</span>",\
											 "<span class='warning'>You break the airlock.</span>",\
											 "<span class='warning'>You hear a metal screeching sound.</span>")
						A.door_rupture(user)
						playsound(src, pick('sound/effects/explosion1.ogg', 'sound/effects/explosion2.ogg'), VOL_EFFECTS_MASTER)
						return
				else
					return
				attempts++
			else
				return

/obj/item/weapon/melee/zombie_hand/proc/breakfiredoor(mob/user, obj/machinery/door/firedoor/A)
	if(!A.density)
		return
	else if(!user.is_busy(A))
		user.visible_message("<span class='warning'>[user] attempts to break open the emergency shutter with [src]!</span>",\
							 "<span class='warning'>You attempt to break open the emergency shutter.</span>",\
							 "<span class='warning'>You hear metal strain.</span>")
		playsound(A, 'sound/effects/metal_creaking.ogg', VOL_EFFECTS_MASTER, null, FALSE)
		if(do_after(user, 200, target = A))
			if(A.density && user.Adjacent(A))
				user.visible_message("<span class='warning'>[user] broke the emergency shutter with [src]!</span>",\
									 "<span class='warning'>You break the emergency shutter.</span>",\
									 "<span class='warning'>You hear a metal screeching sound.</span>")
				A.blocked = FALSE
				A.open(1)

/obj/item/weapon/melee/zombie_hand/attack(mob/M, mob/user)
	. = ..()
	if(. && ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!iszombie(H))
			var/target_zone = user.get_targetzone()

			if((target_zone == BP_HEAD || target_zone == BP_CHEST) && prob(40))
				target_zone = pick(BP_L_ARM, BP_R_ARM)
			if(target_zone == BP_GROIN && prob(40))
				target_zone = pick(BP_L_LEG, BP_R_LEG)

			H.infect_zombie_virus(target_zone)

/datum/species/zombie/on_life(mob/living/carbon/human/H)
	if(!H.life_tick % 3)
		return
	var/obj/item/organ/external/LArm = H.bodyparts_by_name[BP_L_ARM]
	var/obj/item/organ/external/RArm = H.bodyparts_by_name[BP_R_ARM]
	var/obj/item/organ/internal/eyes = H.bodyparts_by_name[O_EYES]
	var/obj/item/organ/internal/brain = H.bodyparts_by_name[O_BRAIN]
	if(eyes)
		eyes.damage = 0
	if(brain)
		brain.damage = 0
	H.setBlurriness(0)
	H.eye_blind = 0

	if(LArm && !(LArm.is_stump) && !istype(H.l_hand, /obj/item/weapon/melee/zombie_hand))
		H.drop_l_hand()
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/zombie_hand, SLOT_L_HAND)
	if(RArm && !(RArm.is_stump) && !istype(H.r_hand, /obj/item/weapon/melee/zombie_hand/right))
		H.drop_r_hand()
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/zombie_hand/right, SLOT_R_HAND)

	if(H.stat != DEAD && prob(10))
		playsound(H, pick(spooks), VOL_EFFECTS_MASTER)

/datum/species/zombie/handle_death(mob/living/carbon/human/H, gibbed) //Death of zombie
	if(gibbed)
		return
	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, prerevive_zombie)), rand(600,700))
	to_chat(H, "<span class='cult'>Твоё сердце останавливается, но голод так и не унялся... \
		Как и жизнь не покинула твоё бездыханное тело. Ты чувствуешь лишь ненасытный голод, \
		который даже сама смерть не способна заглушить, ты восстанешь вновь!</span>")

/mob/living/carbon/human/proc/prerevive_zombie()
	var/obj/item/organ/external/BP = bodyparts_by_name[BP_HEAD]
	if(organs_by_name[O_BRAIN] && BP && !(BP.is_stump))
		if(!key && mind)
			for(var/mob/dead/observer/ghost in player_list)
				if(ghost.mind == mind && ghost.can_reenter_corpse)
					var/answer = tgui_alert(ghost,"You are about to turn into a zombie. Do you want to return to body?","I'm a zombie!", list("Yes","No"))
					if(answer == "Yes")
						ghost.reenter_corpse()

		visible_message("<span class='danger'>[src]'s body starts to move!</span>")
		addtimer(CALLBACK(src, PROC_REF(revive_zombie)), 40)

/mob/living/carbon/human/proc/revive_zombie()
	var/obj/item/organ/external/BP = bodyparts_by_name[BP_HEAD]
	if(!organs_by_name[O_BRAIN] || !BP || BP.is_stump)
		return

	if(!iszombie(src))
		zombify()

	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	setHalLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)
	setDrugginess(0)
	SetSleeping(0)
	SetDrunkenness(0)

	nutrition = NUTRITION_LEVEL_NORMAL
	radiation = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())
	restore_blood()
	// make the icons look correct
	if(HUSK in mutations)
		mutations.Remove(HUSK)

	if(reagents)
		reagents.clear_reagents()

	suiciding = FALSE

	//remove all sight effects
	cure_nearsighted(list(EYE_DAMAGE_TRAIT, GENETIC_MUTATION_TRAIT, EYE_DAMAGE_TEMPORARY_TRAIT))
	sdisabilities &= ~BLIND
	blinded = FALSE
	setBlurriness(0)
	handle_vision(TRUE)

	ear_deaf = 0
	ear_damage = 0

	shock_stage = 0
	var/obj/item/organ/internal/heart/Heart = organs_by_name[O_HEART]
	Heart?.heart_normalize()

	restore_all_bodyparts()
	restore_all_organs()
	cure_all_viruses()

	// remove the character from the list of the dead
	if(stat == DEAD)
		dead_mob_list -= src
		alive_mob_list += src
		tod = null
		timeofdeath = 0
	stat = CONSCIOUS
	update_canmove()
	regenerate_icons()
	med_hud_set_health()
	clear_alert("embeddedobject")

	playsound(src, pick(list('sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/wail.ogg')), VOL_EFFECTS_MASTER)
	to_chat(src, "<span class='cult'>Твой голод всё также ненасытен! Пора его утолить!</span>")
	visible_message("<span class='danger'>[src] suddenly wakes up!</span>")

/mob/living/carbon/proc/is_infected_with_zombie_virus()
	for(var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		for(var/datum/disease2/effectholder/e in V.effects)
			if(istype(e.effect, /datum/disease2/effect/zombie))
				return TRUE
	return FALSE

/mob/living/carbon/human/handle_vision()
	if(iszombie(src))
		return
	return ..()

/mob/living/carbon/human/update_eye_blur()
	if(iszombie(src))
		return
	return ..()

/mob/living/carbon/human/embed(obj/item/I)
	if(species.flags[NO_EMBED])
		return
	return ..()

/mob/living/carbon/human/proc/infect_zombie_virus(target_zone = null, forced = FALSE, fast = FALSE)
	if(!forced && !prob(get_bite_infection_chance(src, target_zone)))
		return

	for(var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		for(var/datum/disease2/effectholder/e in V.effects)
			if(istype(e.effect, /datum/disease2/effect/zombie)) //Already infected
				e.chance = min(100, e.chance + 10) //Make virus develop faster
				V.cooldown_mul = min(3, V.cooldown_mul + 1)
				return

	var/datum/disease2/disease/D = new /datum/disease2/disease
	var/datum/disease2/effectholder/holder = new /datum/disease2/effectholder
	var/datum/disease2/effect/zombie/Z = new /datum/disease2/effect/zombie
	if(target_zone)
		Z.infected_organ = get_bodypart(target_zone)
	holder.effect = Z
	holder.chance = rand(holder.effect.chance_minm, holder.effect.chance_maxm)
	if(fast)
		holder.chance = 100
	D.addeffect(holder)
	D.uniqueID = rand(0,10000)
	D.infectionchance = 100
	D.antigen |= ANTIGEN_Z
	D.spreadtype = DISEASE_SPREAD_BLOOD // not airborn and not contact, because spreading zombie virus through air or hugs is silly

	infect_virus2(src, D, forced = TRUE, ignore_antibiotics = TRUE)

/mob/living/carbon/human/proc/zombify()
	if(iszombie(src))
		return

	switch(species.name)
		if(TAJARAN)
			set_species(ZOMBIE_TAJARAN, TRUE, TRUE)
		if(SKRELL)
			set_species(ZOMBIE_SKRELL, TRUE, TRUE)
		if(UNATHI)
			set_species(ZOMBIE_UNATHI, TRUE, TRUE)
		else
			set_species(ZOMBIE, TRUE, TRUE)

	to_chat(src, "<span class='cult large'>Ты ГОЛОДЕН!</span><br>\
	<span class='cult'>Теперь ты зомби! Не пытайся вылечиться, не вреди своим собратьям мёртвым, не помогай какому бы то ни было не-зомби. \
	Теперь ты - воплощение голода, смерти и жестокости. Распространяй болезнь и УБИВАЙ.</span>")

var/global/list/zombie_list = list()

/proc/add_zombie(mob/living/carbon/human/H)
	H.AddSpell(new /obj/effect/proc_holder/spell/targeted/zombie_findbrains)
	zombie_list += H

	var/datum/faction/zombie/Z = create_uniq_faction(/datum/faction/zombie)
	add_faction_member(Z, H, FALSE)

/proc/remove_zombie(mob/living/carbon/human/H)
	var/obj/effect/proc_holder/spell/targeted/zombie_findbrains/spell = locate() in H.spell_list
	H.RemoveSpell(spell)
	qdel(spell)
	zombie_list -= H

	var/datum/role/R = H.mind.GetRole(ZOMBIE)
	if(R)
		R.Deconvert()

/obj/effect/proc_holder/spell/targeted/zombie_findbrains
	name = "Find brains"
	desc = "Allows you to sense alive humans."
	panel = "Zombie"
	action_icon_state = "gib"
	charge_max = 300
	clothes_req = 0
	range = -1
	include_user = 1

/obj/effect/proc_holder/spell/targeted/zombie_findbrains/cast(list/targets)
	var/mob/living/carbon/human/user = usr
	var/turf/self_turf = get_turf(user)
	var/mob/living/carbon/human/target = null
	var/min_dist = 999

	for(var/mob/living/carbon/human/H as anything in human_list)
		if(H.stat == DEAD || iszombie(H) || H.z != user.z)
			continue
		var/turf/target_turf = get_turf(H)
		var/target_dist = get_dist(target_turf, self_turf)
		if(target_dist < min_dist)
			min_dist = target_dist
			target = H

	if(!target)
		to_chat(user, "<span class='warning'>You don't sense any brains around</span>")
		return
	//Apply tracker arrow to point to the subject of the message if applicable
	var/atom/movable/screen/arrow/arrow_hud = new ()
	//Prepare the tracker object and set its parameters
	arrow_hud.add_hud(user, target)
	arrow_hud.color = COLOR_RED

/atom/movable/screen/arrow
	name = "Arrow"
	icon = 'icons/hud/screen_gen.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = ui_direction_arrow
	alpha = 128 //translucent
	icon_state = "pointing_arrow"
	///The mob for which the arrow appears
	var/mob/living/carbon/tracker
	///The target which the arrow points to
	var/atom/target
	///The duration of the effect
	var/duration = 15 SECONDS
	///holder for the deletation timer
	var/del_timer

/atom/movable/screen/arrow/proc/add_hud(mob/living/carbon/tracker_input, atom/target_input)
	if(!tracker_input?.client)
		return
	if(target_input == tracker_input)
		return
	tracker = tracker_input
	target = target_input
	tracker.client.screen += src
	RegisterSignal(tracker, COMSIG_PARENT_QDELETING, PROC_REF(kill_arrow))
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(kill_arrow))
	process() //Ping immediately after parameters have been set

///Stop the arrow to avoid runtime and hard del
/atom/movable/screen/arrow/proc/kill_arrow()
	SIGNAL_HANDLER
	tracker.client.screen -= src
	deltimer(del_timer)
	qdel(src)

/atom/movable/screen/arrow/atom_init(mapload, ...) //Self-deletes
	. = ..()
	START_PROCESSING(SSfastprocess, src)
	del_timer = addtimer(CALLBACK(src, PROC_REF(kill_arrow)), duration, TIMER_STOPPABLE)

/atom/movable/screen/arrow/process() //We ping the target, revealing its direction with an arrow
	if(!target || !tracker)
		return PROCESS_KILL
	if(target.z != tracker.z || get_dist(tracker, target) < 3 || tracker == target)
		animate(src, 1 SECOND, alpha = 0)
	else
		if(alpha < 128)
			animate(src, 1 SECOND, alpha = 128)
		transform = 0 //Reset and 0 out
		transform = turn(transform, Get_Angle(tracker, target))

/atom/movable/screen/arrow/Destroy()
	target = null
	tracker = null
	STOP_PROCESSING(SSfastprocess, src)
	return ..()


/obj/item/weapon/reagent_containers/glass/beaker/vial/romerol
	name = "romerol"
	desc = "As if in mockery, someone kindly engraved in small print directly on the glass of the vial: \"Romerol. The REAL zombie powder.\""

/obj/item/weapon/reagent_containers/glass/beaker/vial/romerol/atom_init()
	. = ..()
	reagents.add_reagent("romerol", 15)
	update_icon()

/datum/reagent/romerol
	name = "Romerol"
	id = "romerol"
	// the REAL zombie powder
	description = "Romerol is a highly experimental bioterror agent \
		which causes dormant nodules to be etched into the grey matter of \
		the subject. These nodules only become active upon death of the \
		host, upon which, the secondary structures activate and take control \
		of the host body."
	color = "#123524" // RGB (18, 53, 36)
	custom_metabolism = 1
	taste_message = "brains"
	restrict_species = list(IPC, DIONA, VOX)

/datum/reagent/romerol/on_general_digest(mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.infect_zombie_virus(null, TRUE, TRUE)

/obj/item/weapon/reagent_containers/hypospray/combat/zombie
	name = "biowarfare hypospray"
	desc = "A modified air-needle autoinjector, used by operatives to quickly make warcrimes in the field. This one is left unlabelled."
	volume = 50
	list_reagents = list("romerol" = 50)
	amount_per_transfer_from_this = 5

/obj/item/weapon/reagent_containers/hypospray/autoinjector/romerol
	name = "Z-virus"
	desc = "Makes warcrimes"
	icon_state = "bonepen"
	item_state = "bonepen"
	volume = 35
	list_reagents = list("romerol" = 5, "cyanide" = 30)

/obj/item/weapon/grenade/chem_grenade/romerol
	name = "biowarfare grenade"
	icon_state = "pyrog"
	item_state = "flashbang"
	desc = "A red grenade with an unusual design, a biohazard sign is engraved on the side. Does massive war crimes."
	path = 2
	stage = 2
	det_time = 2 SECONDS

/obj/item/weapon/grenade/chem_grenade/romerol/atom_init()
	. = ..()
	var/obj/item/weapon/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/large/B2 = new(src)
	B1.reagents.add_reagent("sugar", 75)
	B1.reagents.add_reagent("potassium", 75)
	B2.reagents.add_reagent("phosphorus", 75)

	B2.reagents.add_reagent("romerol", 20)
	B1.reagents.add_reagent("cyanide", 55)

	beakers += B1
	beakers += B2

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)
	var/obj/item/device/assembly/timer/tmr = detonator.a_left
	tmr.time = 2

/obj/item/weapon/implanter/zombie
	name = "implanter (Z)"

/obj/item/weapon/implanter/zombie/atom_init()
	imp = new /obj/item/weapon/implant/zombie(src)
	. = ..()
	update()

/obj/item/weapon/implant/zombie
	name = "retaliation"
	desc = "And boom goes the weasel."
	icon_state = "implant_evil"

/obj/item/weapon/implant/zombie/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Retaliation's implant<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Prevent the implant from falling into the hands of the enemy<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains special chemicals that bring the deceased back to life a few seconds after death. Allows you to take revenge on your enemy. Use away from allies.<BR>
<b>Special Features:</b> Replaces the explosion implant<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	return dat

/obj/item/weapon/implant/zombie/inject(mob/living/carbon/C, def_zone)
	. = ..()
	for(var/obj/item/weapon/implant/dexplosive/I in C)
		qdel(I)

/obj/item/weapon/implant/zombie/trigger(emote, source)
	if(emote == "deathgasp")
		activate("death")
	return

/obj/item/weapon/implant/zombie/activate(cause)
	if(!cause || !imp_in)
		return FALSE
	var/mob/living/carbon/human/H = imp_in
	if(!H || !(H.species.name in list(HUMAN, UNATHI, TAJARAN, SKRELL)))
		return FALSE
	if(imp_in.stat != DEAD)
		imp_in.adjustToxLoss(imp_in.maxHealth * 2.5)
		imp_in.death(FALSE)
	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, prerevive_zombie)), 5 SECONDS)
	to_chat(H, "<span class='cult'>Твоё сердце умолкает, а вместе с ним и хладеет твоё тело, и лишь голод начинает разгораться с невиданной силой!</span>")
	qdel(src)

/obj/item/weapon/implant/zombie/islegal()
	return FALSE
