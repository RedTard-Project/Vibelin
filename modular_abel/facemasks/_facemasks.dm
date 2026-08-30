/obj/item/clothing/face/facemask/padded
	name = "padded mask"
	desc = "A padded cloth mask with a visor, it will prevent bad smells more than damage."
	icon = 'modular_abel/facemasks/icons/masks_world.dmi'
	mob_overlay_icon = 'modular_abel/facemasks/icons/masks_onmob.dmi'
	icon_state = "gambesonmask"
	max_integrity = 50
	armor_type = /datum/armor/mask/padded
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	prevent_crits = list(BCLASS_BITE, BCLASS_TWIST)
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	sellprice = 8

/obj/item/clothing/face/facemask/leather
	name = "padded leather mask"
	desc = "A padded leather mask with a visor, it will prevent bad smells and some damage."
	icon = 'modular_abel/facemasks/icons/masks_world.dmi'
	mob_overlay_icon = 'modular_abel/facemasks/icons/masks_onmob.dmi'
	icon_state = "leathermask"
	max_integrity = 70
	armor_type = /datum/armor/mask/padded/good
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	prevent_crits = list(BCLASS_BITE, BCLASS_TWIST, BCLASS_CUT)
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	sellprice = 14

/obj/item/clothing/face/facemask/maille
	name = "iron chainmaille mask"
	desc = "A padded chainmaille mask that will protect against some damage and can be rolled down to the neck."
	icon = 'modular_abel/facemasks/icons/masks_world.dmi'
	mob_overlay_icon = 'modular_abel/facemasks/icons/masks_onmob.dmi'
	icon_state = "imaillemask"
	max_integrity = 110
	armor_type = /datum/armor/mask/metal/iron
	sellprice = 24

/obj/item/clothing/face/facemask/maille/fluted
	name = "iron fluted chainmaille mask"
	desc = "A padded chainmaille mask that will protect against some damage and can be rolled down to the neck. This one is fluted."
	icon_state = "iflutedmask"
	sellprice = 28

/obj/item/clothing/face/facemask/steel/maille
	name = "steel chainmaille mask"
	desc = "A padded chainmaille mask that will protect against some damage and can be rolled down to the neck."
	icon = 'modular_abel/facemasks/icons/masks_world.dmi'
	mob_overlay_icon = 'modular_abel/facemasks/icons/masks_onmob.dmi'
	icon_state = "smaillemask"
	max_integrity = 140
	armor_type = /datum/armor/mask/metal/steel
	sellprice = 40

/obj/item/clothing/face/facemask/steel/maille/fluted
	name = "steel fluted chainmaille mask"
	desc = "A padded chainmaille mask that will protect against some damage and can be rolled down to the neck. This one is fluted."
	icon_state = "sflutedmask"
	sellprice = 46

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
