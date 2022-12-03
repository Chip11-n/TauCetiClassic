
/mob/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of the hive."
	set category = "Ghost"

	if(cult_religion) // Only one hive, don't need an input menu for that
		cult_religion.hive_ui.open_hive_status(src)

/datum/hive_status_ui
	var/name = "Hive Status"

	// Data to pass when rendering the UI (not static)
	var/total_xenos
	var/list/xeno_counts
	var/list/xeno_vitals
	var/list/xeno_keys
	var/list/xeno_info

	var/data_initialized = FALSE

	var/datum/religion/cult/assoc_hive = null

/datum/hive_status_ui/New(datum/religion/cult/hive)
	assoc_hive = hive
	update_all_data()
	START_PROCESSING(SSprocessing, src)

/datum/hive_status_ui/process()
	update_xeno_vitals()
	update_xeno_info(FALSE)
	SStgui.update_uis(src)

// Updates the list tracking how many xenos there are in each tier, and how many there are in total
/datum/hive_status_ui/proc/update_xeno_counts(send_update = TRUE)
	xeno_counts = assoc_hive.members.len

	total_xenos = 0
	for(var/counts in xeno_counts)
		for(var/caste in counts)
			total_xenos += counts[caste]

	if(send_update)
		SStgui.update_uis(src)

	//xeno_counts[1] &= ~"Eminence"

/*
	// Also update the amount of T2/T3 slots
	//tier_slots = assoc_hive.get_tier_slots()
// Updates the hive location using the area name of the defined hive location turf
/datum/hive_status_ui/proc/update_hive_location(send_update = TRUE)
	if(!assoc_hive.hive_location)
		return

	hive_location = get_area_name(assoc_hive.hive_location)

	if(send_update)
		SStgui.update_uis(src)
*/
// Updates the sorted list of all xenos that we use as a key for all other information
/datum/hive_status_ui/proc/update_xeno_keys(send_update = TRUE)
	xeno_keys = get_xeno_keys()

	if(send_update)
		SStgui.update_uis(src)

/datum/hive_status_ui/proc/get_xeno_keys()
	var/list/xenos[assoc_hive.members.len]

	var/index = 1
	for(var/mob/living/X in assoc_hive.members)
		// Insert without doing list merging
		xenos[index++] = list(
			"nicknumber" = X.real_name,
			"is_queen" = iseminence(X),
			"caste_type" = X.mind.assigned_job
		)

	return xenos
// Mildly related to the above, but only for when xenos are removed from the hive
// If a xeno dies, we don't have to regenerate all xeno info and sort it again, just remove them from the data list
/datum/hive_status_ui/proc/xeno_removed(mob/living/X)
	if(!xeno_keys)
		return

	for(var/index in 1 to length(xeno_keys))
		var/list/info = xeno_keys[index]
		if(info["nicknumber"] == X.real_name)

			// tried Remove(), didn't work. *shrug*
			xeno_keys[index] = null
			xeno_keys -= null
			return

	SStgui.update_uis(src)

// Updates the list of xeno names, strains and references
/datum/hive_status_ui/proc/update_xeno_info(send_update = TRUE)
	xeno_info = get_xeno_info()

	if(send_update)
		SStgui.update_uis(src)

// Returns a list with some more info about all xenos in the hive
/datum/hive_status_ui/proc/get_xeno_info()
	var/list/xenos = list()

	for(var/mob/living/X in assoc_hive.members)

		var/xeno_name = X.name
		xenos["[X.real_name]"] = list(
			"name" = xeno_name,
			"strain" = X.mind.assigned_job,
			"ref" = "\ref[X]"
		)

	return xenos
// Updates vital information about xenos such as health and location. Only info that should be updated regularly
/datum/hive_status_ui/proc/update_xeno_vitals()
	xeno_vitals = get_xeno_vitals()
/*
// Updates how many buried larva there are
/datum/hive_status_ui/proc/update_pooled_larva(send_update = TRUE)
	pooled_larva = assoc_hive.stored_larva
	/*if(SSxevolution)
		evilution_level = SSxevolution.get_evolution_boost_power(assoc_hive.hivenumber)
	else
		evilution_level = 1*/

	if(send_update)
		SStgui.update_uis(src)
*/

// Returns a list of xeno healths and locations
/datum/hive_status_ui/proc/get_xeno_vitals()
	var/list/xenos = list()

	for(var/mob/living/X in assoc_hive.members)
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
/datum/hive_status_ui/proc/update_all_xeno_data(send_update = TRUE)
	update_xeno_counts(FALSE)
	update_xeno_vitals()
	update_xeno_keys(FALSE)
	update_xeno_info(FALSE)

	if(send_update)
		SStgui.update_uis(src)

// Updates all data, including pooled larva
/datum/hive_status_ui/proc/update_all_data()
	data_initialized = TRUE
	update_all_xeno_data(FALSE)
	SStgui.update_uis(src)
/*
/datum/hive_status_ui/tgui_state(mob/user)
	return "Blood"
*/
/datum/hive_status_ui/tgui_status(mob/user, datum/tgui_state/state)
	return UI_INTERACTIVE
	//if(isobserver(user))
	//	return UI_INTERACTIVE

/datum/hive_status_ui/tgui_data(mob/user)
	. = list()
	.["total_xenos"] = total_xenos
	.["xeno_counts"] = xeno_counts
	.["xeno_keys"] = xeno_keys
	.["xeno_info"] = xeno_info
	.["xeno_vitals"] = xeno_vitals

	var/area/A = get_area(assoc_hive.eminence)
	.["queen_location"] = get_area_name(A)

/datum/hive_status_ui/tgui_static_data(mob/user)
	. = list()
	.["user_ref"] = REF(user)
	.["hive_color"] = COLOR_CRIMSON_RED
	.["hive_name"] = assoc_hive.name

/datum/hive_status_ui/proc/open_hive_status(var/mob/user)
	if(!user)
		return

	// Update absolutely all data
	if(!data_initialized)
		update_all_data()

	tgui_interact(user)

/datum/hive_status_ui/tgui_interact(mob/user, datum/tgui/ui)
	if(!assoc_hive)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "StatusBar", "[assoc_hive.name] Status")
		ui.open()
		ui.set_autoupdate(FALSE)
/*
/datum/hive_status_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
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
