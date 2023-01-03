/datum/cult_status_ui
	var/name = "Cult Status"

	// Data to pass when rendering the UI (not static)
	var/total_cultists
	var/cultists_alive
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
	SStgui.update_uis(src)

// Updates how many cultists alive and in total
/datum/cult_status_ui/proc/update_cultist_counts(send_update = TRUE)
	total_cultists = assoc_cult.members.len

	cultists_alive = 0
	for(var/mob/M as anything in assoc_cult.members)
		if(M.stat == CONSCIOUS)
			cultists_alive++

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
	for(var/mob/L as anything in assoc_cult.members - assoc_cult.eminence)
		// Insert without doing list merging
		cultists[index++] = list(
			"real_name" = L.real_name,
			"assigned_job" = L.mind.assigned_job
		)

	//Eminence. Special case
	if(assoc_cult.eminence)
		cultists[index++] = list(
			"real_name" = assoc_cult.eminence.real_name,
			"assigned_job" = "Mentor",
			"is_eminence" = TRUE,
		)
	return cultists

// If a cultist dies, we don't have to regenerate all info and sort it again, just remove them from the data list
/datum/cult_status_ui/proc/cultist_removed(mob/L)
	if(!cultists_keys)
		return

	cultists_keys.Remove(null)
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

	for(var/mob/L as anything in assoc_cult.members - assoc_cult.eminence)
		cultists["[L.real_name]"] = list(
			"assigned_job" = L.mind.assigned_job ? L.mind.assigned_job.title : "Unemployed",
			"ref" = "\ref[L]"
		)
	//Eminence. Special case
	if(assoc_cult.eminence)
		cultists["[assoc_cult.eminence.real_name]"] = list(
			"assigned_job" = "Mentor",
			"ref" = "\ref[assoc_cult.eminence]"
		)
	return cultists

// Updates vital information about cultists such as health and location. Only info that should be updated regularly
/datum/cult_status_ui/proc/update_cultist_vitals()
	cultist_vitals = get_cultist_vitals()

// Returns a list of xeno healths and locations
/datum/cult_status_ui/proc/get_cultist_vitals()
	var/list/cultists = list()

	for(var/mob/living/L as anything in assoc_cult.members - assoc_cult.eminence)
		var/area/A = get_area(L)
		var/area_name = "Unknown"
		if(A)
			area_name = A.name
		cultists["[L.real_name]"] = list(
			"area" = area_name,
			"health" = "[round((L.health / L.maxHealth) * 100, 1)]%",
			"is_ssd" = (!L.client)
		)

	//Eminence. Special case
	if(assoc_cult.eminence)
		var/area/A = get_area(assoc_cult.eminence)
		var/area_name = "Unknown"
		if(A)
			area_name = A.name
		cultists["[assoc_cult.eminence.real_name]"] = list(
			"area" = area_name,
			"health" = "Immortal",
			"is_ssd" = (!assoc_cult.eminence.client),
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

/datum/cult_status_ui/tgui_status(mob/user, datum/tgui_state/state)
	return UI_INTERACTIVE

/datum/cult_status_ui/tgui_data(mob/user)
	. = list()
	.["total_cultists"] = total_cultists
	.["cultists_alive"] = cultists_alive
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
			var/mob/Target = locate(params["target_ref"]) in assoc_cult.members

			if(QDELETED(Target))
				return

			if(iseminence(ui.user))
				var/mob/camera/eminence/O = ui.user
				O.eminence_track(Target)
			return

/*
const EminenceButtons = (props, context) => {
  const { act, data } = useBackend(context);
  const { target_ref } = props;

  return (
    <Fragment>
      <Flex.Item>
        <Button
          content="Watch"
          color="cultist"
          onClick={
            () => act("overwatch", {
              target_ref: entry.ref,
            })
          }
        />
      </Flex.Item>
    </Fragment>
  );
};
*/

/*<Flex.Item>
        <Button
          content="Heal"
          color="green"
          onClick={
            () => act("heal", {
              target_ref: target_ref,
            })
          }
        />
      </Flex.Item>
      <Flex.Item>
        <Button
          content="Give Plasma"
          color="blue"
          onClick={
            () => act("give_plasma", {
              target_ref: target_ref,
            })
          }
        />
      </Flex.Item>
        */
