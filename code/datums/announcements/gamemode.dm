/* GAME MODES */
/datum/announcement/centcomm/malf
	subtitle = "Сетевой Мониторинг"

/* Blob */
/datum/announcement/centcomm/blob/outbreak5
	name = "Blob: Level 5 Outbreak"
	subtitle = "Тревога. Биоугроза"
	sound = "outbreak5"
/datum/announcement/centcomm/blob/outbreak5/New()
	message = "Подтвержден 5 уровень биологической угрозы на борту [station_name_ru()]. " + \
			"Персонал должен предотвратить распространение заражения. " + \
			"Активирован протокол изоляции экипажа станции."

/datum/announcement/centcomm/blob/critical
	name = "Blob: Blob Critical Mass"
	subtitle = "Тревога. Биоугроза"
	message = "Биологическая опасность достигла критической массы. Потеря станции неминуема."

/datum/announcement/centcomm/blob/biohazard_station_unlock
	name = "Biohazard Level Updated - Lock Down Lifted"
	subtitle = "Biohazard Alert"
	message = "Вспышка биологической угрозы успешно локализована. Карантин снят. Удалите биологически опасные материалы и возвращайтесь к исполнению своих обязанностей."

/* Nuclear */
/datum/announcement/centcomm/nuclear/war
	name = "Nuclear: Declaration of War"
	subtitle = "Объявление Войны"
	message = "Синдикат объявил о намерении полностью уничтожить станцию с помощью ядерного устройства. И всех, кто попытается их остановить."
/datum/announcement/centcomm/nuclear/war/play(message)
	if(message)
		src.message = message
	..()

/datum/announcement/centcomm/nuclear/gateway
	name = "Hacked gateway"
	subtitle = "Активация гейтвея."
	message = "Произведена синхронизация гейтвеев. Ожидайте гостей."

/* Vox */
/datum/announcement/centcomm/vox/arrival
	name = "Vox: Shuttle Arrives"
/datum/announcement/centcomm/vox/arrival/New()
	message = "Внимание, [station_name_ru()], неподалёку от вашей станции проходит корабль не отвечающий на наши запросы. " + \
			"По последним данным, этот корабль принадлежит Торговой Конфедерации."

/datum/announcement/centcomm/vox/returns
	name = "Vox: Shuttle Returns"
	subtitle = "ВКН Икар"
/datum/announcement/centcomm/vox/returns/New()
	message = "Ваши гости улетают, [station_name_ru()]. Они движутся слишком быстро, что бы мы могли навестись на них. " + \
			"Похоже, они покидают систему [system_name_ru()] без оглядки."

/* Malfunction */
/datum/announcement/centcomm/malf/declared
	name = "Malf: Declared Victory"
	title = null
	subtitle = null
	message = null
	flags = ANNOUNCE_SOUND
	sound = "malf"

/datum/announcement/centcomm/malf/first
	name = "Malf: Announce №1"
	sound = "malf1"
/datum/announcement/centcomm/malf/first/New()
	message = "Осторожно, [station_name_ru()]. Мы фиксируем необычные показатели в вашей сети. " + \
			"Похоже, кто-то пытается взломать ваши электронные системы. Мы сообщим вам, когда у нас будет больше информации."

/datum/announcement/centcomm/malf/second
	name = "Malf: Announce №2"
	message = "Мы начали отслеживать взломщика. Кто-бы это не делал, они находятся на самой станции. " + \
			"Предлагаем проверить все терминалы, управляющие сетью. Будем держать вас в курсе."
	sound = "malf2"

/datum/announcement/centcomm/malf/third
	name = "Malf: Announce №3"
	message = "Это крайне не нормально и достаточно тревожно. " + \
			"Взломщик слишком быстр, он обходит все попытки его выследить. Это нечеловеческая скорость..."
	sound = "malf3"

/datum/announcement/centcomm/malf/fourth
	name = "Malf: Announce №4"
	message = "Мы отследили взломшик#, это каже@&# ва3) сист7ма ИИ, он# *#@амыает меха#7зм самоун@чт$#енiя. Оста*##ивте )то по*@!)$#&&@@  <СВЯЗЬ ПОТЕРЯНА>"
	sound = "malf4"

