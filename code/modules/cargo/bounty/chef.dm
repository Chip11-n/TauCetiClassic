/datum/bounty/item/chef/random
	name = "Cheif's special"
	description = "We want something...special from your chief."

/datum/bounty/item/chef/random/New()
	. = ..()
	var/static/list/possbile_food_random = list(
		/obj/item/weapon/reagent_containers/food/snacks/breadslice/xeno,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice/spider,
		/obj/item/weapon/reagent_containers/food/snacks/aesirsalad,
		/obj/item/weapon/reagent_containers/food/snacks/fishfingers,
		/obj/item/weapon/reagent_containers/food/snacks/brainburger,
		/obj/item/weapon/reagent_containers/food/snacks/ghostburger,
		/obj/item/weapon/reagent_containers/food/snacks/xenoburger,
		/obj/item/weapon/reagent_containers/food/snacks/clownburger,
		/obj/item/weapon/reagent_containers/food/snacks/mimeburger,
		/obj/item/weapon/reagent_containers/food/snacks/xemeatpie,
		/obj/item/weapon/reagent_containers/food/snacks/wingfangchu,
		/obj/item/weapon/reagent_containers/food/snacks/cubancarp,
		/obj/item/weapon/reagent_containers/food/snacks/soup/slimesoup,
		/obj/item/weapon/reagent_containers/food/snacks/soup/clownstears,
		/obj/item/weapon/reagent_containers/food/snacks/coldchili,
		/obj/item/weapon/reagent_containers/food/snacks/spellburger,
		/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight,
		/obj/item/weapon/reagent_containers/food/snacks/fishandchips,
		/obj/item/weapon/reagent_containers/food/snacks/sashimi,
		/obj/item/weapon/reagent_containers/food/snacks/jellyburger,
		/obj/item/weapon/reagent_containers/food/snacks/jellyburger/slime,
		/obj/item/weapon/reagent_containers/food/snacks/jellyburger/cherry,
		/obj/item/weapon/reagent_containers/food/snacks/superbiteburger,
		/obj/item/weapon/reagent_containers/food/snacks/jellysandwich,
		/obj/item/weapon/reagent_containers/food/snacks/jellysandwich/slime,
		/obj/item/weapon/reagent_containers/food/snacks/jellysandwich/cherry,
		/obj/item/weapon/reagent_containers/food/snacks/boiledslimecore,
		/obj/item/weapon/reagent_containers/food/snacks/chawanmushi,
		/obj/item/weapon/reagent_containers/food/snacks/appletart,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/xeno,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/spider,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/birthday,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/apple,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/pumpkin,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/carrot,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/brain,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/cheese,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/orange,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/lime,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/lemon,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/chocolate,
		/obj/item/weapon/reagent_containers/food/snacks/cakeslice/kaholket_alkeha,
		/obj/item/weapon/reagent_containers/food/snacks/spidereggs,
		)
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = string_assoc_list(zebra_typecacheof(pick(possbile_food_random), only_root_path = FALSE))
	var/obj/item/weapon/reagent_containers/food/snacks/S = wanted_types[1]
	description += " Send us [initial(S.name)]."



/datum/bounty/item/chef/birthday_cake
	name = "Birthday Cake"
	description = "Nanotrasen's birthday is coming up! Ship Central Command a birthday cake to celebrate!"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 5
	wanted_types = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/birthday = TRUE,
		/obj/item/weapon/reagent_containers/food/snacks/cakeslice/birthday = TRUE,
	)

/datum/bounty/item/chef/birthday_cake/ship(obj/O)
	. = ..()
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/sliceable/cake/birthday))
		shipped_count = 5

/datum/bounty/item/chef/soup
	name = "Soup"
	reward = CARGO_CRATE_VALUE * 10
	description = "To quell the homeless uprising, Nanotrasen will be serving soup to all underpaid workers."
	required_count = 3

