//Used to nominate oneself or ghosts for the role of Eminence.
/obj/structure/eminence_spire
	name = "eminence spire"
	desc = "This spire is used to become the Eminence, who functions as an invisible leader of the cult. Activate it to nominate yourself or propose that the Eminence should be \
	selected from available ghosts. Once an Eminence is selected, they can't normally be changed."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "spire"
	max_integrity = 1500
	pixel_x = -16
	pixel_y = -2
	var/mob/eminence_nominee //Exactly for mob that wants to be an eminence
	var/ghost_nomination = FALSE
	var/selection_timer //Timer ID; this is canceled if the vote is canceled
	var/kingmaking

//Returns a list of all servants of Ratvar and observers.
/proc/servants_and_ghosts()
	. = list()
	for(var/V in player_list)
		if(iscultist(V) || isobserver(V))
			. += V

//Used to nominate oneself or ghosts for the role of Eminence.
/obj/structure/eminence_spire/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!iscultist(user))
		to_chat(user, "<span class='notice'>You can tell how powerful [src] is; you know better than to touch it.</span>")
		return
	if(kingmaking)
		return

	if(!global.cult_religion)
		to_chat(user, "<span class='warning'>The Heaven isn't awake!</span>")
		return
	if(global.cult_religion.eminence)
		to_chat(user, "<span class='warning'>There's already an Eminence!</span>")
		return
	if(eminence_nominee || ghost_nomination) //This could be one large proc, but is split into three for ease of reading
		if(eminence_nominee == user)
			cancelation(user)
		else
			objection(user)
	else
		nomination(user)

//Used to nominate oneself or ghosts for the role of Eminence.
/obj/structure/eminence_spire/attack_animal(mob/living/simple_animal/user)
	if(!iscultist(user))
		..()
	else
		to_chat(user, "<span class='warning'>Вы чувствуете, как всевидящий взгляд превращается в озадаченно нахмуренный. Возможно, вам следует просто продолжить то, что делали до этого.</span>")
		return

//Used to nominate oneself or ghosts for the role of Eminence.
/obj/structure/eminence_spire/proc/nomination(mob/living/nominee) //A user is nominating themselves or ghosts to become Eminence
	var/nomination_choice = tgui_alert(nominee, "Чью кандидатуру вы хотите выдвинуть?", "Номинация Возвышенного", list("Стать самому", "Предложить призракам", "Оставить"))
	if(!iscultist(nominee) || eminence_nominee || ghost_nomination)
		return
	switch(nomination_choice)
		if("Оставить")
			return
		if("Выдвинуть свою кандидатуру")
			eminence_nominee = nominee
			cult_religion.send_message_to_members("<b>[nominee] nominates themselves as the Eminence!</b> You may object by interacting with the eminence spire. The vote will otherwise pass in 30 seconds.")
		if("Предложить призракам")
			ghost_nomination = TRUE
			cult_religion.send_message_to_members("<b>[nominee] proposes selecting an Eminence from ghosts!</b> You may object by interacting with the eminence spire. The vote will otherwise pass in 30 seconds.")
	for(var/mob/M as anything in servants_and_ghosts())
		M.playsound_local(M, 'sound/antag/eminence_hit.ogg', VOL_EFFECTS_MASTER)
	selection_timer = addtimer(CALLBACK(src, .proc/kingmaker), 30 SECONDS, TIMER_STOPPABLE)

//Used to nominate oneself or ghosts for the role of Eminence.
/obj/structure/eminence_spire/proc/objection(mob/living/wright)
	if(tgui_alert(wright, "Возразить против [eminence_nominee] как Возвышенного?", "Возражение!", list("Возразить!", "Отказаться")) == "Отказаться" || !iscultist(wright) || (!eminence_nominee && !ghost_nomination))
		return
	cult_religion.send_message_to_members("<b>[wright] возражает на счёт кандидатуры [eminence_nominee]!</b> Обелиск Возвышенного вновь спокоен.")
	for(var/mob/M as anything in servants_and_ghosts())
		M.playsound_local(M, 'sound/antag/eminence_hit.ogg', VOL_EFFECTS_MASTER)
	eminence_nominee = null
	ghost_nomination = FALSE
	deltimer(selection_timer)

