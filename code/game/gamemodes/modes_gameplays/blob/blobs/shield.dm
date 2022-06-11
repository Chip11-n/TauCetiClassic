/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	desc = "Some blob creature thingy."
	health = 75
	fire_resist = 2


/obj/effect/blob/shield/update_icon()
	if(health <= 0)
		qdel(src)
		return
	return

/obj/effect/blob/shield/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/obj/effect/blob/shield/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return istype(mover) && mover.checkpass(PASSBLOB)

/obj/effect/blob/shield/reflective
	name = "reflective blob"
	icon_state = "blob_glow"
	desc = "Some blob creature thingy."
	health = 30 //Normal blob
	brute_resist = 2 //Normal is 4
	fire_resist = 1 //2 welder hits

/obj/effect/blob/shield/reflective/bullet_act(obj/item/projectile/P, def_zone)
	if(is_type_in_list(P,list(/obj/item/projectile/energy,/obj/item/projectile/beam, /obj/item/projectile/pyrometer, /obj/item/projectile/plasma,/obj/item/projectile/energy/bolt, /obj/item/projectile/energy/electrode, /obj/item/projectile/beam/stun, /obj/item/projectile/bullet/stunshot)))
	//Basically all of energy type projes...
		if(P.starting)
			var/new_x = P.starting.x + pick(0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(src)
			P.redirect(new_x, new_y, curloc) //Stolen from armor' deflection
			return PROJECTILE_FORCE_MISS
	. = ..()
