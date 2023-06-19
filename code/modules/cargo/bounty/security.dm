/datum/bounty/item/security/recharger
	name = "Rechargers"
	description = "Nanotrasen military academy is conducting marksmanship exercises. They request that rechargers be shipped."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/machinery/recharger = TRUE)

/datum/bounty/item/security/pepperspray
	name = "Pepperspray"
	description = "We've been having a bad run of riots on Space Station 76. We could use some new pepperspray cans."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/spray/pepper = TRUE)

/datum/bounty/item/security/prison_clothes
	name = "Prison Uniforms"
	description = "TerraGov has been unable to source any new prisoner uniforms, so if you have any spares, we'll take them off your hands."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 2
	wanted_types = list(/obj/item/clothing/under/color/orange = TRUE)

/datum/bounty/item/security/earmuffs
	name = "Earmuffs"
	description = "Central Command is getting tired of your station's messages. They've ordered that you ship some earmuffs to lessen the annoyance."
	reward = CARGO_CRATE_VALUE * 2
	wanted_types = list(/obj/item/clothing/ears/earmuffs = TRUE)

/datum/bounty/item/security/handcuffs
	name = "Handcuffs"
	description = "A large influx of escaped convicts have arrived at Central Command. Now is the perfect time to ship out spare handcuffs (or restraints)."
	reward = CARGO_CRATE_VALUE * 2
	required_count = 5
	wanted_types = list(/obj/item/weapon/handcuffs = TRUE)
