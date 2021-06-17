/obj/effect/proc_holder/borer/active/hostless/invis
	name = "Invisibility"
	desc = "Allows borer to become invisible to human eye. Costs 0.5 chemicals per second."
	cost = 2
	cooldown = 150

/obj/effect/proc_holder/borer/active/hostless/invis/activate(mob/living/simple_animal/borer/B)
	if(B.invisibility)
		B.deactivate_invisibility()
	else
		B.activate_invisibility()
	..()

/mob/living/simple_animal/borer/proc/activate_invisibility()
	if(!invisibility)
		alpha = 100 // so it's still visible to observers
		invisibility = 26
		to_chat(src, "<span class='notice'>You are invisible now.</span>")

/mob/living/simple_animal/borer/proc/deactivate_invisibility()
	if(invisibility)
		alpha = 255
		invisibility = 0
		to_chat(src, "<span class='notice'>You are visible now.</span>")
