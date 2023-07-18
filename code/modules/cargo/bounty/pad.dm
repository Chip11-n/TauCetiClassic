//Pad & Pad Terminal

//Pad. Has no use without computer.
/obj/machinery/bounty_pad
	name = "civilian bounty pad"
	desc = "A machine designed to send civilian bounty targets to centcom."
	resistance_flags = FIRE_PROOF
	//circuit = /obj/item/circuitboard/machine/bountypadname
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle_old"
	///This is the icon_state that this telepad uses when it's not in use.
	var/idle_state = "pad-idle_old"
	///This is the icon_state that this telepad uses when it's warming up for goods teleportation.
	var/warmup_state = "pad-idle_old"
	///This is the icon_state to flick when the goods are being sent off by the telepad.
	var/sending_state = "pad-beam_old"
	///This is the cargo hold ID used by the piratepad_control. Match these two to link them together.
	var/cargo_hold_id

/obj/machinery/bounty_pad/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(default_deconstruction_screwdriver(user, "pad-idle-o_old", "pad-idle_old", I))
		return

	if(default_pry_open(I))
		return

	default_deconstruction_crowbar(I)

	if(panel_open)
		if(ispulsing(I))
			var/obj/item/device/multitool/M = I
			M.buffer = src
			to_chat(user, "<span class='notice'>You register [src] in [I.name]'s buffer.</span>")
	return ..()

///Computer for assigning new civilian bounties, and sending bounties for collection.
/obj/machinery/computer/bounty_control
	name = "civilian bounty control terminal"
	desc = "A console for assigning civilian bounties to inserted ID cards, and for controlling the bounty pad for export."
	icon_state = "bounty"
	///Message to display on the TGUI window.
	var/status_report = "Ready for delivery."
	///Reference to the specific pad that the control computer is linked up to.
	var/obj/machinery/bounty_pad/pad
	///How long does it take to warmup the pad to teleport?
	var/warmup_time = 3 SECONDS
	///Is the teleport pad/computer sending something right now? TRUE/FALSE
	var/sending = FALSE
	///For the purposes of space pirates, how many points does the control pad have collected.
	var/points = 0
	///Reference to the export report totaling all sent objects and mobs.
	var/datum/export_report/total_report
	///Callback holding the sending timer for sending the goods after a delay.
	var/sending_timer
	//circuit = /obj/item/circuitboard/computer/bountypad
	///Typecast of an inserted, scanned ID card inside the console, as bounties are held within the money account.
	var/obj/item/weapon/card/id/inserted_scan_id
	var/datum/money_account/account

/obj/machinery/computer/bounty_control/atom_init(mapload, obj/item/weapon/circuitboard/C)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/bounty_control/atom_init_late()
	. = ..()
	var/obj/machinery/bounty_pad/P = locate() in range(4, src)
	pad = P

/obj/machinery/computer/bounty_control/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/machinery/computer/bounty_control/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BountyPad", name)
		ui.open()

//obj/machinery/computer/bounty_control/ui_interact(mob/user, datum/tgui/ui)
//	tgui_interact(user)

/// Prepares to sell the items on the pad
/obj/machinery/computer/bounty_control/proc/start_sending(mob/user)
	if(!pad)
		status_report = "No pad detected. Build or link a pad."
		pad.audible_message("<span class='notice'>[pad] beeps.</span>")
		return
	if(pad?.panel_open)
		status_report = "Please screwdrive pad closed to send. "
		pad.audible_message("<span class='notice'>[pad] beeps.</span>")
		return
	if(sending)
		return
	sending = TRUE
	status_report = "Sending... "
	pad.visible_message("<span class='notice'>[pad] starts charging up.</span>")
	pad.icon_state = pad.warmup_state
	sending_timer = addtimer(CALLBACK(src, PROC_REF(send), user), warmup_time, TIMER_STOPPABLE)

/// Finishes the sending state of the pad
/obj/machinery/computer/bounty_control/proc/stop_sending(custom_report)
	if(!sending)
		return
	sending = FALSE
	status_report = "Ready for delivery."
	if(custom_report)
		status_report = custom_report
	pad.icon_state = "pad-idle_old"
	deltimer(sending_timer)

