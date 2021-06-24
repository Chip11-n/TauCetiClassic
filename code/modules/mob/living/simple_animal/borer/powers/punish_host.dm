/obj/effect/proc_holder/borer/active/control/punish_host
	name = "Torment host"
	desc = "Punish your host with agony."
	cooldown = 150

/obj/effect/proc_holder/borer/active/control/punish_host/activate(mob/user)
	var/mob/living/simple_animal/borer/B = user.has_brain_worms()
	if(!B)
		return

	if(B.host_brain.ckey)
		to_chat(user, "<span class='danger'>You send a punishing spike of psychic agony lancing into your host's brain.</span>")
		to_chat(B.host_brain, "<span class='danger'><FONT size=3>Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!</FONT></span>")
	
		put_on_cd()