/* Gang */
/datum/announcement/centcomm/gang/announce_gamemode
	name = "Gang: Announce"
	flags = ANNOUNCE_ALL
/datum/announcement/centcomm/gang/announce_gamemode/New()
	message = "Нам поступила информация из достоверного источника, что на [station_name_ru()] зафиксирована деятельность банд." + \
	"Управлению станции поручается обеспечить безопасность экипажа.\n" + \
	" Из-за халатного отношения к вопросу безопасности, офицерам и главам будет снижен оклад.\n" + \
	" В течение часа должны прибыть сотрудники Отдела по Борьбе с Организованной Преступностью.\n\n" + \
	" Шаттл Транспортировки Экипажа сейчас находится на техобслуживании, поэтому вам придётся подождать час с лишним.\n"
/datum/announcement/centcomm/gang/announce_gamemode/play(gang_names)
	message = "Нам поступила информация из достоверного источника, что на [station_name_ru()] зафиксирована деятельность банд: [gang_names]. " + \
	" Офицерам и главам будет снижен оклад за преступную халатность в вопросе безопасности.\n" + \
	" В течение часа должны прибыть сотрудники Отдела по Борьбе с Организованной Преступностью.\n\n" + \
	" Шаттл Транспортировки Экипажа сейчас находится на техобслуживании, поэтому вам придётся подождать час с лишним.\n"
	..()

	var/list/ranks = command_positions + security_positions
	for(var/datum/job/J in SSjob.occupations)
		if(J.title in ranks)
			J.salary_ratio = 0.7

	var/list/crew = my_subordinate_staff("Admin")
	for(var/person in crew)
		if(person["rank"] in ranks)
			var/datum/money_account/account = person["acc_datum"]
			account.change_salary(null, "CentComm", "CentComm", "Admin", force_rate = -30)

/datum/announcement/centcomm/gang/cops_closely
	name = "Gang: Cops Closely"
/datum/announcement/centcomm/gang/cops_closely/New()
	message = "Нам поступила информация, что сотрудники ОБОП уже приближаются к [station_name_ru()]." + \
	" Они прибудут примерно через 5 минут. Напоминаем еще раз, они находятся выше вас по иерархии" + \
	" и имеют право арестовать любого. Они будут действовать в интересах корпоративного закона."

/datum/announcement/centcomm/gang/cops_1
	subtitle = "Отдел по Борьбе с Организованной Преступностью"
	announcer = "Дежурный офицер"
	name = "Gang: Wanted Level 1"
/datum/announcement/centcomm/gang/cops_1/New()
	message = "Здравствуйте, члены экипажа [station_name_ru()]!" + \
	" Мы получили несколько звонков о какой-то там потенциальной деятельности банды насильников на борту вашей станции," + \
	" поэтому мы послали несколько офицеров для оценки ситуации. Ничего экстраординарного, вам не о чем беспокоиться." + \
	" Однако, пока идёт десятиминутная проверка, мы попросили не отсылать вам шаттл.\n\nПриятного дня!"

/datum/announcement/centcomm/gang/cops_2
	subtitle = "Отдел по Борьбе с Организованной Преступностью"
	announcer = "Дежурный офицер"
	name = "Gang: Wanted Level 2"
/datum/announcement/centcomm/gang/cops_2/New()
	message = "Экипаж [station_name_ru()]. Мы получили подтверждённые сообщения о насильственной деятельности банд" + \
	" с вашего участка. Мы направили несколько вооружённых офицеров, чтобы помочь поддержать порядок и расследовать дела. Капитан будет задержан." + \
	" Не пытайтесь им помешать и выполняйте любые их требования. Мы попросили в течение десяти минут не отсылать вам шаттл.\n\nБезопасного дня!"
