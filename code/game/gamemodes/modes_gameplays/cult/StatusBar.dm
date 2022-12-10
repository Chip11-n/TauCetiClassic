
/mob/verb/cult_status()
	set name = "cult Status"
	set desc = "Check the status of the cult."
	set category = "Ghost"

	if(cult_religion)
		cult_religion.cult_ui.open_cult_status(src)

/datum/cult_status_ui
	var/name = "Cult Status"

	// Data to pass when rendering the UI (not static)
	var/total_cultists
	var/list/cultist_counts
	var/list/cultist_vitals
	var/list/cultists_keys
	var/list/cultist_info

	var/data_initialized = FALSE

	var/datum/religion/cult/assoc_cult = null

/datum/cult_status_ui/New(datum/religion/cult/cult)
	assoc_cult = cult
	update_all_data()
	START_PROCESSING(SSprocessing, src)

/datum/cult_status_ui/process()
	update_cultist_vitals()
	update_cultist_info(FALSE)
	SStgui.update_uis(src)

// Updates the list tracking how many xenos there are in each tier, and how many there are in total
/datum/cult_status_ui/proc/update_cultist_counts(send_update = TRUE)
	cultist_counts = assoc_cult.members.len

	total_cultists = 0
	for(var/counts in cultist_counts)
		for(var/caste in counts)
			total_cultists += counts[caste]

	if(send_update)
		SStgui.update_uis(src)

	//cultist_counts[1] &= ~"Eminence"

/*
	// Also update the amount of T2/T3 slots
	//tier_slots = assoc_cult.get_tier_slots()
// Updates the cult location using the area name of the defined cult location turf
/datum/cult_status_ui/proc/update_cult_location(send_update = TRUE)
	if(!assoc_cult.cult_location)
		return

	cult_location = get_area_name(assoc_cult.cult_location)

	if(send_update)
		SStgui.update_uis(src)
*/
// Updates the sorted list of all xenos that we use as a key for all other information
/datum/cult_status_ui/proc/update_cultists_keys(send_update = TRUE)
	cultists_keys = get_cultists_keys()

	if(send_update)
		SStgui.update_uis(src)

/datum/cult_status_ui/proc/get_cultists_keys()
	var/list/xenos[assoc_cult.members.len]

	var/index = 1
	for(var/mob/living/X in assoc_cult.members)
		// Insert without doing list merging
		xenos[index++] = list(
			"nicknumber" = X.real_name,
			"is_queen" = iseminence(X),
			"caste_type" = X.mind.assigned_job
		)

	return xenos
// Mildly related to the above, but only for when xenos are removed from the cult
// If a xeno dies, we don't have to regenerate all xeno info and sort it again, just remove them from the data list
/datum/cult_status_ui/proc/xeno_removed(mob/living/X)
	if(!cultists_keys)
		return

	for(var/index in 1 to length(cultists_keys))
		var/list/info = cultists_keys[index]
		if(info["nicknumber"] == X.real_name)

			// tried Remove(), didn't work. *shrug*
			cultists_keys[index] = null
			cultists_keys -= null
			return

	SStgui.update_uis(src)

// Updates the list of xeno names, strains and references
/datum/cult_status_ui/proc/update_cultist_info(send_update = TRUE)
	cultist_info = get_cultist_info()

	if(send_update)
		SStgui.update_uis(src)

// Returns a list with some more info about all xenos in the cult
/datum/cult_status_ui/proc/get_cultist_info()
	var/list/xenos = list()

	for(var/mob/living/X in assoc_cult.members)

		var/xeno_name = X.name
		xenos["[X.real_name]"] = list(
			"name" = xeno_name,
			"strain" = X.mind.assigned_job,
			"ref" = "\ref[X]"
		)

	return xenos
// Updates vital information about xenos such as health and location. Only info that should be updated regularly
/datum/cult_status_ui/proc/update_cultist_vitals()
	cultist_vitals = get_cultist_vitals()
/*
// Updates how many buried larva there are
/datum/cult_status_ui/proc/update_pooled_larva(send_update = TRUE)
	pooled_larva = assoc_cult.stored_larva
	/*if(SSxevolution)
		evilution_level = SSxevolution.get_evolution_boost_power(assoc_cult.cultnumber)
	else
		evilution_level = 1*/

	if(send_update)
		SStgui.update_uis(src)
