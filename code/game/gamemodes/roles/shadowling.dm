/datum/role/shadowling
	name = SHADOW
	id = SHADOW

	required_pref = ROLE_SHADOWLING
	restricted_jobs = list("AI", "Cyborg", "Security Cadet", "Security Officer", "Warden", "Head of Security", "Captain", "Blueshield Officer")
	restricted_species_flags = list(IS_SYNTHETIC)

	antag_hud_type = ANTAG_HUD_SHADOW
	antag_hud_name = "hudshadowling"

	logo_state = "shadowling-logo"

	skillset_type = /datum/skillset/shadowling
	change_to_maximum_skills = TRUE

/datum/role/shadowling/Greet(greeting, custom)
	. = ..()
	to_chat(antag.current, "<b>Вы - Шедоулинг. На данный момент, вы скрываетесь под личиной одного из сотрудников станции [station_name()].</b>")
	to_chat(antag.current, "<b>В этой слабой оболочке, вы способны лишь: Enthrall - поработить не просвещённого, Hatch - облачиться в свою истинную форму (находится во вкладке Shadowling Evolution в верхней-правой части экрана), и Hivemind Commune - общаться с себе подобными братьями и рабами.</b>")
	to_chat(antag.current, "<b>Другие Шедоулинги являются вашими братьями и союзниками. Вы должны помогать им, как и они вам, для достижения общей цели.</b>")
	to_chat(antag.current, "<b>Если вы впервые играете за Шедоулинга, или хотите ознакомится с вашими способностями, перейдите на эту страницу нашей вики - https://wiki.taucetistation.org/Shadowling</b><br>")

/datum/role/shadowling/OnPostSetup(laterole)
	. = ..()
	var/mob/living/carbon/human/S = antag.current

	if(antag.assigned_role == "Clown")
		to_chat(S, "<span class='notice'>Ваша нечеловеческая природа позволила преодолеть вашего внутреннего клоуна.</span>")
		REMOVE_TRAIT(S, TRAIT_CLUMSY, GENETIC_MUTATION_TRAIT)

	S.verbs += /mob/living/carbon/human/proc/shadowling_hatch
	S.AddSpell(new /obj/effect/proc_holder/spell/targeted/enthrall)
	S.AddSpell(new /obj/effect/proc_holder/spell/targeted/shadowling_hivemind)
	RegisterSignal(S, COMSIG_MOB_DIED, .proc/shadowling_death_signal)

/datum/role/shadowling/proc/shadowling_death_signal()
	SIGNAL_HANDLER
	var/shadowling_alive = FALSE
	for(var/datum/role/shadowling/S in faction.members)
		if(S.antag.current.stat != DEAD && S.antag.current != antag.current) //We have at least one S-ling alive
			shadowling_alive = TRUE

	for(var/datum/role/thrall/T in faction.members)
		if(!T.antag.current)
			continue

		to_chat(T.antag.current, "<span class='shadowling'><font size=3>Sudden realization strikes you like a truck! ONE OF OUR MASTERS HAS DIED!!!</span></font>")

		if(shadowling_alive)
			return

		SEND_SIGNAL(T.antag.current, COMSIG_CLEAR_MOOD_EVENT, "thralled")
		SEND_SIGNAL(T.antag.current, COMSIG_ADD_MOOD_EVENT, "master_died", /datum/mood_event/master_died)
		T.antag.current.AddSpell(new /obj/effect/proc_holder/spell/no_target/shadow_ascension)

/datum/role/thrall/RemoveFromRole(datum/mind/M, msg_admins)
	for(var/I in list(/obj/effect/proc_holder/spell/targeted/enthrall,
		/obj/effect/proc_holder/spell/targeted/shadowling_hivemind))
		var/obj/effect/proc_holder/spell/S = antag.current.GetSpell(I)
		if(S)
			antag.current.RemoveSpell(S)

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

/datum/role/thrall/Greet(greeting, custom)
    . = ..()
    to_chat(antag.current, "<b>Вы были порабощены Шедоулингом и обязаны выполнять любой приказ, и помогать ему в достижении его целей.</b>")

/datum/role/thrall/OnPreSetup(greeting, custom)
	. = ..()
	antag.current.AddSpell(new /obj/effect/proc_holder/spell/targeted/shadowling_hivemind)
	var/obj/effect/proc_holder/spell/targeted/enthrall/thrall_mark/S = new()
	S.role = src
	antag.current.AddSpell(S)
	SEND_SIGNAL(antag.current, COMSIG_ADD_MOOD_EVENT, "thralled", /datum/mood_event/thrall)

/datum/role/thrall/RemoveFromRole(datum/mind/M, msg_admins)
	SEND_SIGNAL(antag.current, COMSIG_CLEAR_MOOD_EVENT, "thralled")

	for(var/I in list(/obj/effect/proc_holder/spell/targeted/enthrall/thrall_mark,
		/obj/effect/proc_holder/spell/no_target/shadow_ascension,
		/obj/effect/proc_holder/spell/targeted/shadowling_hivemind))
		var/obj/effect/proc_holder/spell/S = antag.current.GetSpell(I)
		if(S)
			antag.current.RemoveSpell(S)

	..()

/datum/role/thrall/proc/get_mark()
	to_chat(antag.current, "<span class='shadowling'>Мастер принял подношение, и великодушно даровал тебе частицу духа Его нового раба!</span>")
	marks++
	if(marks > 2 && stage < 1)
		to_chat(antag.current, "<span class='shadowling'><i>Тьма сгущается в твоей душе, и ты получил <b>Дарование Тьмы</b>. Теперь Тьма будет лечить и помогать тебе, пускай и не столь сильно.</i></span>")
		antag.current.AddComponent(/datum/component/darkness_healing)
		stage++

	if(marks > 4 && stage < 2)
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

	if(marks > 6 && stage < 3)
		to_chat(antag.current, "<span class='shadowling'><i>Тьма сгущается в твоей душе, и ты получил <b>Вуаль тьмы</b>. Позволяет тебе погружать окружающее пространство во тьму, как это делает Мастер.</i></span>")
		antag.current.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/veil)
		stage++

	if(marks > 8  && stage < 4)
		to_chat(antag.current, "<span class='shadowling'><i>Тьма сгущается в твоей душе, заполоняя её... И внезапно, ты понял... <b>Ты - Мастер!</b></i></span>")
		var/datum/faction/shadowlings/F = faction
		F.thrall2master(antag.current, src)