/obj/machinery/computer/bounty_control/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/weapon/card/id))
		if(id_insert(user, I, inserted_scan_id))
			inserted_scan_id = I
			account = get_account(inserted_scan_id.associated_account_number)
			return TRUE

	if(ispulsing(I))
		var/obj/item/device/multitool/M = I
		if(M.buffer && istype(M.buffer, /obj/machinery/bounty_pad))
			pad = M.buffer

/obj/machinery/computer/bounty_control/proc/recalc()
	if(sending)
		return FALSE
	if(!inserted_scan_id)
		status_report = "Please insert your ID first."
		playsound(loc, 'sound/machines/synth_no.ogg', VOL_EFFECTS_MASTER)
		return FALSE
	if(!account.civilian_bounty)
		status_report = "Please accept a new civilian bounty first."
		playsound(loc, 'sound/machines/synth_no.ogg', VOL_EFFECTS_MASTER)
		return FALSE
	status_report = "Civilian Bounty: "
	for(var/atom/movable/AM in get_turf(pad))
		if(AM == pad)
			continue
		if(account.civilian_bounty.applies_to(AM))
			status_report += "Target Applicable."
			playsound(loc, 'sound/machines/synth_yes.ogg', VOL_EFFECTS_MASTER)
			return
	status_report += "Not Applicable."
	playsound(loc, 'sound/machines/synth_no.ogg', VOL_EFFECTS_MASTER)

/**
 * This fully rewrites base behavior in order to only check for bounty objects, and nothing else.
 */
/obj/machinery/computer/bounty_control/proc/send(mob/user)
	playsound(loc, 'sound/machines/wewewew.ogg', VOL_EFFECTS_MASTER)
	if(!sending)
		return
	if(!inserted_scan_id)
		stop_sending()
		return FALSE
	if(!account || !account.civilian_bounty)
		stop_sending()
		return FALSE
	var/datum/bounty/curr_bounty = account.civilian_bounty
	var/active_stack = 0
	for(var/atom/movable/AM in get_turf(pad))
		if(AM == pad)
			continue
		if(curr_bounty.applies_to(AM))
			active_stack ++
			curr_bounty.ship(AM)
			qdel(AM)
	if(active_stack >= 1)
		status_report += "Bounty Target Found x[active_stack]. "
	else
		status_report = "No applicable targets found. Aborting."
		stop_sending()
	if(curr_bounty.can_claim())
		//Pay for the bounty with the ID's department funds.
		status_report += "Bounty completed!"
		account.reset_bounty()
		var/datum/money_account/D = global.department_accounts["Cargo"]
		charge_to_account(account.account_number, "Bounty", "Bounty Reward", "Centomm", (curr_bounty.reward) * (CIV_BOUNTY_SPLIT/100))
		charge_to_account(D.account_number, "Bounty Share", "Bounty Reward Share", "Centomm", curr_bounty.reward * (100 - CIV_BOUNTY_SPLIT) / 100)

	pad.visible_message("<span class='notice'>[pad] activates!</span>")
	flick(pad.sending_state,pad)
	pad.icon_state = "pad-idle_old"
	playsound(loc, 'sound/machines/synth_yes.ogg', VOL_EFFECTS_MASTER)
	sending = FALSE

	if(Adjacent(user))
		tgui_interact(user)

///Here is where cargo bounties are added to the player's bank accounts, then adjusted and scaled into a civilian bounty.
/obj/machinery/computer/bounty_control/proc/add_bounties()
	if(!inserted_scan_id || !account)
		return
	var/mob/user = usr
	if((account.civilian_bounty || account.bounties) && !COOLDOWN_FINISHED(account, bounty_timer))
		var/curr_time = round((COOLDOWN_TIMELEFT(account, bounty_timer)) / (1 MINUTES), 0.01)
		to_chat(user, "Internal ID network spools coiling, try again in [curr_time] minutes!")
		return FALSE
	if(!account)
		to_chat(user, "Requesting ID card has no job assignment registered!")
		return FALSE
	var/datum/job/J = SSjob.GetJob(inserted_scan_id.rank)
	var/list/datum/bounty/crumbs = list(random_bounty(J.bounty_types), // We want to offer 2 bounties from their appropriate job catagories
										random_bounty(J.bounty_types), // and 1 guarenteed assistant bounty if the other 2 suck.
										random_bounty(CIV_JOB_BASIC))
	COOLDOWN_START(account, bounty_timer, 5 MINUTES)
	account.bounties = crumbs

