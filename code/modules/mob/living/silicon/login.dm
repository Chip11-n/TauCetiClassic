/mob/living/silicon/Login()
	..()
	if(mind && SSticker && SSticker.mode)
		for(var/role in list(CULTIST, REV, HEADREV))
			var/datum/role/R = mind.GetRole(role)
			if(R)
				R.Deconvert()