/datum/bounty/item/chef/soup/New()
	. = ..()
	wanted_types = string_assoc_list(list(pick(subtypesof(/obj/item/weapon/reagent_containers/food/snacks/soup)) = TRUE))
	var/obj/item/weapon/reagent_containers/food/snacks/S = wanted_types[1]
	// In the future there could be tiers of soup bounty corresponding to soup difficulty
	// (IE, stew is harder to make than tomato soup, so it should reward more)
	description += " Send us [initial(S.name)] for the afternoon."

/datum/bounty/item/chef/popcorn
	name = "Popcorn Bags"
	description = "Upper management wants to host a movie night. Ship bags of popcorn for the occasion."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/popcorn = TRUE)

/datum/bounty/item/chef/icecreamsandwich
	name = "Ice Cream Sandwiches"
	description = "Upper management has been screaming non-stop for ice cream sandwiches. Please send some."
	reward = CARGO_CRATE_VALUE * 8
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich = TRUE)

/datum/bounty/item/chef/icecreamsandwich
	name = "Ice Cream Sandwiches"
	description = "Upper management has been screaming non-stop for more flavourful ice cream sandwiches. Please send some."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich = TRUE)

/datum/bounty/item/chef/bread
	name = "Bread"
	description = "Problems with central planning have led to bread prices skyrocketing. Ship some bread to ease tensions."
	reward = CARGO_CRATE_VALUE * 2
	wanted_types = list(
		/obj/item/weapon/reagent_containers/food/snacks/breadslice = TRUE,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread = TRUE,
	)

/datum/bounty/item/chef/pie
	name = "Pie"
	description = "3.14159? No! CentCom management wants edible pie! Ship a whole one."
	reward = 628.4 //Screw it I'll do this one by hand
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/pie = TRUE)

/datum/bounty/item/chef/salad
	name = "Salad or Rice Bowls"
	description = "CentCom management is going on a health binge. Your order is to ship salad or rice bowls."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/aesirsalad = TRUE)

/datum/bounty/item/chef/carrotfries
	name = "Carrot Fries"
	description = "Night sight can mean life or death! A shipment of carrot fries is the order."
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/carrotfries = TRUE)

/datum/bounty/item/chef/superbite
	name = "Super Bite Burger"
	description = "Commander Tubbs thinks he can set a competitive eating world record. All he needs is a super bite burger shipped to him."
	reward = CARGO_CRATE_VALUE * 24
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/superbiteburger = TRUE)

/datum/bounty/item/chef/poppypretzel
	name = "Poppy Pretzel"
	description = "Central Command needs a reason to fire their HR head. Send over a poppy pretzel to force a failed drug test."
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/poppypretzel = TRUE)

/datum/bounty/item/chef/cubancarp
	name = "Cuban Carp"
	description = "To celebrate the birth of Castro XXVII, ship one cuban carp to CentCom."
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/cubancarp = TRUE)

/datum/bounty/item/chef/hotdog
	name = "Hot Dog"
	description = "Nanotrasen is conducting taste tests to determine the best hot dog recipe. Ship your station's version to participate."
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/hotdog = TRUE)

/datum/bounty/item/chef/eggplantparm
	name = "Eggplant Parmigianas"
	description = "A famous singer will be arriving at CentCom, and their contract demands that they only be served Eggplant Parmigiana. Ship some, please!"
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/eggplantparm = TRUE)

/datum/bounty/item/chef/muffin
	name = "Muffins"
	description = "The Muffin Man is visiting CentCom, but he's forgotten his muffins! Your order is to rectify this."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/muffin = TRUE)

/datum/bounty/item/chef/chawanmushi
	name = "Chawanmushi"
	description = "Nanotrasen wants to improve relations with its sister company, Japanotrasen. Ship Chawanmushi immediately."
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/chawanmushi = TRUE)

/datum/bounty/item/chef/kebab
	name = "Kebabs"
	description = "Remove all kebab from station you are best food. Ship to CentCom to remove from the premises."
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/kabob = TRUE)

/datum/bounty/item/chef/soylentgreen
	name = "Soylent Green"
	description = "CentCom has heard wonderful things about the product 'Soylent Green', and would love to try some. If you indulge them, expect a pleasant bonus."
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/soylentgreen = TRUE)
