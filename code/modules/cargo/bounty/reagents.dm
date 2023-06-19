/datum/bounty/reagent
	var/required_volume = 10
	var/shipped_volume = 0
	var/datum/reagent/wanted_reagent

/datum/bounty/reagent/can_claim()
	return ..() && shipped_volume >= required_volume

/datum/bounty/reagent/applies_to(obj/O)
	if(!istype(O, /obj/item/weapon/reagent_containers))
		return FALSE
	if(!O.reagents || !O.reagents.has_reagent(wanted_reagent.type))
		return FALSE
	if(O.flags_2 & HOLOGRAM_2)
		return FALSE
	return shipped_volume < required_volume

/datum/bounty/reagent/ship(obj/O)
	if(!applies_to(O))
		return
	shipped_volume += O.reagents.get_reagent_amount(wanted_reagent.type)
	if(shipped_volume > required_volume)
		shipped_volume = required_volume

/datum/bounty/reagent/simple_drink
	name = "Simple Drink"
	reward = CARGO_CRATE_VALUE * 2
	required_volume = 120

/datum/bounty/reagent/simple_drink/New()
	var/static/list/possible_reagents = list(
		/datum/reagent/consumable/drink/orangejuice,
		/datum/reagent/consumable/drink/tomatojuice,
		/datum/reagent/consumable/drink/limejuice,
		/datum/reagent/consumable/drink/carrotjuice,
		/datum/reagent/consumable/drink/berryjuice,
		/datum/reagent/consumable/drink/grapejuice,
		/datum/reagent/consumable/drink/grapesoda,
		/datum/reagent/consumable/drink/poisonberryjuice,
		/datum/reagent/consumable/drink/watermelonjuice,
		/datum/reagent/consumable/drink/lemonjuice,
		/datum/reagent/consumable/drink/banana,
		/datum/reagent/consumable/drink/nothing,
		/datum/reagent/consumable/drink/potato_juice,
		/datum/reagent/consumable/drink/gourd_juice,
		/datum/reagent/consumable/drink/milk,
		/datum/reagent/consumable/drink/milk/soymilk,
		/datum/reagent/consumable/drink/milk/cream,
		/datum/reagent/consumable/drink/grenadine,
		/datum/reagent/consumable/drink/hot_coco,
		/datum/reagent/consumable/drink/coffee,
		/datum/reagent/consumable/drink/coffee/icecoffee,
		/datum/reagent/consumable/drink/coffee/soy_latte,
		/datum/reagent/consumable/drink/coffee/cafe_latte,
		/datum/reagent/consumable/drink/tea,
		/datum/reagent/consumable/drink/tea/icetea,
		/datum/reagent/consumable/drink/cold,
		/datum/reagent/consumable/drink/cold/tonic,
		/datum/reagent/consumable/drink/cold/sodawater,
		/datum/reagent/consumable/drink/cold/ice,
		/datum/reagent/consumable/drink/cold/space_cola,
		/datum/reagent/consumable/drink/cold/nuka_cola,
		/datum/reagent/consumable/drink/cold/spacemountainwind,
		/datum/reagent/consumable/drink/cold/dr_gibb,
		/datum/reagent/consumable/drink/cold/space_up,
		/datum/reagent/consumable/drink/cold/lemon_lime,
		/datum/reagent/consumable/drink/cold/lemonade,
		/datum/reagent/consumable/drink/cold/kiraspecial,
		/datum/reagent/consumable/drink/cold/brownstar,
		/datum/reagent/consumable/drink/cold/milkshake,
		/datum/reagent/consumable/drink/cold/milkshake/chocolate,
		/datum/reagent/consumable/drink/cold/milkshake/strawberry,
		/datum/reagent/consumable/drink/cold/rewriter,
		/datum/reagent/consumable/drink/cold/kvass,
		/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/consumable/ethanol/gourd_beer,
		/datum/reagent/consumable/ethanol/kahlua,
		/datum/reagent/consumable/ethanol/whiskey,
		/datum/reagent/consumable/ethanol/specialwhiskey,
		/datum/reagent/consumable/ethanol/thirteenloko,
		/datum/reagent/consumable/ethanol/vodka,
		/datum/reagent/consumable/ethanol/bilk,
		/datum/reagent/consumable/ethanol/threemileisland,
		/datum/reagent/consumable/ethanol/gin,
		/datum/reagent/consumable/ethanol/rum,
		/datum/reagent/consumable/ethanol/champagne,
		/datum/reagent/consumable/ethanol/tequilla,
		/datum/reagent/consumable/ethanol/vermouth,
		/datum/reagent/consumable/ethanol/wine,
		/datum/reagent/consumable/ethanol/cognac,
		/datum/reagent/consumable/ethanol/hooch,
		/datum/reagent/consumable/ethanol/ale,
		/datum/reagent/consumable/ethanol/absinthe,
		/datum/reagent/consumable/ethanol/pwine,
		/datum/reagent/consumable/ethanol/deadrum,
		/datum/reagent/consumable/ethanol/sake,
		/datum/reagent/consumable/ethanol/goldschlager,
		/datum/reagent/consumable/ethanol/patron,
		/datum/reagent/consumable/ethanol/gintonic
	)
	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "CentCom is thirsty! Send a shipment of [name] to CentCom to quench the company's thirst."
	required_volume = rand(15, 120)
	reward = round(CARGO_CRATE_VALUE * required_volume / 17)

