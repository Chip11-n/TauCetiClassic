/datum/objective/target/sacrifice/format_explanation(datum/mind/target)
	var/datum/faction/cult/C = faction
	if(istype(C) && target)
		return "Принесите в жертву [target.current?.name], [target.assigned_role]."
	return "Жертва не требуется"

/datum/objective/target/sacrifice/find_target()
	var/datum/faction/cult/C = faction
	if(istype(C))
		var/datum/mind/sacrifice = C.find_sacrifice_target()
		if(sacrifice)
			target = sacrifice
			explanation_text = format_explanation(sacrifice)
			/*if(organs_by_name[O_BRAIN])
				var/obj/item/organ/internal/IO = organs_by_name[O_BRAIN]
				if(istype(IO))*/
			RegisterSignal(sacrifice, COMSIG_PARENT_QDELETING, .proc/target_del)
		else
			target = null
			explanation_text = format_explanation()
	return TRUE

/datum/objective/target/sacrifice/select_target()
	return FALSE

/datum/objective/target/sacrifice/check_completion()
	var/datum/faction/cult/C = faction
	if(istype(C))
		if(!target || (target in C.sacrificed))
			return OBJECTIVE_WIN
	return OBJECTIVE_LOSS

/datum/objective/target/sacrifice/proc/target_del() //We need a new target
	SIGNAL_HANDLER
	find_target()
	var/datum/faction/cult/C = faction
	C.religion.send_message_to_members("<span class='[C.religion.style_text]'>М͋͝н̽͌̔е͑͐͝ н́̈́̓у͒̽̓ж̐̈́̿н͐̚͝а̒̚ н͑̐͑о̽̽в̿̐͝а͒̈́͝я̓͝ ж͑͒̕е͑͝р͑͒͆т͌͘͠в͆̈́́а͊̾̚</span>", null, 6)

/datum/objective/target/sacrifice/Destroy()
	. = ..()
	var/datum/faction/cult/C = faction
	if(target)
		C.sacrifice_targets -= target
