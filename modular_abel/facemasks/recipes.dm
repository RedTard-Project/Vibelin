/datum/repeatable_crafting_recipe/sewing/padded_mask
	name = "padded mask"
	output = /obj/item/clothing/face/facemask/padded
	requirements = list(
		/obj/item/natural/cloth = 2,
	)
	craftdiff = 1

/datum/repeatable_crafting_recipe/sewing/leather_mask
	name = "padded leather mask"
	output = /obj/item/clothing/face/facemask/leather
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/hide/cured = 1,
	)
	craftdiff = 2

/datum/anvil_recipe/armor/iron/maille_mask
	name = "Chainmaille Mask, Iron (+1 Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/face/facemask/maille
	craftdiff = 2

/datum/anvil_recipe/armor/iron/maille_mask_fluted
	name = "Fluted Chainmaille Mask, Iron (+1 Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/face/facemask/maille/fluted
	craftdiff = 3

/datum/anvil_recipe/armor/steel/maille_mask
	name = "Chainmaille Mask, Steel (+1 Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/face/facemask/steel/maille
	craftdiff = 3

/datum/anvil_recipe/armor/steel/maille_mask_fluted
	name = "Fluted Chainmaille Mask, Steel (+1 Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/face/facemask/steel/maille/fluted
	craftdiff = 4