/datum/bounty/reagent/complex_drink
	name = "Complex Drink"
	required_volume = 5
	reward = CARGO_CRATE_VALUE * 8

/datum/bounty/reagent/complex_drink/New()
	var/static/list/possible_reagents = list(
		/datum/reagent/consumable/drink/cold/milkshake,
		/datum/reagent/consumable/drink/cold/milkshake/chocolate,
		/datum/reagent/consumable/drink/cold/milkshake/strawberry,
		/datum/reagent/consumable/ethanol/cuba_libre,
		/datum/reagent/consumable/ethanol/whiskey_cola,
		/datum/reagent/consumable/ethanol/martini,
		/datum/reagent/consumable/ethanol/vodkamartini,
		/datum/reagent/consumable/ethanol/white_russian,
		/datum/reagent/consumable/ethanol/screwdrivercocktail,
		/datum/reagent/consumable/ethanol/booger,
		/datum/reagent/consumable/ethanol/bloody_mary,
		/datum/reagent/consumable/ethanol/brave_bull,
		/datum/reagent/consumable/ethanol/tequilla_sunrise,
		/datum/reagent/consumable/ethanol/toxins_special,
		/datum/reagent/consumable/ethanol/beepsky_smash,
		/datum/reagent/consumable/ethanol/irish_cream,
		/datum/reagent/consumable/ethanol/manly_dorf,
		/datum/reagent/consumable/ethanol/longislandicedtea,
		/datum/reagent/consumable/ethanol/moonshine,
		/datum/reagent/consumable/ethanol/b52,
		/datum/reagent/consumable/ethanol/irishcoffee,
		/datum/reagent/consumable/ethanol/margarita,
		/datum/reagent/consumable/ethanol/black_russian,
		/datum/reagent/consumable/ethanol/manhattan,
		/datum/reagent/consumable/ethanol/manhattan_proj,
		/datum/reagent/consumable/ethanol/whiskeysoda,
		/datum/reagent/consumable/ethanol/antifreeze,
		/datum/reagent/consumable/ethanol/barefoot,
		/datum/reagent/consumable/ethanol/snowwhite,
		/datum/reagent/consumable/ethanol/melonliquor,
		/datum/reagent/consumable/ethanol/bluecuracao,
		/datum/reagent/consumable/ethanol/suidream,
		/datum/reagent/consumable/ethanol/demonsblood,
		/datum/reagent/consumable/ethanol/vodkatonic,
		/datum/reagent/consumable/ethanol/ginfizz,
		/datum/reagent/consumable/ethanol/bahama_mama,
		/datum/reagent/consumable/ethanol/singulo,
		/datum/reagent/consumable/ethanol/sbiten,
		/datum/reagent/consumable/ethanol/devilskiss,
		/datum/reagent/consumable/ethanol/red_mead,
		/datum/reagent/consumable/ethanol/mead,
		/datum/reagent/consumable/ethanol/iced_beer,
		/datum/reagent/consumable/ethanol/grog,
		/datum/reagent/consumable/ethanol/aloe,
		/datum/reagent/consumable/ethanol/andalusia,
		/datum/reagent/consumable/ethanol/alliescocktail,
		/datum/reagent/consumable/ethanol/acid_spit,
		/datum/reagent/consumable/ethanol/amasec,
		/datum/reagent/consumable/ethanol/changelingsting,
		/datum/reagent/consumable/ethanol/irishcarbomb,
		/datum/reagent/consumable/ethanol/syndicatebomb,
		/datum/reagent/consumable/ethanol/erikasurprise,
		/datum/reagent/consumable/ethanol/driestmartini,
		/datum/reagent/consumable/ethanol/bananahonk,
		/datum/reagent/consumable/ethanol/silencer,
		/datum/reagent/consumable/ethanol/bacardi,
		/datum/reagent/consumable/ethanol/bacardialoha,
		/datum/reagent/consumable/ethanol/bacardilemonade,
		/datum/reagent/consumable/ethanol/sangria,
		/datum/reagent/consumable/ethanol/strongmandrink,
		/datum/reagent/consumable/ethanol/bluelagoone,
		/datum/reagent/consumable/ethanol/bloodykuds,
		/datum/reagent/consumable/ethanol/sexbeach,
		/datum/reagent/consumable/ethanol/mojito,
	)
	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "CentCom is offering a reward for talented mixologists. Ship a container of [name] to claim the prize."
	required_volume = rand(10, 30)
	reward = round(CARGO_CRATE_VALUE * required_volume / 2.5)

