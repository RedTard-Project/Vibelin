/obj/item/clothing/shirt/dress/blue
	name = "blue dress"
	desc = "A modest blue dress of the kind worn by townswomen on days that matter."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "bluedress"
	sellprice = 25

/obj/item/clothing/shirt/dress/green
	name = "green dress"
	desc = "A modest green dress of the kind worn by townswomen on days that matter."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "greendress"
	sellprice = 25

/obj/item/clothing/shirt/dress/tavern
	name = "tavern dress"
	desc = "A hard-wearing dress cut for carrying tankards through a crowded room."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "taverndress"
	sellprice = 20

/obj/item/clothing/shirt/robe/leopard
	name = "leopard bathrobe"
	desc = "A plush bathrobe patterned after a leopard's pelt. Whether any leopard was involved is doubtful."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	sleeved = 'modular_abel/garments/icons/garments_sleeves.dmi'
	icon_state = "lpbathrobe"
	sellprice = 30

/obj/item/clothing/shirt/robe/leopard/alt
	name = "open leopard bathrobe"
	desc = "A plush bathrobe patterned after a leopard's pelt, worn hanging open."
	icon_state = "lpbathrobe_open"

/obj/item/clothing/shirt/robe/lunar
	name = "lunar robe"
	desc = "A dark robe scattered with the phases of the moon, favoured by those who keep night hours."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	sleeved = 'modular_abel/garments/icons/garments_sleeves.dmi'
	icon_state = "lunarrobe"
	sellprice = 40

/obj/item/clothing/shirt/robe/magician
	name = "magician's robe"
	desc = "A heavy robe cut in the manner favoured by practitioners of the arcyne."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	sleeved = 'modular_abel/garments/icons/garments_sleeves.dmi'
	icon_state = "magerobe"
	sellprice = 40

/obj/item/clothing/shirt/tunic/winter
	name = "winter coat"
	desc = "A thick, lined coat built to keep the cold on the outside of it."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	sleeved = 'modular_abel/garments/icons/garments_sleeves.dmi'
	icon_state = "wintercoat"
	sellprice = 35

/obj/item/clothing/cloak/tabard/toga/dress
	name = "toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "toga_f"
	sellprice = 20

/obj/item/clothing/pants/skirt/formal
	name = "formal skirt"
	desc = "A long, pleated skirt of the sort worn to court and to funerals."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "formalskirt"
	sellprice = 22

/datum/repeatable_crafting_recipe/sewing/taverndress
	name = "tavern dress"
	output = /obj/item/clothing/shirt/dress/tavern
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/datum/repeatable_crafting_recipe/sewing/bluedress
	name = "blue dress"
	output = /obj/item/clothing/shirt/dress/blue
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sewing/greendress
	name = "green dress"
	output = /obj/item/clothing/shirt/dress/green
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sewing/formalskirt
	name = "formal skirt"
	output = /obj/item/clothing/pants/skirt/formal
	requirements = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sewing/toga_dress
	name = "toga"
	output = /obj/item/clothing/cloak/tabard/toga/dress
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/datum/repeatable_crafting_recipe/sewing/leopardrobe
	name = "leopard bathrobe"
	output = /obj/item/clothing/shirt/robe/leopard
	requirements = list(/obj/item/natural/cloth = 2, /obj/item/natural/fur = 2)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sewing/wintercoat
	name = "winter coat"
	output = /obj/item/clothing/shirt/tunic/winter
	requirements = list(/obj/item/natural/cloth = 3, /obj/item/natural/fur = 1)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/lunarrobe
	name = "lunar robe"
	output = /obj/item/clothing/shirt/robe/lunar
	requirements = list(/obj/item/natural/cloth = 4)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/magerobe
	name = "magician's robe"
	output = /obj/item/clothing/shirt/robe/magician
	requirements = list(/obj/item/natural/cloth = 4)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/leopardrobe_open
	name = "open leopard bathrobe"
	output = /obj/item/clothing/shirt/robe/leopard/alt
	requirements = list(/obj/item/natural/cloth = 2, /obj/item/natural/fur = 2)
	craftdiff = 2

/datum/loadout_item/azure_garment
	abstract_type = /datum/loadout_item/azure_garment
	ui_category = LOADOUT_PANEL_CATEGORY_AZURE

/datum/loadout_item/azure_garment/blue_dress
	name = "Blue Dress"
	item_path = /obj/item/clothing/shirt/dress/blue

/datum/loadout_item/azure_garment/green_dress
	name = "Green Dress"
	item_path = /obj/item/clothing/shirt/dress/green

/datum/loadout_item/azure_garment/tavern_dress
	name = "Tavern Dress"
	item_path = /obj/item/clothing/shirt/dress/tavern

/datum/loadout_item/azure_garment/leopard_robe
	name = "Leopard Bathrobe"
	item_path = /obj/item/clothing/shirt/robe/leopard

/datum/loadout_item/azure_garment/leopard_robe_open
	name = "Open Leopard Bathrobe"
	item_path = /obj/item/clothing/shirt/robe/leopard/alt

/datum/loadout_item/azure_garment/lunar_robe
	name = "Lunar Robe"
	item_path = /obj/item/clothing/shirt/robe/lunar

/datum/loadout_item/azure_garment/magician_robe
	name = "Magician's Robe"
	item_path = /obj/item/clothing/shirt/robe/magician

/datum/loadout_item/azure_garment/winter_coat
	name = "Winter Coat"
	item_path = /obj/item/clothing/shirt/tunic/winter

/datum/loadout_item/azure_garment/toga
	name = "Draped Toga"
	item_path = /obj/item/clothing/cloak/tabard/toga/dress

/datum/loadout_item/azure_garment/formal_skirt
	name = "Formal Skirt"
	item_path = /obj/item/clothing/pants/skirt/formal
