/obj/effect/proc_holder/spell/targeted/shapeshift
	name = "Shapechange"
	desc = "Take on the shape of another for a time to use their natural abilities. Once you've made your choice it cannot be changed."
	//school = SCHOOL_TRANSMUTATION
	clothes_req = FALSE
	//human_req = FALSE
	charge_max = 200
	//cooldown_min = 50
	range = -1
	include_user = TRUE
	invocation = "RAC'WA NO!"
	//invocation_type = INVOCATION_SHOUT
	action_icon_state = "shapeshift"

	var/revert_on_death = TRUE
	var/die_with_shapeshifted_form = TRUE
	var/convert_damage = TRUE //If you want to convert the caster's health and blood to the shift, and vice versa.
	var/convert_damage_type = BURN //Since simplemobs don't have advanced damagetypes, what to convert damage back into.

	var/mob/living/shapeshift_type
	var/list/possible_shapes = list(
		/mob/living/simple_animal/mouse,\
		/mob/living/simple_animal/corgi,\
		/mob/living/simple_animal/hostile/giant_spider/hunter,\
		/mob/living/simple_animal/construct/armoured,)

///mob/living/simple_animal/hostile/carp/ranged/chaos,
/obj/effect/proc_holder/spell/targeted/shapeshift/cast(list/targets,mob/living/user = usr)
	if(src in user.mind.spell_list)
		LAZYREMOVE(user.mind.spell_list, src)
		user.mind.AddSpell(src)
	if(user.buckled)
		user.buckled.unbuckle_mob()
	var/mob/living/M = user
	if(!shapeshift_type)
		var/list/animal_list = list()
		var/list/display_animals = list()
		for(var/path in possible_shapes)
			var/mob/living/simple_animal/animal = path
			animal_list[initial(animal.name)] = path
			var/image/animal_image = image(icon = initial(animal.icon), icon_state = initial(animal.icon_state))
			display_animals += list(initial(animal.name) = animal_image)
		sortList(display_animals)
		var/new_shapeshift_type = show_radial_menu(M, M, display_animals, custom_check = CALLBACK(src, .proc/check_menu, user), radius = 38, require_near = TRUE)
		if(shapeshift_type)
			return
		shapeshift_type = new_shapeshift_type
		if(!shapeshift_type) //If you aren't gonna decide I am!
			shapeshift_type = pick(animal_list)
		shapeshift_type = animal_list[shapeshift_type]

	var/obj/shapeshift_holder/S = locate() in M
	if(S)
		M = Restore(M)
	else
		M = Shapeshift(M)
	// Are we currently ventcrawling?
	if(!user.is_ventcrawling)
		return

	// Can our new form support ventcrawling?
	var/ventcrawler = user.ventcrawler
	if(ventcrawler)
		return

	//you're shapeshifting into something that can't fit into a vent

	var/obj/machinery/atmospherics/pipeyoudiein = M.loc
	var/datum/pipeline/ourpipeline
	var/pipenets = pipeyoudiein.returnPipenets()
	if(islist(pipenets))
		ourpipeline = pipenets[1]
	else
		ourpipeline = pipenets

	to_chat(M, "<span class='userdanger'>Casting [src] inside of [pipeyoudiein] quickly turns you into a bloody mush!</span>")
	var/gibtype = /obj/effect/gibspawner/generic
	if(isalien(M))
		gibtype = /obj/effect/gibspawner/xeno
	for(var/obj/machinery/atmospherics/components/unary/possiblevent in range(10, get_turf(M)))
		if(possiblevent.parents.len && possiblevent.parents[1] == ourpipeline)
			new gibtype(get_turf(possiblevent))
			playsound(possiblevent, 'sound/effects/reee.ogg', 75, TRUE)
	//priority_announce("We detected a pipe blockage around [get_area(get_turf(M))], please dispatch someone to investigate.", "Central Command")
	M.death()
	qdel(M)

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 */
/obj/effect/proc_holder/spell/targeted/shapeshift/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/shapeshift/proc/Shapeshift(mob/living/caster)
	var/obj/shapeshift_holder/H = locate() in caster
	if(H)
		to_chat(caster, "<span class='userdanger'>You're already shapeshifted!</span>")
		return

	var/mob/living/shape = new shapeshift_type(caster.loc)
	H = new(shape, src, caster)

	clothes_req = FALSE
	//human_req = FALSE
	return shape

/obj/effect/proc_holder/spell/targeted/shapeshift/proc/Restore(mob/living/shape)
	var/obj/shapeshift_holder/H = locate() in shape
	if(!H)
		return

	. =  H.stored
	H.restore()

	clothes_req = initial(clothes_req)
	//human_req = initial(human_req)

/obj/effect/proc_holder/spell/targeted/shapeshift/dragon
	name = "Dragon Form"
	desc = "Take on the shape a lesser ash drake."
	invocation = "RAAAAAAAAWR!"
	convert_damage = FALSE

	shapeshift_type = /mob/living/carbon/slime/adult


/obj/shapeshift_holder
	name = "Shapeshift holder"
	resistance_flags = INDESTRUCTIBLE// | LAVA_PROOF | FIRE_PROOF | ON_FIRE | UNACIDABLE | ACID_PROOF
	var/mob/living/stored
	var/mob/living/shape
	var/restoring = FALSE
	var/obj/effect/proc_holder/spell/targeted/shapeshift/source

