var/global/list/online_shop_lots = list()
var/global/list/online_shop_lots_latest[3]
var/global/online_shop_number = 0
var/global/list/shop_categories = list("Еда" = 0, "Одежда" = 0, "Устройства" = 0, "Инструменты" = 0, "Ресурсы" = 0, "Наборы" = 0, "Разное" = 0)

var/global/list/orders_and_offers = list()
var/global/orders_and_offers_number = 0

/datum/shop_lot
	var/name = "Лот"
	var/description = "Описание лота"
	var/price = 0
	var/number = 1
	var/category = "Разное"
	var/sold = FALSE
	var/delivered = FALSE
	var/account = 111111
	var/item_icon = ""


/datum/shop_lot/New(name, description, price, category, account, icon)
	global.online_shop_number++
	global.online_shop_lots["[global.online_shop_number]"] = src
	src.name = name
	src.description = description
	src.price = price
	src.category = category
	src.number = "[global.online_shop_number]"
	src.account = account
	src.item_icon = icon

	global.online_shop_lots_latest.Swap(2, 3)
	global.online_shop_lots_latest.Swap(1, 2)
	global.online_shop_lots_latest[1] = src

/datum/shop_lot/Destroy()
	global.online_shop_lots -= "[number]"
	for(var/i=1, i<=3, i++)
		if(global.online_shop_lots_latest[i] == src)
			global.online_shop_lots_latest[i] = null
			break
	return ..()

/datum/shop_lot/proc/to_list(account = "Unknown", postpayment = 0)
	return list("name" = src.name, "description" = src.description, "price" = src.price, "number" = src.number, "account" = account, "delivered" = src.delivered, "postpayment" = postpayment, "icon" = src.item_icon)
