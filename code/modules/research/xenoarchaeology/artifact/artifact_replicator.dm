
/obj/machinery/replicator
	name = "alien machine"
	desc = "It's some kind of pod with strange wires and gadgets all over it."
	icon = 'icons/obj/xenoarchaeology/artifacts.dmi'
	icon_state = "replicator"
	density = TRUE

	idle_power_usage = 100
	active_power_usage = 1000
	use_power = IDLE_POWER_USE
	interact_offline = TRUE

	var/spawn_progress_time = 0
	var/max_spawn_time = 50
	var/last_process_time = 0

	var/list/construction = list()
	var/list/spawning_types = list()
	var/list/stored_materials = list()

	var/fail_message

/obj/machinery/replicator/atom_init()
	. = ..()

	var/list/viables = list(
	/obj/item/roller,
	/obj/structure/closet/crate,
	/obj/structure/closet/acloset,
	/mob/living/simple_animal/hostile/mimic/crate,
	/mob/living/simple_animal/hostile/viscerator,
	/mob/living/simple_animal/hostile/hivebot,
	/obj/item/device/analyzer,
	/obj/item/device/camera,
	/obj/item/device/flash,
	/obj/item/device/flashlight,
	/obj/item/device/healthanalyzer,
	/obj/item/device/multitool,
	/obj/item/device/paicard,
	/obj/item/device/radio,
	/obj/item/device/radio/headset,
	/obj/item/device/radio/beacon,
	/obj/item/weapon/autopsy_scanner,
	/obj/item/weapon/bikehorn,
	/obj/item/weapon/bonesetter,
	/obj/item/weapon/kitchenknife/butch,
	/obj/item/weapon/caution,
	/obj/item/weapon/caution/cone,
	/obj/item/weapon/crowbar,
	/obj/item/weapon/clipboard,
	/obj/item/weapon/stock_parts/cell,
	/obj/item/weapon/circular_saw,
	/obj/item/weapon/hatchet,
	/obj/item/weapon/handcuffs,
	/obj/item/weapon/hemostat,
	/obj/item/weapon/kitchenknife,
	/obj/item/weapon/lighter,
	/obj/item/weapon/light/bulb,
	/obj/item/weapon/light/tube,
	/obj/item/weapon/pickaxe,
	/obj/item/weapon/shovel,
	/obj/item/weapon/table_parts,
	/obj/item/weapon/weldingtool,
	/obj/item/weapon/wirecutters,
	/obj/item/weapon/wrench,
	/obj/item/weapon/screwdriver,
	/obj/item/weapon/grenade/chem_grenade/cleaner,
	/obj/item/weapon/grenade/chem_grenade/metalfoam,
	/obj/item/weapon/grenade/chem_grenade/teargas,
	/obj/item/weapon/match,
	/obj/item/clothing/mask/cigarette,
	/obj/item/weapon/storage/fancy/cigarettes,
	/obj/item/weapon/storage/secure/briefcase,
	/obj/item/weapon/storage/pouch/pistol_holster,
	/obj/item/weapon/storage/pouch/baton_holster,
	/obj/item/clothing/accessory/holster,
	/obj/item/weapon/reagent_containers/glass/bottle,
	/obj/item/weapon/bananapeel,
	/obj/item/weapon/reagent_containers/food/snacks/soap,
	/obj/item/device/tabletop_assistant,
	/obj/item/clothing/mask/ecig,
	/obj/item/weapon/game_kit,
	/obj/item/weapon/reagent_containers/spray/pepper,
	/obj/item/weapon/shield/buckler,
	/obj/item/clothing/head/helmet/roman,
	/obj/item/clothing/under/roman,
	/obj/item/clothing/shoes/roman,
	/obj/item/weapon/claymore/light,
	/obj/item/weapon/gun/projectile/revolver/doublebarrel/derringer,
	/obj/item/device/biocan,
	/obj/item/device/assembly/mousetrap,
	/obj/item/weapon/storage/pouch/small_generic,
	/obj/item/weapon/storage/pouch/medium_generic,
	/obj/item/weapon/storage/pouch/large_generic,
	/obj/item/weapon/storage/pouch/medical_supply,
	/obj/item/weapon/storage/pouch/engineering_tools,
	/obj/item/weapon/storage/pouch/engineering_supply,
	/obj/item/weapon/storage/pouch/ammo,
	/obj/item/weapon/storage/pouch/flare,
	/obj/item/clothing/shoes/boots,
	/obj/item/clothing/shoes/boots/galoshes,
	/obj/item/weapon/reagent_containers/pill/stox,
	/obj/item/weapon/reagent_containers/pill/dylovene,
	/obj/item/weapon/reagent_containers/pill/tox,
	/obj/item/weapon/reagent_containers/pill/kelotane,
	/obj/item/weapon/reagent_containers/pill/paracetamol,
	/obj/item/weapon/reagent_containers/pill/inaprovaline,
	/obj/item/weapon/reagent_containers/pill/dexalin,
	/obj/item/weapon/reagent_containers/pill/bicaridine,
	/obj/item/weapon/reagent_containers/pill/antirad,
	)

	var/quantity = rand(5,15)
	for (var/i in 1 to quantity)
		var/button_desc = "a [pick("yellow", "purple", "green", "blue", "red", "orange", "white")], "
		button_desc += "[pick("round", "square", "diamond", "heart", "dog", "human")] shaped "
		button_desc += "[pick("toggle", "switch", "lever", "button", "pad", "hole")]"
		var/type = pick(viables)
		viables.Remove(type)
		construction[button_desc] = type

	fail_message = "<span class='notice'>[bicon(src)] a [pick("loud", "soft", "sinister", "eery", "triumphant", "depressing", "cheerful", "angry")] \
		[pick("horn", "beep", "bing", "bleep", "blat", "honk", "hrumph", "ding")] sounds and a \
		[pick("yellow", "purple", "green", "blue", "red", "orange", "white")] \
		[pick("light", "dial", "meter", "window", "protrusion", "knob", "antenna", "swirly thing")] \
		[pick("swirls", "flashes", "whirrs", "goes schwing", "blinks", "flickers", "strobes", "lights up")] on the \
		[pick("front", "side", "top", "bottom", "rear", "inside")] of [src]. A [pick("slot", "funnel", "chute", "tube")] opens up in the \
		[pick("front", "side", "top", "bottom", "rear", "inside")].</span>"

