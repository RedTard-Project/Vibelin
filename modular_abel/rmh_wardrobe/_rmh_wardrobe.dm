/obj/item/clothing/neck/choker
	name = "choker"
	desc = "A narrow band worn tight at the throat. It is not jewellery so much as a statement about jewellery."
	icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_onmob.dmi'
	icon_state = "choker"
	sellprice = 30

/obj/item/clothing/neck/choker/emerald
	name = "emerald choker"
	desc = "A throat band set with a single green stone, which is doing most of the talking."
	icon_state = "chokere"
	sellprice = 70

/obj/item/clothing/head/nun_hat
	name = "nun's coif"
	desc = "A starched white coif and wimple. It covers the hair completely, which is the entire idea."
	icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_onmob.dmi'
	icon_state = "nun_hat"
	sellprice = 35

/obj/item/clothing/shirt/undershirt/nun_robe
	name = "nun's habit"
	desc = "A plain dark habit with a pale collar, cut long. Devotion is expected to show in the hem."
	icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_onmob.dmi'
	sleeved = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_sleeves.dmi'
	icon_state = "sex_nun_robe"
	sellprice = 45

/obj/item/clothing/shirt/maid_dress
	name = "maid dress"
	desc = "A black dress with a white apron and collar, pressed by someone who was not the one wearing it."
	icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_onmob.dmi'
	sleeved = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_sleeves.dmi'
	icon_state = "maid_dress"
	sellprice = 45

/obj/item/clothing/gloves/leather/thaumgloves
	name = "alchemist's gloves"
	desc = "Long leather gloves stained past saving at the fingertips, worn by people who measure things carefully."
	icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/rmh_wardrobe/icons/rmh_wardrobe_onmob.dmi'
	icon_state = "thaumgloves"
	sellprice = 40

/datum/loadout_item/rmh_wardrobe
	abstract_type = /datum/loadout_item/rmh_wardrobe
	ui_category = LOADOUT_PANEL_CATEGORY_RMH

/datum/loadout_item/rmh_wardrobe/choker
	name = "Choker"
	item_path = /obj/item/clothing/neck/choker
	triumph_cost_permanent = 50

/datum/loadout_item/rmh_wardrobe/choker_emerald
	name = "Emerald Choker"
	item_path = /obj/item/clothing/neck/choker/emerald
	triumph_cost_permanent = 125

/datum/loadout_item/rmh_wardrobe/nun_hat
	name = "Nun's Coif"
	item_path = /obj/item/clothing/head/nun_hat
	triumph_cost_permanent = 60

/datum/loadout_item/rmh_wardrobe/nun_robe
	name = "Nun's Habit"
	item_path = /obj/item/clothing/shirt/undershirt/nun_robe
	triumph_cost_permanent = 75

/datum/loadout_item/rmh_wardrobe/maid_dress
	name = "Maid Dress"
	item_path = /obj/item/clothing/shirt/maid_dress
	triumph_cost_permanent = 75

/datum/loadout_item/rmh_wardrobe/thaumgloves
	name = "Alchemist's Gloves"
	item_path = /obj/item/clothing/gloves/leather/thaumgloves
	triumph_cost_permanent = 75