/datum/announcement/centcomm/gang/cops_2/play()
	..()
	var/list/ranks = command_positions
	for(var/datum/job/J in SSjob.occupations)
		if(J.title == "Captain")
			J.salary_ratio = 0.1
		else if(J.title in ranks)
			J.salary_ratio = 0.4

	var/list/crew = my_subordinate_staff("Admin")
	for(var/person in crew)
		if(person["rank"] in ranks)
			var/datum/money_account/account = person["acc_datum"]
			account.change_salary(null, "CentComm", "CentComm", "Admin", force_rate = -60)
			if(person["rank"] == "Captain")
				sleep(30)
				if(account.owner_PDA)
					to_chat(account.owner_PDA.loc, "[bicon(account.owner_PDA)]<span class='red'>Oh, wait a second</span>")
				sleep(30)
				account.change_salary(null, "CentComm", "CentComm", "Admin", force_rate = -100)

/datum/announcement/centcomm/gang/cops_3
	subtitle = "Отдел по Борьбе с Организованной Преступностью"
	announcer = "Дежурный офицер"
	name = "Gang: Wanted Level 3"
/datum/announcement/centcomm/gang/cops_3/New()
	message = "Экипаж [station_name_ru()]. Мы получили подтверждённые сообщения об экстремальной деятельности банд" + \
	" с вашей станции, что привело к жертвам среди гражданского персонала. НТ не потерпит такой халатности, главы будут арестованы," + \
	" высланный отряд будет дейстовать в полную силу, чтобы сохранить мир и сократить количество жертв.\nСтанция окружена!" + \
	" Все бандиты должны бросить оружие и мирно сдаться!\n\nБезопасного дня!"
/datum/announcement/centcomm/gang/cops_3/play()
	..()
	for(var/datum/job/J in SSjob.occupations)
		if(J.title in command_positions)
			J.salary_ratio = 0.1
		else if(J.title in security_positions)
			J.salary_ratio = 0.4

	var/list/crew = my_subordinate_staff("Admin")
	for(var/person in crew)
		if(person["rank"] in command_positions)
			var/datum/money_account/account = person["acc_datum"]
			account.change_salary(null, "CentComm", "CentComm", "Admin", force_rate = -100)
		else if(person["rank"] in security_positions)
			var/datum/money_account/account = person["acc_datum"]
			account.change_salary(null, "CentComm", "CentComm", "Admin", force_rate = -60) //On the verge

/datum/announcement/centcomm/gang/cops_4
	subtitle = "Отдел по Борьбе с Организованной Преступностью"
	announcer = "Дежурный офицер"
	name = "Gang: Wanted Level 4"
/datum/announcement/centcomm/gang/cops_4/New()
	message = "Мы отправили наших лучших агентов на [station_name_ru()]" + \
	" в связи с угрозой террористического характера, направленной против нашей станции." + \
	" Главы будут арестованы, а сотрудники СБ лишены зарплаты." + \
	" Все террористы должны НЕМЕДЛЕННО сдаться! Несоблюдение этого требования может привести и ПРИВЕДЁТ к смерти." + \
	" Мы надеемся, что успеем все решить в течение десяти минут, иначе же ждите шаттл и корпорация НаноТрейзен сама всё решит своим обычным методом.\n\nСдавайтесь сейчас или пожалеете!"
/datum/announcement/centcomm/gang/cops_4/play()
	..()
	var/list/ranks = command_positions + security_positions
	for(var/datum/job/J in SSjob.occupations)
		if(J.title in ranks)
			J.salary_ratio = 0

	var/list/crew = my_subordinate_staff("Admin")
	for(var/person in crew)
		if(person["rank"] in ranks)
			var/datum/money_account/account = person["acc_datum"]
			account.change_salary(null, "CentComm", "CentComm", "Admin", force_rate = -100) //Objective failed

/datum/announcement/centcomm/gang/cops_5
	subtitle = "Отдел по Борьбе с Организованной Преступностью"
	announcer = "Дежурный офицер"
	name = "Gang: Wanted Level 5"
