/datum/bounty/item/assistant/stunprod
	name = "Stunprod"
	description = "CentCom demands a stunprod to use against dissidents. Craft one, then ship it."
	reward = CARGO_CRATE_VALUE * 2.6
	wanted_types = list(/obj/item/weapon/melee/cattleprod = TRUE)

/datum/bounty/item/assistant/soap
	name = "Soap"
	description = "Soap has gone missing from CentCom's bathrooms and nobody knows who took it. Replace it and be the hero CentCom needs."
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/soap = TRUE)

/datum/bounty/item/assistant/spear
	name = "Spears"
	description = "CentCom's security forces are going through budget cuts. You will be paid if you ship a set of spears."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/item/weapon/spear = TRUE)

/datum/bounty/item/assistant/toolbox
	name = "Toolboxes"
	description = "There's an absence of robustness at Central Command. Hurry up and ship some toolboxes as a solution."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 6
	wanted_types = list(/obj/item/weapon/storage/toolbox = TRUE)

/datum/bounty/item/assistant/cheesiehonkers
	name = "Cheesie Honkers"
	description = "Apparently the company that makes Cheesie Honkers is going out of business soon. CentCom wants to stock up before it happens!"
	reward = CARGO_CRATE_VALUE * 2.4
	required_count = 15
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers = TRUE)

/datum/bounty/item/assistant/donut
	name = "Donuts"
	description = "CentCom's security forces are facing heavy losses against the Syndicate. Ship donuts to raise morale."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 6
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/donut = TRUE)

/datum/bounty/item/assistant/donkpocket
	name = "Donk-Pockets"
	description = "Consumer safety recall: Warning. Donk-Pockets manufactured in the past year contain hazardous lizard biomatter. Return units to CentCom immediately."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 8
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/donkpocket = TRUE)

/datum/bounty/item/assistant/dead_mice
	name = "Dead Mice"
	description = "Station 14 ran out of freeze-dried mice. Ship some fresh ones so their janitor doesn't go on strike."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(/mob/living/simple_animal/mouse = TRUE)

/datum/bounty/item/assistant/comfy_chair
	name = "Comfy Chairs"
	description = "Commander Pat is unhappy with his chair. He claims it hurts his back. Ship some alternatives out to humor him."
	reward = CARGO_CRATE_VALUE * 3
	required_count = 5
	wanted_types = list(/obj/structure/stool = TRUE)

/datum/bounty/item/assistant/corgimeat
	name = "Raw Corgi Meat"
	description = "The Syndicate recently stole all of CentCom's corgi meat. Ship out a replacement immediately."
	reward = CARGO_CRATE_VALUE * 15
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/meat/corgi = TRUE)

/datum/bounty/item/assistant/shadyjims
	name = "DromedaryCo packet"
	description = "There's an irate officer at CentCom demanding that he receive a box of DromedaryCo cigarettes. Please ship one. He's starting to make threats."
	reward = CARGO_CRATE_VALUE
	wanted_types = list(/obj/item/weapon/storage/fancy/cigarettes/dromedaryco = TRUE)

/datum/bounty/item/assistant/potted_plants
	name = "Potted Plants"
	description = "Central Command is looking to commission a new BirdBoat-class station. You've been ordered to supply the potted plants."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 8
	wanted_types = list(/obj/item/weapon/flora/pottedplant = TRUE)

/datum/bounty/item/assistant/monkey_cubes
	name = "Monkey Cubes"
	description = "Due to a recent genetics accident, Central Command is in serious need of monkeys. Your mission is to ship monkey cubes."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 4
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube = TRUE)

/datum/bounty/item/assistant/ied
	name = "IED"
	description = "Nanotrasen's maximum security prison at CentCom is undergoing personnel training. Ship a handful of IEDs to serve as a training tools."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/item/weapon/grenade/cancasing = TRUE)

/datum/bounty/item/assistant/action_figures
	name = "Action Figures"
	description = "The vice president's son saw an ad for action figures on the telescreen and now he won't shut up about them. Ship some to ease his complaints."
	reward = CARGO_CRATE_VALUE * 8
	required_count = 5
	wanted_types = list(/obj/item/toy/figure = TRUE)

/datum/bounty/item/assistant/paper_bin
	name = "Paper Bins"
	description = "Our accounting division is all out of paper. We need a new shipment immediately."
	reward = CARGO_CRATE_VALUE * 5
	required_count = 5
	wanted_types = list(/obj/item/weapon/paper_bin = TRUE)

/datum/bounty/item/assistant/crayons
	name = "Crayons"
	description = "Dr. Jones's kid ate all of our crayons again. Please send us yours."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 8
	wanted_types = list(/obj/item/toy/crayon = TRUE)

/datum/bounty/item/assistant/pens
	name = "Pens"
	description = "We are hosting the intergalactic pen balancing competition. We need you to send us some standardized black ballpoint pens."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 8
	include_subtypes = FALSE
	wanted_types = list(/obj/item/weapon/pen = TRUE)

/datum/bounty/item/assistant/water_tank
	name = "Water Tank"
	description = "We need more water for our hydroponics bay. Find a water tank and ship it out to us."
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/structure/reagent_dispensers/watertank = TRUE)

/datum/bounty/item/assistant/pneumatic_cannon
	name = "Pneumatic Cannon"
	description = "We're figuring out how hard we can launch supermatter shards out of a pneumatic cannon. Send us one as soon as possible."
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/item/weapon/storage/pneumatic = TRUE)

/datum/bounty/item/assistant/flamethrower
	name = "Flamethrower"
	description = "We have a moth infestation, send a flamethrower to help deal with the situation."
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/item/weapon/flamethrower = TRUE)
