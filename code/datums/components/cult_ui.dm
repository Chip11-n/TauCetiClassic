/**
 * # Cult ui element
 *
 * Removes from cult_ui in case of "gib and dust". Otherwise cult ui will die
 */
/datum/element/cult_ui
	element_flags = ELEMENT_DETACH
	var/datum/cult_status_ui/status

/datum/element/cult_ui/Attach(datum/target)
	. = ..()
	if(!status)
		status = global.cult_religion.cult_ui
	if (!ismob(target))
		return ELEMENT_INCOMPATIBLE

	var/mob/M = target
	var/datum/action/cult_status/A = new(M)
	A.Grant(M)

	// Register signals for mob dust and gibs
	RegisterSignal(M, COMSIG_MOB_DIED, .proc/remove_cultist_ui)

/**
 * What happens if cultist is being gibbed or dusted
 */
/datum/element/cult_ui/proc/remove_cultist_ui(mob/target, gibbed)
	SIGNAL_HANDLER
	if(gibbed)
		status.cultist_removed(target)
	status.update_cultist_counts()

/**
 * Detach proc
 *
 * Removes the ui, it is unsafe to let it be without control
 */
/datum/element/cult_ui/Detach(mob/target, ...)
	status.cultist_removed(target)
	status.update_all_cultist_data()
	UnregisterSignal(target, COMSIG_MOB_DIED)
	return ..()

/datum/action/cult_status
	name = "Cult Status"
	button_icon = 'icons/hud/actions.dmi'
	button_icon_state = "status"
	background_icon_state = "bg_cult"
	action_type = AB_INNATE

/datum/action/cult_status/Activate()
	if(!owner || !ismob(owner))
		return
	if(global.cult_religion)
		global.cult_religion.cult_ui.open_cult_status(owner)