/obj/machinery/computer/bounty_control/proc/pick_bounty(choice)
	if(!inserted_scan_id || !account || !account.bounties || !account.bounties[choice])
		playsound(loc, 'sound/machines/synth_no.ogg', VOL_EFFECTS_MASTER)
		return
	account.civilian_bounty = account.bounties[choice]
	account.bounties = null
	return account.civilian_bounty

/obj/machinery/computer/bounty_control/AltClick(mob/user)
	. = ..()
	if(Adjacent(user))
		id_eject(user, inserted_scan_id)

/obj/machinery/computer/bounty_control/tgui_data(mob/user)
	var/list/data = list()
	data["points"] = points
	data["pad"] = pad ? TRUE : FALSE
	data["sending"] = sending
	data["status_report"] = status_report
	data["id_inserted"] = inserted_scan_id
	if(account)
		if(account.civilian_bounty)
			data["id_bounty_info"] = account.civilian_bounty.description
			data["id_bounty_num"] = account.bounty_num()
			data["id_bounty_value"] = (account.civilian_bounty.reward) * (CIV_BOUNTY_SPLIT/100)
		else
			data["id_bounty_info"] = null
			data["id_bounty_num"] = null
			data["id_bounty_value"] = null
		if(account.bounties)
			data["picking"] = TRUE
			data["id_bounty_names"] = list(account.bounties[1].name,
											account.bounties[2].name,
											account.bounties[3].name)
			data["id_bounty_values"] = list(account.bounties[1].reward * (CIV_BOUNTY_SPLIT/100),
											account.bounties[2].reward * (CIV_BOUNTY_SPLIT/100),
											account.bounties[3].reward * (CIV_BOUNTY_SPLIT/100))
		else
			data["picking"] = FALSE
	else
		data["id_bounty_info"] = null
		data["id_bounty_num"] = null
		data["id_bounty_value"] = null


	return data

/obj/machinery/computer/bounty_control/tgui_act(action, params)
	. = ..()
	if(.)
		return
	if(!pad)
		return
	switch(action)
		if("recalc")
			recalc()
		if("send")
			start_sending(usr)
		if("stop")
			stop_sending()
		if("pick")
			pick_bounty(params["value"])
		if("bounty")
			add_bounties(usr)
		if("eject")
			id_eject(usr, inserted_scan_id)
	. = TRUE

///Self explanitory, holds the ID card in the console for bounty payout and manipulation.
/obj/machinery/computer/bounty_control/proc/id_insert(mob/user, obj/item/item, obj/item/target)
	if(target)
		to_chat(user, "<span class='warning'>There is something inside!</span>")
		return

	user.drop_from_inventory(item, src)
	user.visible_message("<span class='notice'>[user] inserts \the [item] into \the [src].</span>",
						"<span class='notice'>You insert \the [item] into \the [src].</span>")
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', VOL_EFFECTS_MASTER)
	tgui_interact(user)
	return TRUE

///Removes A stored ID card.
/obj/machinery/computer/bounty_control/proc/id_eject(mob/user, obj/target)
	if(!target)
		to_chat(user, "<span class='warning'>That slot is empty!</span>")
		return FALSE

	if(!issilicon(user) && Adjacent(user))
		user.put_in_hands(target)
	user.visible_message("<span class='notice'>[user] gets \the [target] from \the [src].</span>", \
						"<span class='notice'>You get \the [target] from \the [src].</span>")
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', VOL_EFFECTS_MASTER)
	inserted_scan_id = null
	account = null
	tgui_interact(user)
	return TRUE
