/datum/component/darkness_healing
	var/multiplier = 1

/datum/component/darkness_healing/Initialize()
	if (!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	START_PROCESSING(SSobj, src)

/datum/component/darkness_healing/Destroy(force, silent)
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/darkness_healing/process(delta_time)
	var/mob/living/carbon/human/H = parent
	if(!isturf(H.loc))
		return

	var/turf/T = H.loc
	if(round(10 * T.get_lumcount()) < LIGHT_HEAL_THRESHOLD)
		H.heal_overall_damage(1 * multiplier, 1 * multiplier)
		H.adjustToxLoss(-0.5 * multiplier)
		H.adjustBrainLoss(-0.5 * multiplier)
		H.adjustCloneLoss(-0.5 * multiplier)
		H.adjustOxyLoss(-1 * multiplier)
		H.adjustHalLoss(-1 * multiplier)
		H.AdjustWeakened(-1 * multiplier)
		H.nutrition = max(NUTRITION_LEVEL_HUNGRY, H.nutrition)

	else if(multiplier > 1)
		H.take_overall_damage(0, LIGHT_DAMAGE_TAKEN / 2 * multiplier)
		to_chat(H, "<span class='userdanger'>The light burns you!</span>")
		H.playsound_local(null, 'sound/weapons/sear.ogg', VOL_EFFECTS_MASTER, null, FALSE)
