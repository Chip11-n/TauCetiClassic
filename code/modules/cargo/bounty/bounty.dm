var/global/list/string_assoc_lists = list()

/**
 * Caches associative lists with non-numeric stringify-able index keys and stringify-able values (text/typepath -> text/path/number).
 */
/datum/proc/string_assoc_list(list/values)
	var/list/string_id = list()
	for(var/val in values)
		string_id += "[val]_[values[val]]"
	string_id = string_id.Join("-")

	. = global.string_assoc_lists[string_id]

	if(.)
		return

	return global.string_assoc_lists[string_id] = values

/**
 * Like typesof() or subtypesof(), but returns a typecache instead of a list.
 * This time it also uses the associated values given by the input list for the values of the subtypes.
 *
 * Latter values from the input list override earlier values.
 * Thus subtypes should come _after_ parent types in the input list.
 * Notice that this is the opposite priority of [/proc/is_type_in_list] and [/proc/is_path_in_list].
 *
 * Arguments:
 * - path: A typepath or list of typepaths with associated values.
 * - single_value: The assoc value used if only a single path is passed as the first variable.
 * - only_root_path: Whether the typecache should be specifically of the passed types.
 * - ignore_root_path: Whether to ignore the root path when caching subtypes.
 * - clear_nulls: Whether to remove keys with null assoc values from the typecache after generating it.
 */
/proc/zebra_typecacheof(path, single_value = TRUE, only_root_path = FALSE, ignore_root_path = FALSE, clear_nulls = FALSE)
	if(isnull(path))
		return

	if(ispath(path))
		if (isnull(single_value))
			return

		. = list()
		if(only_root_path)
			.[path] = single_value
			return

		for(var/subtype in (ignore_root_path ? subtypesof(path) : typesof(path)))
			.[subtype] = single_value
		return

	if(!islist(path))
		CRASH("Tried to create a typecache of [path] which is neither a typepath nor a list.")

	. = list()
	var/list/pathlist = path
	if(only_root_path)
		for(var/current_path in pathlist)
			.[current_path] = pathlist[current_path]
	else if(ignore_root_path)
		for(var/current_path in pathlist)
			for(var/subtype in subtypesof(current_path))
				.[subtype] = pathlist[current_path]
	else
		for(var/current_path in pathlist)
			for(var/subpath in typesof(current_path))
				.[subpath] = pathlist[current_path]

	if(!clear_nulls)
		return

	for(var/cached_path in .)
		if (isnull(.[cached_path]))
			. -= cached_path

/// If the user can actually get this bounty as a selection.
/datum/bounty/proc/can_get()
	return TRUE

/datum/bounty
	var/name
	var/description
	var/reward = 1000 // In credits.
	var/claimed = FALSE
	var/high_priority = FALSE

/datum/bounty/proc/can_claim()
	return !claimed

/// If an item sent in the cargo shuttle can satisfy the bounty.
/datum/bounty/proc/applies_to(obj/O)
	return FALSE

/// Called when an object is shipped on the cargo shuttle.
/datum/bounty/proc/ship(obj/O)
	return

/datum/bounty/item
	///How many items have to be shipped to complete the bounty
	var/required_count = 1
	///How many items have been shipped for the bounty so far
	var/shipped_count = 0
	///Types accepted|denied by the bounty. (including all subtypes, unless include_subtypes is set to FALSE)
	var/list/wanted_types
	///Set to FALSE to make the bounty not accept subtypes of the wanted_types
	var/include_subtypes = TRUE

/datum/bounty/item/New()
	..()
	wanted_types = string_assoc_list(zebra_typecacheof(wanted_types, only_root_path = !include_subtypes))

/datum/bounty/item/can_claim()
	return ..() && shipped_count >= required_count

/datum/bounty/item/applies_to(obj/O)
	if(!is_type_in_typecache(O, wanted_types))
		return FALSE
	if(O.flags_2 & HOLOGRAM_2)
		return FALSE
	return shipped_count < required_count

/datum/bounty/item/ship(obj/O)
	if(!applies_to(O))
		return
	if(istype(O,/obj/item/stack))
		var/obj/item/stack/O_is_a_stack = O
		shipped_count += O_is_a_stack.amount
	else
		shipped_count += 1

/// How many jobs have bounties, minus the random civ bounties. PLEASE INCREASE THIS NUMBER AS MORE DEPTS ARE ADDED TO BOUNTIES.
#define MAXIMUM_BOUNTY_JOBS 8

/** Returns a new bounty of random type, but does not add it to GLOB.bounties_list.
 *
 * *Guided determines what specific catagory of bounty should be chosen.
 */
/proc/random_bounty(guided = 0)
	var/bounty_num
	var/chosen_type
	var/bounty_succeeded = FALSE
	var/datum/bounty/item/bounty_ref
	while(!bounty_succeeded)
		if(guided && (guided != CIV_JOB_RANDOM))
			bounty_num = guided
		else
			bounty_num = rand(1, MAXIMUM_BOUNTY_JOBS)
		switch(bounty_num)
			if(CIV_JOB_BASIC)
				chosen_type = pick(subtypesof(/datum/bounty/item/assistant))
			if(CIV_JOB_ROBO)
				chosen_type = pick(subtypesof(/datum/bounty/item/mech))
			if(CIV_JOB_SEC)
				chosen_type = pick(subtypesof(/datum/bounty/item/security))
			if(CIV_JOB_CHEM)
				if(prob(80))
					chosen_type = /datum/bounty/reagent/chemical_simple
				else
					chosen_type = /datum/bounty/reagent/chemical_complex
			if(CIV_JOB_DRINK)
				if(prob(50))
					chosen_type = /datum/bounty/reagent/simple_drink
				else
					chosen_type = /datum/bounty/reagent/complex_drink
			if(CIV_JOB_CHEF)
				chosen_type = pick(subtypesof(/datum/bounty/item/chef))
			if(CIV_JOB_SCI)
				if(prob(50))
					chosen_type = pick(subtypesof(/datum/bounty/item/science))
				else
					chosen_type = pick(subtypesof(/datum/bounty/item/slime))
			if(CIV_JOB_ENG)
				chosen_type = pick(subtypesof(/datum/bounty/item/engineering))
			/*if(CIV_JOB_VIRO)
				chosen_type = pick(subtypesof(/datum/bounty/virus))
			if(CIV_JOB_GROW)
				chosen_type = pick(subtypesof(/datum/bounty/item/botany))
			if(CIV_JOB_MINE)
				chosen_type = pick(subtypesof(/datum/bounty/item/mining))
			if(CIV_JOB_MED)
				chosen_type = pick(subtypesof(/datum/bounty/item/medical))
			if(CIV_JOB_ATMOS)
				chosen_type = pick(subtypesof(/datum/bounty/item/atmospherics))*/
		bounty_ref = new chosen_type
		if(bounty_ref.can_get())
			bounty_succeeded = TRUE
		else
			qdel(bounty_ref)
	return bounty_ref

#undef MAXIMUM_BOUNTY_JOBS