/datum/bounty/reagent/chemical_simple
	name = "Simple Chemical"
	reward = CARGO_CRATE_VALUE * 8
	required_volume = 30

/datum/bounty/reagent/chemical_simple/New()
	var/static/list/possible_reagents = list(\
		/datum/reagent/inaprovaline,
		/datum/reagent/ryetalyn,
		/datum/reagent/paracetamol,
		/datum/reagent/tramadol,
		/datum/reagent/oxycodone,
		/datum/reagent/sterilizine,
		/datum/reagent/leporazine,
		/datum/reagent/kelotane,
		/datum/reagent/dermaline,
		/datum/reagent/dexalin,
		/datum/reagent/dextromethorphan,
		/datum/reagent/dexalinp,
		/datum/reagent/tricordrazine,
		/datum/reagent/anti_toxin,
		/datum/reagent/thermopsis,
		/datum/reagent/synaptizine,
		/datum/reagent/hyronalin,
		/datum/reagent/arithrazine,
		/datum/reagent/alkysine,
		/datum/reagent/imidazoline,
		/datum/reagent/metatrombine,
		/datum/reagent/lipozine,
		/datum/reagent/ethylredoxrazine,
		/datum/reagent/spaceacillin,
		/datum/reagent/rezadone,
		/datum/reagent/cryoxadone,
		/datum/reagent/bicaridine,
		/datum/reagent/aurisine,
		/datum/reagent/peridaxon,)

	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "CentCom is in desperate need of the chemical [name]. Ship a container of it to be rewarded."
	required_volume = rand(15, 120)
	reward = round(CARGO_CRATE_VALUE * required_volume / 17)

/datum/bounty/reagent/chemical_complex
	name = "Rare Chemical"
	reward = CARGO_CRATE_VALUE * 12
	required_volume = 20

/datum/bounty/reagent/chemical_complex/New()
	// Reagents that require interaction with multiple departments or are a pain to mix.
	var/static/list/possible_reagents = list(
		/datum/reagent/nitroglycerin,
		/datum/reagent/toxin/zombiepowder,
		/datum/reagent/mednanobots,
		/datum/reagent/kyphotorin,)

	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "CentCom is paying premium for the chemical [name]. Ship a container of it to be rewarded."
	required_volume = rand(3, 10)
	reward = round(CARGO_CRATE_VALUE * required_volume * 2)
