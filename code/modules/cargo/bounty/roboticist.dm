/datum/bounty/item/mech/New()
	..()
	description = "Upper management has requested one [name] mech be sent as soon as possible. Ship it to receive a large payment."

/datum/bounty/item/mech/applies_to(obj/O)
	. = ..()
	if(locate(/mob) in O.contents)
		return FALSE

/datum/bounty/item/mech/ship(obj/O)
	if(!applies_to(O))
		return
	if(istype(O, /obj/mecha))
		var/obj/mecha/M = O
		M.wreckage = null // So the mech doesn't explode.
	..()

/datum/bounty/item/mech/ripley
	name = "APLU \"Ripley\""
	reward = CARGO_CRATE_VALUE * 26
	wanted_types = list(/obj/mecha/working/ripley = TRUE)

/datum/bounty/item/mech/firefighter
	name = "APLU \"Firefighter\""
	reward = CARGO_CRATE_VALUE * 32
	wanted_types = list(/obj/mecha/working/ripley/firefighter = TRUE)

/datum/bounty/item/mech/odysseus
	name = "Odysseus"
	reward = CARGO_CRATE_VALUE * 22
	wanted_types = list(/obj/mecha/medical/odysseus = TRUE)

/datum/bounty/item/mech/gygax
	name = "Gygax"
	reward = CARGO_CRATE_VALUE * 56
	wanted_types = list(/obj/mecha/combat/gygax = TRUE)

/datum/bounty/item/mech/gygax_ultra
	name = "Gygax Ultra"
	reward = CARGO_CRATE_VALUE * 76
	wanted_types = list(/obj/mecha/combat/gygax/ultra = TRUE)

/datum/bounty/item/mech/durand
	name = "Durand"
	reward = CARGO_CRATE_VALUE * 40
	wanted_types = list(/obj/mecha/combat/durand = TRUE)

/datum/bounty/item/mech/vindicator
	name = "Vindicator"
	reward = CARGO_CRATE_VALUE * 60
	wanted_types = list(/obj/mecha/combat/durand/vindicator = TRUE)
