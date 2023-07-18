/datum/bounty/item/xenomorph
	name = "Aliens"
	description = "Nanotrasen is interested in studying Xenomorph biology. Ship us adult one. Dead one."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 2
	wanted_types = list(/mob/living/carbon/xenomorph/humanoid)

/datum/bounty/item/xenomorph/applies_to(obj/O)
	if(!..())
		return FALSE
	var/mob/living/carbon/xenomorph/humanoid/X = O
	if(X.stat == DEAD)
		return TRUE

/datum/bounty/item/replicator
	name = "Replicators"
	description = "Nanotrasen is interested in studying Bio Hazardous materials. Ship us three replictors."
	reward = CARGO_CRATE_VALUE * 40
	required_count = 3
	wanted_types = list(/mob/living/simple_animal/hostile/replicator)

/datum/bounty/item/replicator/applies_to(obj/O)
	if(!..())
		return FALSE
	var/mob/living/simple_animal/hostile/replicator/X = O
	if(X.stat == DEAD)
		return TRUE