/obj/shapeshift_holder/atom_init(mapload, obj/effect/proc_holder/spell/targeted/shapeshift/_source, mob/living/caster)
	. = ..()
	source = _source
	shape = loc
	if(!istype(shape))
		stack_trace("shapeshift holder created outside /mob/living")
		to_chat(world, "Living")
		return INITIALIZE_HINT_QDEL
	stored = caster
	if(stored.mind)
		stored.mind.transfer_to(shape)
		shape.spell_list = stored.spell_list
	stored.forceMove(src)
	stored.notransform = TRUE
	if(source.convert_damage)
		var/damage_percent = (stored.maxHealth - stored.health)/stored.maxHealth;
		var/damapply = damage_percent * shape.maxHealth;
		shape.apply_damage(damapply, source.convert_damage_type)//, forced = TRUE, wound_bonus=CANT_WOUND);

	RegisterSignal(shape, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_DIED), .proc/shape_death)
	RegisterSignal(stored, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_DIED), .proc/caster_death)

/obj/shapeshift_holder/Destroy()
	// Restore manages signal unregistering. If restoring is TRUE, we've already unregistered the signals and we're here
	// because restore() qdel'd src.
	if(!restoring)
		restore()
	stored = null
	shape = null
	return ..()

/obj/shapeshift_holder/Moved()
	. = ..()
	if(!restoring || QDELETED(src))
		restore()

/obj/shapeshift_holder/handle_atom_del(atom/A)
	if(A == stored && !restoring)
		restore()

/obj/shapeshift_holder/Exited(atom/movable/gone, direction)
	if(stored == gone && !restoring)
		restore()

/obj/shapeshift_holder/proc/caster_death()
	SIGNAL_HANDLER
	//Something kills the stored caster through direct damage.
	if(source.revert_on_death)
		restore(death=TRUE)
	else
		shape.death()

/obj/shapeshift_holder/proc/shape_death()
	SIGNAL_HANDLER
	//Shape dies.
	if(source.die_with_shapeshifted_form)
		if(source.revert_on_death)
			restore(death=TRUE)
	else
		restore()

/obj/shapeshift_holder/proc/restore(death=FALSE)
	// Destroy() calls this proc if it hasn't been called. Unregistering here prevents multiple qdel loops
	// when caster and shape both die at the same time.
	UnregisterSignal(shape, list(COMSIG_PARENT_QDELETING))//, COMSIG_LIVING_DEATH))
	UnregisterSignal(stored, list(COMSIG_PARENT_QDELETING))//, COMSIG_LIVING_DEATH))
	restoring = TRUE
	stored.forceMove(shape.loc)
	stored.notransform = FALSE
	if(shape.mind)
		shape.mind.transfer_to(stored)
	if(death)
		stored.death()
	else if(source.convert_damage)
		stored.revive()

		var/damage_percent = (shape.maxHealth - shape.health)/shape.maxHealth;
		var/damapply = stored.maxHealth * damage_percent

		stored.apply_damage(damapply, source.convert_damage_type)//, forced = TRUE, wound_bonus=CANT_WOUND)
	/*if(source.convert_damage)
		if(ishuman(stored))
			var/mob/living/carbon/human/H = stored
			H.blood_amount() = shape.blood_volume;*/
	// This guard is important because restore() can also be called on COMSIG_PARENT_QDELETING for shape, as well as on death.
	// This can happen in, for example, [/proc/wabbajack] where the mob hit is qdel'd.
	if(!QDELETED(shape))
		QDEL_NULL(shape)

	qdel(src)
/*
/mob/living/simple_animal/hostile/carp/ranged
	name = "magicarp"
	desc = "50% magic, 50% carp, 100% horrible."
	icon_state = "magicarp"
	icon_living = "magicarp"
	icon_dead = "magicarp_dead"
	icon_gib = "magicarp_gib"
	ranged = 1
	retreat_distance = 2
	minimum_distance = 0 //Between shots they can and will close in to nash
	projectiletype = /obj/item/projectile/magic
	projectilesound = 'sound/weapons/guns/gunpulse_emitter.ogg'
	maxHealth = 50
	health = 50
	//gold_core_spawnable = NO_SPAWN
	//random_color = FALSE

	var/allowed_projectile_types = list(/obj/projectile/magic/change, /obj/projectile/magic/animate, /obj/item/projectile/magic/healing_ball,
	/obj/projectile/magic/death, /obj/projectile/magic/teleport, /obj/projectile/magic/door, /obj/item/projectile/magic/fireball,
	/obj/item/projectile/magic/lightning, /obj/item/projectile/magic/Arcane_barrage)

/mob/living/simple_animal/hostile/carp/ranged/atom_init()
	projectiletype = pick(allowed_projectile_types)
	. = ..()

/mob/living/simple_animal/hostile/carp/ranged/chaos
	name = "chaos magicarp"
	desc = "50% carp, 100% magic, 150% horrible."
	color = "#00FFFF"
	maxHealth = 75
	health = 75
	//gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/hostile/carp/ranged/chaos/Shoot()
	projectiletype = pick(allowed_projectile_types)
	..()

/mob/living/simple_animal/hostile/carp/ranged/xenobiology // these are for the xenobio gold slime pool
	//gold_core_spawnable = HOSTILE_SPAWN
	allowed_projectile_types = list(/obj/projectile/magic/animate, /obj/projectile/magic/teleport,
	/obj/projectile/magic/door, /obj/projectile/magic/aoe/fireball, /obj/projectile/magic/spellblade, /obj/projectile/magic/arcane_barrage) //thanks Lett1

/mob/living/simple_animal/hostile/carp/ranged/chaos/xenobiology
	//gold_core_spawnable = HOSTILE_SPAWN
	allowed_projectile_types = list(/obj/projectile/magic/animate, /obj/projectile/magic/teleport,
	/obj/projectile/magic/door, /obj/projectile/magic/aoe/fireball, /obj/projectile/magic/spellblade, /obj/projectile/magic/arcane_barrage)
*/