*/

// Returns a list of xeno healths and locations
/datum/cult_status_ui/proc/get_cultist_vitals()
	var/list/xenos = list()

	for(var/mob/living/X in assoc_cult.members)
		var/area/A = get_area(X)
		var/area_name = "Unknown"
		if(A)
			area_name = A.name

		xenos["[X.real_name]"] = list(
			"health" = round((X.health / X.maxHealth) * 100, 1),
			"area" = area_name,
			"is_ssd" = (!X.client)
		)

	return xenos

// Updates all data except pooled larva
/datum/cult_status_ui/proc/update_all_xeno_data(send_update = TRUE)
	update_cultist_counts(FALSE)
	update_cultist_vitals()
	update_cultists_keys(FALSE)
	update_cultist_info(FALSE)

	if(send_update)
		SStgui.update_uis(src)

// Updates all data, including pooled larva
/datum/cult_status_ui/proc/update_all_data()
	data_initialized = TRUE
	update_all_xeno_data(FALSE)
	SStgui.update_uis(src)
/*
/datum/cult_status_ui/tgui_state(mob/user)
	return "Blood"
*/
/datum/cult_status_ui/tgui_status(mob/user, datum/tgui_state/state)
	return UI_INTERACTIVE
	//if(isobserver(user))
	//	return UI_INTERACTIVE

/datum/cult_status_ui/tgui_data(mob/user)
	. = list()
	.["total_cultists"] = total_cultists
	.["cultist_counts"] = cultist_counts
	.["cultists_keys"] = cultists_keys
	.["cultist_info"] = cultist_info
	.["cultist_vitals"] = cultist_vitals

	var/area/A = get_area(assoc_cult.eminence)
	.["eminence_location"] = get_area_name(A)

/datum/cult_status_ui/tgui_static_data(mob/user)
	. = list()
	.["user_ref"] = REF(user)
	.["cult_color"] = COLOR_CRIMSON_RED
	.["cult_name"] = assoc_cult.name

/datum/cult_status_ui/proc/open_cult_status(var/mob/user)
	if(!user)
		return

	// Update absolutely all data
	if(!data_initialized)
		update_all_data()

	tgui_interact(user)

/datum/cult_status_ui/tgui_interact(mob/user, datum/tgui/ui)
	if(!assoc_cult)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "StatusBar", "[assoc_cult.name] Status")
		ui.open()
		ui.set_autoupdate(FALSE)
/*
/datum/cult_status_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)/*
		if("give_plasma")
			var/mob/living/Target = locate(params["target_ref"]) in GLOB.living_xeno_list
			var/mob/living/Src = ui.user

			if(QDELETED(Target) || Target.stat == DEAD || is_admin_level(Target.z))
				return

			if(src.stat == DEAD)
				return

			var/datum/action/xeno_action/A = get_xeno_action_by_type(src, /datum/action/xeno_action/activable/queen_give_plasma)
			A?.use_ability_wrapper(Target)
*/
		if("heal")
			var/mob/living/Target = locate(params["target_ref"]) in GLOB.living_xeno_list
			var/mob/living/Src = ui.user

			if(QDELETED(Target) || Target.stat == DEAD || is_admin_level(Target.z))
				return

			if(src.stat == DEAD)
				return

			var/datum/action/xeno_action/A = get_xeno_action_by_type(src, /datum/action/xeno_action/activable/queen_heal)
			A?.use_ability_wrapper(Target, TRUE)

		if("overwatch")
			var/mob/living/Target = locate(params["target_ref"]) in GLOB.living_xeno_list
			var/mob/living/Src = ui.user

			if(QDELETED(Target) || Target.stat == DEAD || is_admin_level(Target.z))
				return

			if(src.stat == DEAD)
				if(isobserver(src))
					var/mob/dead/observer/O = src
					O.ManualFollow(Target)
				return

			if(!src.check_state(TRUE))
				return

			var/isQueen = (src.caste_type == XENO_CASTE_QUEEN)
			if (isQueen)
				src.overwatch(Target, movement_event_handler = /datum/event_handler/xeno_overwatch_onmovement/queen)
			else
				src.overwatch(Target)
*/