/obj/machinery/replicator/process()
	if(spawning_types.len && powered())
		spawn_progress_time += world.time - last_process_time
		if(spawn_progress_time > max_spawn_time)
			visible_message("<span class='warning'>[bicon(src)] [src] pings!</span>")

			var/obj/source_material = pop(stored_materials)
			var/spawn_type = pop(spawning_types)
			var/obj/spawned_obj = new spawn_type(src.loc)
			if(source_material)
				if(length_char(source_material.name) < MAX_MESSAGE_LEN)
					spawned_obj.name = "[source_material] " +  spawned_obj.name
				if(length_char(source_material.desc) < MAX_MESSAGE_LEN * 2)
					if(spawned_obj.desc)
						spawned_obj.desc += " It is made of [source_material]."
					else
						spawned_obj.desc = "It is made of [source_material]."
				source_material.loc = null

			spawn_progress_time = 0
			max_spawn_time = rand(30,100)

			if(!spawning_types.len || !stored_materials.len)
				set_power_use(IDLE_POWER_USE)
				icon_state = "replicator"

		else if(prob(5))
			visible_message("<span class='warning'>[bicon(src)] [src] [pick("clicks", "whizzes", "whirrs", "whooshes", "clanks", "clongs", "clonks", "bangs")].</span>")

	last_process_time = world.time

/obj/machinery/replicator/ui_interact(mob/user)
	var/dat = "The control panel displays an incomprehensible selection of controls, many with unusual markings or text around them.<br>"
	dat += "<br>"
	for(var/index=1, index<=construction.len, index++)
		dat += "<A href='?src=\ref[src];activate=[index]'>\[[construction[index]]\]</a><br>"

	var/datum/browser/popup = new(user, "alien_replicator")
	popup.set_content(dat)
	popup.open()

/obj/machinery/replicator/attackby(obj/item/weapon/W, mob/living/user)
	if(W.flags & (NODROP | ABSTRACT | DROPDEL))
		to_chat(user, "<span class='notice'>[W] doesn't fit into [src].</span>")
		return
	user.drop_from_inventory(W, src)
	stored_materials.Add(W)
	visible_message("<span class='notice'>[user] inserts [W] into [src].</span>")

/obj/machinery/replicator/is_operational()
	return TRUE

/obj/machinery/replicator/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if(href_list["activate"])
		var/index = text2num(href_list["activate"])
		if(index > 0 && index <= construction.len)
			if(stored_materials.len > spawning_types.len)
				if(spawning_types.len)
					visible_message("<span class='notice'>[bicon(src)] a [pick("light", "dial", "display", "meter", "pad")] on [src]'s front [pick("blinks", "flashes")] [pick("red", "yellow", "blue", "orange", "purple", "green", "white")].</span>")
				else
					visible_message("<span class='notice'>[bicon(src)] [src]'s front compartment slides shut.</span>")

				spawning_types.Add(construction[construction[index]])
				spawn_progress_time = 0
				set_power_use(ACTIVE_POWER_USE)
				icon_state = "replicator_active"
			else
				visible_message(fail_message)

	updateUsrDialog()
