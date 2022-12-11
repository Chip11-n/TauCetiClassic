
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
	//var/list/cultist_counts
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

// Updates the list tracking how many cultists there are in each tier, and how many there are in total
/datum/cult_status_ui/proc/update_cultist_counts(send_update = TRUE)
	total_cultists = assoc_cult.members.len

	if(send_update)
		SStgui.update_uis(src)

// Updates the sorted list of all cultists that we use as a key for all other information
/datum/cult_status_ui/proc/update_cultists_keys(send_update = TRUE)
	cultists_keys = get_cultists_keys()

	if(send_update)
		SStgui.update_uis(src)

/datum/cult_status_ui/proc/get_cultists_keys()
	var/list/cultists[assoc_cult.members.len]

	var/index = 1
	for(var/mob/living/L in assoc_cult.members)
		// Insert without doing list merging
		cultists[index++] = list(
			"real_name" = L.real_name,
			"is_eminence" = iseminence(L),
			"assigned_job" = L.mind.assigned_job
		)

	return cultists

// Mildly related to the above, but only for when cultists are removed from the cult
// If a cultist dies, we don't have to regenerate all xeno info and sort it again, just remove them from the data list
/datum/cult_status_ui/proc/cultist_removed(mob/L)
	if(!cultists_keys)
		return

	for(var/index in 1 to length(cultists_keys))
		var/list/info = cultists_keys[index]
		if(info["real_name"] == L.real_name)
			cultists_keys[index] = null
			cultists_keys -= null
			return

	SStgui.update_uis(src)

// Updates the list of xeno names, assigned_job and references
/datum/cult_status_ui/proc/update_cultist_info(send_update = TRUE)
	cultist_info = get_cultist_info()

	if(send_update)
		SStgui.update_uis(src)

// Returns a list with some more info about all cultists in the cult
/datum/cult_status_ui/proc/get_cultist_info()
	var/list/cultists = list()

	for(var/mob/living/L in assoc_cult.members)
		var/xeno_name = L.name
		cultists["[L.real_name]"] = list(
			"name" = xeno_name,
			"assigned_job" = L.mind.assigned_job,
			"ref" = "\ref[L]"
		)

	return cultists

// Updates vital information about cultists such as health and location. Only info that should be updated regularly
/datum/cult_status_ui/proc/update_cultist_vitals()
	cultist_vitals = get_cultist_vitals()

// Returns a list of xeno healths and locations
/datum/cult_status_ui/proc/get_cultist_vitals()
	var/list/cultists = list()

	for(var/mob/living/L in assoc_cult.members)
		var/area/A = get_area(L)
		var/area_name = "Unknown"
		if(A)
			area_name = A.name

		cultists["[L.real_name]"] = list(
			"health" = round((L.health / L.maxHealth) * 100, 1),
			"area" = area_name,
			"is_ssd" = (!L.client)
		)

	return cultists

// Updates all data
/datum/cult_status_ui/proc/update_all_cultist_data(send_update = TRUE)
	update_cultist_counts(FALSE)
	update_cultist_vitals()
	update_cultists_keys(FALSE)
	update_cultist_info(FALSE)

	if(send_update)
		SStgui.update_uis(src)

// Updates all data
/datum/cult_status_ui/proc/update_all_data()
	data_initialized = TRUE
	update_all_cultist_data(FALSE)
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

/datum/cult_status_ui/proc/open_cult_status(mob/user)
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

/datum/cult_status_ui/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("overwatch")
			var/mob/living/Target = locate(params["target_ref"]) in assoc_cult.members
			var/mob/living/Src = ui.user

			if(QDELETED(Target))
				return

			if(iseminence(Src))
				var/mob/camera/eminence/O = src
				O.eminence_track(Target)
			return
/*
			if(!src.check_state(TRUE))
				return

			var/isQueen = (src.assigned_job == XENO_CASTE_QUEEN)
			if (isQueen)
				src.overwatch(Target)
			else
				src.overwatch(Target)
				/*
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

*/
