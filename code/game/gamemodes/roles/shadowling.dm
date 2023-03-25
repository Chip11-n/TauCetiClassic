/datum/role/shadowling
	name = SHADOW
	id = SHADOW

	required_pref = ROLE_SHADOWLING
	restricted_jobs = list("AI", "Cyborg", "Security Cadet", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Blueshield Officer")
	restricted_species_flags = list(IS_SYNTHETIC)

	antag_hud_type = ANTAG_HUD_SHADOW
	antag_hud_name = "hudshadowling"

	logo_state = "shadowling-logo"

	skillset_type = /datum/skillset/shadowling
	change_to_maximum_skills = TRUE

/datum/role/shadowling/Greet(greeting, custom)
	. = ..()
	to_chat(antag.current, "<b>Currently, you are disguised as an employee aboard [station_name()].</b>")
	to_chat(antag.current, "<b>In your limited state, you have three abilities: Enthrall, Hatch, and Hivemind Commune.</b>")
	to_chat(antag.current, "<b>Any other shadowlings are you allies. You must assist them as they shall assist you.</b>")
	to_chat(antag.current, "<b>If you are new to shadowling, or want to read about abilities, check the wiki page at https://wiki.taucetistation.org/Shadowling</b><br>")

/datum/role/shadowling/OnPostSetup(laterole)
	. = ..()
	var/mob/living/carbon/human/S = antag.current

	if(antag.assigned_role == "Clown")
		to_chat(S, "<span class='notice'>Your alien nature has allowed you to overcome your clownishness.</span>")
		REMOVE_TRAIT(S, TRAIT_CLUMSY, GENETIC_MUTATION_TRAIT)

	S.verbs += /mob/living/carbon/human/proc/shadowling_hatch
	S.AddSpell(new /obj/effect/proc_holder/spell/targeted/enthrall)
	S.AddSpell(new /obj/effect/proc_holder/spell/targeted/shadowling_hivemind)

/datum/role/thrall
	name = SHADOW_THRALL
	id = SHADOW_THRALL

	antag_hud_type = ANTAG_HUD_SHADOW
	antag_hud_name = "hudthrall"

	logo_state = "thrall-logo"

	skillset_type = /datum/skillset/thrall
	change_to_maximum_skills = TRUE
	var/marks = 0
	var/stage = 0

/datum/role/thrall/OnPreSetup(greeting, custom)
	. = ..()
	antag.current.AddSpell(new /obj/effect/proc_holder/spell/targeted/shadowling_hivemind)
	var/obj/effect/proc_holder/spell/targeted/enthrall/thrall_mark/S = new()
	S.role = src
	antag.current.AddSpell(S)
	SEND_SIGNAL(antag.current, COMSIG_ADD_MOOD_EVENT, "thralled", /datum/mood_event/thrall)

/datum/role/thrall/RemoveFromRole(datum/mind/M, msg_admins)
	SEND_SIGNAL(antag.current, COMSIG_CLEAR_MOOD_EVENT, "thralled")
	..()
/mob/verb/get_mark()
	set name = "/get_mark()"
	set desc = "/get_mark()"
	set category = "Ghost"
	var/mob/M = usr
	for(var/R in M.mind.antag_roles)
		var/datum/role/thrall/T = antag_roles[R]
		T.get_mark()

/datum/role/thrall/proc/get_mark()
	to_chat(antag.current, "<span class='shadowling'>Мастер принял подношение, и великодушно даровал тебе частицу духа Его нового раба!</span>")
	marks++
	if(marks > 3 && stage < 1)
		to_chat(antag.current, "<span class='shadowling'><i>Тьма сгущается в твоей душе, и ты получил <b>Дарование Тьмы</b>. Теперь Тьма будет лечить и помогать тебе, пускай и не столь сильно.</i></span>")
		antag.current.AddComponent(/datum/component/darkness_healing)
		stage++

	if(marks > 5 && stage < 2)
		to_chat(antag.current, "<span class='shadowling'><i>Тьма сгущается в твоей душе, и ты получил <b>Озарение во тьме</b>. Твои глаза теперь источник ужаса для непрозревших, а ты можешь видеть во тьме отныне!.</i></span>")

		var/datum/component/darkness_healing/C = antag.current.GetComponent(/datum/component/darkness_healing)
		if(C)
			C.multiplier = 2
			var/mutable_appearance/img_eyes_s = mutable_appearance('icons/mob/human_face.dmi', "shadowling_ms_s", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE)
			var/mob/living/carbon/human/H = antag.current
			antag.current.overlays |= img_eyes_s
			if(H.glasses)
				H.drop_from_inventory(H.glasses, get_turf(H))
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/shadowling, SLOT_GLASSES)
			stage++

	if(marks > 8 && stage < 3)
		to_chat(antag.current, "<span class='shadowling'><i>Тьма сгущается в твоей душе, и ты получил <b>Вуаль тьмы</b>. Позволяет тебе погружать окружающее пространство во тьму, как это делает Мастер.</i></span>")
		antag.current.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/veil)
		stage++

	if(marks > 12  && stage < 4)
		to_chat(antag.current, "<span class='shadowling'><i>Тьма сгущается в твоей душе, заполоняя её... И внезапно, ты понял... <b>Ты - Мастер!</b></i></span>")
		var/datum/faction/shadowlings/F = faction
		F.thrall2master(antag.current, src)

/datum/role/thrall/Drop()
	var/obj/effect/proc_holder/spell/M = antag.current.GetSpell(/obj/effect/proc_holder/spell/targeted/enthrall/thrall_mark)
	if(M)
		antag.current.RemoveSpell(M)
	/*for(var/obj/effect/proc_holder/spell/S in antag.current.spell_list)
		if(is_type_in_list(S, list(/obj/effect/proc_holder/spell/targeted/shadowling_hivemind, /obj/effect/proc_holder/spell/targeted/enthrall/thrall_mark)))
			antag.current.RemoveSpell(S)*/
	..()
