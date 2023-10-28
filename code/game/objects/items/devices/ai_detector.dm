// Syndicate device disguised as a multitool; it will turn red when an AI camera is nearby. TG-stuff
/obj/item/device/multitool/ai_detect
	icon_state = "multitool"

/obj/item/device/multitool/ai_detect/examine(mob/user)
	. = ..()
	if(isanyantag(user))
		to_chat(user, "<span class='notice'>Это точно не простой мультул.</span>")

/obj/item/device/multitool/ai_detect/equipped(mob/living/user, slot)
	. = ..()
	user.AddElement(/datum/element/digitalcamo)

/obj/item/device/multitool/ai_detect/dropped(mob/living/user)
	. = ..()
	user.RemoveElement(/datum/element/digitalcamo)
