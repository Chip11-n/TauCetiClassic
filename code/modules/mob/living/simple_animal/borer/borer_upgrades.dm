#define COST_INNATE 0

/obj/effect/proc_holder/borer
    panel = "Borer"
    name = ""
    desc = null

    var/cost = COST_INNATE

    // list of paths that need to be bought before this
    var/list/requires_t = list()

/obj/effect/proc_holder/borer/proc/on_gain(mob/user)
    return

/obj/effect/proc_holder/borer/proc/on_lose(mob/user)
    return

/obj/effect/proc_holder/borer/proc/can_use(mob/user)
    return FALSE

/obj/effect/proc_holder/borer/proc/can_activate(mob/user)
    return can_use(user)

/obj/effect/proc_holder/borer/proc/activate(mob/user)
    return 

/obj/effect/proc_holder/borer/proc/get_stat_entry()
    return null

/obj/effect/proc_holder/borer/Click()
    if(!can_activate(usr))
        return
    activate(usr)

/obj/effect/proc_holder/borer/active
    var/cooldown = 0
    var/last_used = 0
    var/chemicals = 0
 
/obj/effect/proc_holder/borer/active/can_use(mob/user)
    return TRUE

/obj/effect/proc_holder/borer/active/get_stat_entry()
    var/cooldown_str = cooldown ? "([round(get_recharge() / 10)]/[cooldown / 10]) " : null
    var/chemical_str = chemicals ? "([chemicals] c.)" : null
    return "[cooldown_str][chemical_str]"

/obj/effect/proc_holder/borer/active/proc/get_recharge()
    return clamp(world.time - last_used, 0, cooldown)

/obj/effect/proc_holder/borer/active/can_activate(mob/user)
    var/mob/living/simple_animal/borer/B = user.has_brain_worms()
    if(!B)
        return FALSE
    return can_use(user) && (get_recharge() >= cooldown) && B.hasChemicals(chemicals)

/obj/effect/proc_holder/borer/active/proc/put_on_cd()
    last_used = world.time

/obj/effect/proc_holder/borer/active/proc/use_chemicals(mob/living/simple_animal/borer/B)
    return B.useChemicals(chemicals)

/obj/effect/proc_holder/borer/active/proc/cd_and_chemicals(mob/living/simple_animal/borer/B)
    if(use_chemicals(B))
        put_on_cd()
        return TRUE
    return FALSE

/obj/effect/proc_holder/borer/active/activate(mob/user)
    return cd_and_chemicals(user.has_brain_worms())

/obj/effect/proc_holder/borer/active/noncontrol/can_use(mob/user)
    var/mob/living/simple_animal/borer/B = user
    return istype(B) && B.host

/obj/effect/proc_holder/borer/active/control/can_use(mob/user)
    var/mob/living/simple_animal/borer/B = user.has_brain_worms()
    return istype(B) && B.controlling

/obj/effect/proc_holder/borer/active/hostless/can_use(mob/user)
    var/mob/living/simple_animal/borer/B = user
    return istype(B) && !B.host