//Used to nominate oneself or ghosts for the role of Eminence.
/obj/structure/eminence_spire/proc/cancelation(mob/living/cold_feet)
	if(tgui_alert(cold_feet, "Отказаться от номинации?", "Отказ от номинации", list("Отказ от номинации", "Оставить")) == "Оставить" || !iscultist(cold_feet) || !eminence_nominee)
		return
	cult_religion.send_message_to_members("<b>[eminence_nominee] исключил свою кандидатуру!</b> Обелиск Возвышенного вновь спокоен.")
	for(var/mob/M in servants_and_ghosts())
		M.playsound_local(M, 'sound/antag/eminence_hit.ogg', VOL_EFFECTS_MASTER)
	eminence_nominee = null
	deltimer(selection_timer)

//Used to nominate oneself or ghosts for the role of Eminence.
/obj/structure/eminence_spire/proc/kingmaker()
	if(!eminence_nominee)
		return
	if(ismob(eminence_nominee))
		if(!eminence_nominee.client || !eminence_nominee.mind)
			cult_religion.send_message_to_members("<b>[eminence_nominee] каким-то образом потерял сознание!</b> Обелиск Возвышенного вновь спокоен.")
			for(var/mob/M as anything in servants_and_ghosts())
				M.playsound_local(M, 'sound/antag/eminence_stop.ogg', VOL_EFFECTS_MASTER)
			eminence_nominee = null
			return
		playsound(eminence_nominee, 'sound/antag/eminence_ready.ogg', VOL_EFFECTS_MASTER)
		eminence_nominee.visible_message("<span class='warning'>Тьма в один миг поглощает [eminence_nominee]!</span>", \
		"<span class='userdanger'>Холодная тьма устремляется к тебе!</span>")
		for(var/obj/item/I in eminence_nominee) //drops all items
			eminence_nominee.drop_from_inventory(I, get_turf(eminence_nominee))
		var/mob/camera/eminence/eminence = new(get_turf(src))
		eminence.mind_initialize()
		eminence.key = eminence_nominee.key
		eminence_nominee.dust()
		eminence.eminence_help()
		cult_religion.send_message_to_members("<span class='large'>[eminence_nominee] стал Возвышенным!</span>")
	else if(ghost_nomination)
		kingmaking = TRUE
		cult_religion.send_message_to_members("<b>Обелиск Возвышенного выбирает себе призрака для превращения в Возвышенного...</b>")
		var/list/candidates = pollGhostCandidates("Хотели бы вы сыграть в роли Возвышенного?", ROLE_CULTIST, IGNORE_EMINENCE, poll_time = 100)
		kingmaking = FALSE
		if(!length(candidates))
			for(var/mob/M as anything in servants_and_ghosts())
				M.playsound_local(M, 'sound/antag/eminence_stop.ogg', VOL_EFFECTS_MASTER)
			cult_religion.send_message_to_members("<b>Ни один из призраков не принял предложение!</b> Обелиск Возвышенного вновь спокоен.")
			ghost_nomination = FALSE
			return
		visible_message("<span class='warning'>Тьма окутывает [src]!</span>")
		var/mob/camera/eminence/eminence = new(get_turf(src))
		eminence_nominee = pick(candidates)
		eminence.key = eminence_nominee.key
		eminence.eminence_help()
		cult_religion.send_message_to_members("<span class='large'>Призрак стал Возвышенным!</span>")
	for(var/mob/M as anything in servants_and_ghosts())
		M.playsound_local(M, 'sound/antag/eminence_ready.ogg', VOL_EFFECTS_MASTER)
	eminence_nominee = null
