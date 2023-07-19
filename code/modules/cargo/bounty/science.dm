/datum/bounty/item/science/points
	name = "Scientific Findings"
	description = "Our intern was playing with the database, and so... Send us one high-tec item."
	reward = CARGO_CRATE_VALUE * 20
	var/datum/experiment_data/experiments

/datum/bounty/item/science/points/New()
	var/obj/machinery/computer/rdconsole/RD = locate() in global.RDcomputer_list
	if(RD)
		experiments = RD.files.experiments

/datum/bounty/item/science/points/applies_to(obj/O)
	if(shipped_count >= required_count)
		return FALSE
	if(!experiments)
		return FALSE
	if(CARGO_CRATE_VALUE * sqrt(experiments.get_object_research_value(O)) * 0.3 > 300)
		return TRUE

/datum/bounty/item/science/disc
	name = "Tech Disk"
	description = "It turns out our chef cooked our tech disks. Even though it came out delicious, deliver us one such disk."
	reward = CARGO_CRATE_VALUE * 30
	include_subtypes = TRUE
	wanted_types = list(/obj/item/weapon/disk/research_points = TRUE)

//******Anomaly Cores******
/datum/bounty/item/science/anomaly
	name = "Anomaly Core"
	description = "We need an anomaly core as a toy for our assistants. Ship us one, please."
	reward = CARGO_CRATE_VALUE * 50
	wanted_types = list(/obj/item/device/assembly/signaler/anomaly = TRUE)
