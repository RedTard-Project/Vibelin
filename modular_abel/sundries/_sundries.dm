/obj/item/clothing/cloak/tabard/psydon_traditional
	name = "traditional tabard"
	desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a sleeveless garment \
	that harks back to the ancient yils of the Holy Inquisition."
	icon = 'modular_abel/sundries/icons/sundries_world.dmi'
	mob_overlay_icon = 'modular_abel/sundries/icons/sundries_onmob.dmi'
	icon_state = "whitepsydontabard"
	item_state = "whitepsydontabard"
	detail_tag = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	sellprice = 30

/obj/item/clothing/face/cigarette/rollie/apple
	name = "apple zig"
	desc = "Dried leaf carefully wrapped in fine paper. It has a particularly smooth taste with a cooling effect."
	list_reagents = list(/datum/reagent/drug/nicotine = 45)

/obj/item/clothing/face/cigarette/rollie/menthaapple
	name = "mentha-apple zig"
	desc = "Dried leaf carefully wrapped in fine paper, sweetened and sharpened at once. It has a particularly smooth taste with a cooling effect."
	list_reagents = list(/datum/reagent/drug/nicotine = 45)

/datum/repeatable_crafting_recipe/sewing/psydon_traditional_tabard
	name = "traditional tabard"
	output = /obj/item/clothing/cloak/tabard/psydon_traditional
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sigdry/apple
	name = "apple zig"
	output = /obj/item/clothing/face/cigarette/rollie/apple
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/dry_westleach = 2,
		/obj/item/reagent_containers/food/snacks/apple_dried = 1,
	)
	crafting_message = "starts rolling an apple zig"
	craftdiff = 1

/datum/repeatable_crafting_recipe/sigdry/menthaapple
	name = "mentha-apple zig"
	output = /obj/item/clothing/face/cigarette/rollie/menthaapple
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/dry_westleach = 2,
		/obj/item/reagent_containers/food/snacks/apple_dried = 1,
	)
	crafting_message = "starts rolling a mentha-apple zig"
	craftdiff = 2

/datum/loadout_item/azure_traditional_tabard
	name = "Traditional Tabard"
	item_path = /obj/item/clothing/cloak/tabard/psydon_traditional
	ui_category = LOADOUT_PANEL_CATEGORY_AZURE