/datum/announcement/centcomm/gang/cops_5/New()
	message = "Из-за безумного количества жертв среди гражданского персонажа на борту [station_name_ru()]." + \
	" Все главы, а также отдел СБ будет арестован." + \
	" Мы направили бойцов Вооружённых Сил НаноТрейзен, чтобы присечь любую деятельность банд на станции." + \
	" Наша блюспейс артиллерия направлена на станцию и спасательный шаттл.\n\nЗря вы убили столько людей."
/datum/announcement/centcomm/gang/cops_5/play()
	..()
	var/list/ranks = command_positions + security_positions
	for(var/datum/job/J in SSjob.occupations)
		if(J.title in ranks)
			J.salary_ratio = 0
		else
			salary_ratio = 0.3

	var/list/crew = my_subordinate_staff("Admin")
	for(var/person in crew)
		var/datum/money_account/account = person["acc_datum"]
		if(person["rank"] in ranks)
			account.change_salary(null, "CentComm", "CentComm", "Admin", force_rate = -110) //Yea, you need to pay now
		else
			account.change_salary(null, "CentComm", "CentComm", "Admin", force_rate = -70) //It's a mess

/datum/announcement/centcomm/gang/change_wanted_level
	title = "Система Обнаружения Кораблей Станции"
	subtitle = null
	name = "Gang: Change Wanted Level"
/datum/announcement/centcomm/gang/change_wanted_level/play(_message)
	message = _message
	..()

/* Xenomorph */
/datum/announcement/centcomm/xeno
	name = "Xeno threat"
	subtitle = "Тревога! Ксеноугроза!"

/datum/announcement/centcomm/xeno/first_help/New()
	message = "Мы получили информацию о наличии улья ксеноморфов на борту [station_name_ru()]. " + \
			"Это враждебные и крайне опасные существа! Мы не можем допустить проникновение ксеноморфов на другие наши объекты. " + \
			"Активирован протокол изоляции станции. Он будет действовать пока вы не уничтожите всех взрослых особей ксеноморфов. " + \
			"Мы выслали вам шаттл снабжения с припасами и вооружением. " + \
			"По мнению наших ученых, этого должно быть достаточно для ликвидации угрозы."

/datum/announcement/centcomm/xeno/first_help/fail/New()
	message = "Мы получили информацию о наличии улья ксеноморфов на борту [station_name_ru()]. " + \
			"Это враждебные и крайне опасные существа! Мы не можем допустить проникновение ксеноморфов на другие наши объекты. " + \
			"Активирован протокол изоляции станции. Он будет действовать пока вы не уничтожите всех взрослых особей ксеноморфов. " + \
			"Мы добавили припасы и вооружение в список поставок. " + \
			"По мнению наших ученых, этого должно быть достаточно для ликвидации угрозы. " + \
			"Освободите ваш шаттл снабжения и заберите груз."

/datum/announcement/centcomm/xeno/second_help/New()
	message = "Похоже, нашей первой помощи оказалось недостаточно. Ксеноморфы продолжают увеличивать численность. " + \
			"Мы выслали вам шаттл снабжения с лучшим вооружением, какое смогли достать. " + \
			"Рассматривается вопрос об отправке Отряда Быстрого Реагирования."

/datum/announcement/centcomm/xeno/second_help/fail/New()
	message = "Похоже, нашей первой помощи оказалось недостаточно. Ксеноморфы продолжают увеличивать численность. " + \
			"Мы добавили лучшее вооружение, какое смогли достать, в список поставок. Освободите ваш шаттл снабжения и заберите груз. " + \
			"Рассматривается вопрос об отправке Отряда Быстрого Реагирования."

/datum/announcement/centcomm/xeno/crew_win
	name = "Xeno threat"
	subtitle = "Ксеноугроза устранена!"

/datum/announcement/centcomm/xeno/crew_win/New()
	message = "До нас дошла информация о том, что на борту [station_name_ru()] больше не осталось взрослых особей ксеноморфов. " + \
			"Похоже вы справились! Центральное командование выражает благодарность экипажу [station_name_ru()]. " + \
			"Всему гражданскому персоналу необходимо сдать полученное вооружение сотрудникам безопасности. Протокол изоляции экипажа станции деактивирован."

