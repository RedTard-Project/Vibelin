
/obj/item/dildo
	erp_item_tags = list("dildo")

/obj/item/clothing
	var/list/propagade_kink = null
	var/is_bra = FALSE

/obj/item/clothing/armor/corset/pony
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "pony corset"
	desc = "A tight leather corset with straps and rings. It forces posture, breath, and obedience."
	icon_state = "hcorset"
	item_state = "hcorset"
	armor_class = AC_LIGHT
	body_parts_covered = CHEST
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	icon = 'modular_abel/erp/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_abel/erp/icons/clothing/onmob/erp_cloth.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/obj/item/clothing/shoes/boots/pony
	name = "pony boots"
	color = "#3f2f22"
	desc = "Heavy leather boots built for a clipped, controlled gait."
	gender = PLURAL
	icon_state = "hlegs"
	item_state = "hlegs"
	sewrepair = TRUE
	armor_type = /datum/armor/leather
	salvage_amount = 2
	salvage_result = /obj/item/natural/hide/cured
	icon = 'modular_abel/erp/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_abel/erp/icons/clothing/onmob/erp_cloth.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/obj/item/clothing/gloves/leather/ponyhooves
	name = "pony hooves"
	desc = "Leather gloves shaped into hooves, awkward for work and perfect for play."
	icon_state = "harms"
	item_state = "harms"
	armor_type = /datum/armor/leather
	max_integrity = ARMOR_INT_SIDE_LEATHER
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	unarmed_bonus = 1.0
	color = "#4b3a2c"
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	icon = 'modular_abel/erp/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_abel/erp/icons/clothing/onmob/erp_cloth.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/obj/item/clothing/head/helmet/pony_harness
	name = "pony harness gag"
	desc = "A leather muzzle-harness with a gag piece. Talking becomes a suggestion."
	icon_state = "hbit"
	item_state = "hbit"
	sewrepair = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	smeltresult = null
	icon = 'modular_abel/erp/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_abel/erp/icons/clothing/onmob/erp_cloth.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/obj/item/clothing/head/helmet/pony_harness/Initialize(mapload)
	. = ..()
	flags_inv |= HIDEMASK

/obj/item/clothing/face/pony_blindfold
	name = "pony blindfold"
	desc = "A thick blindfold that leaves only trust (or panic)."
	icon_state = "hblinders"
	item_state = "hblinders"
	body_parts_covered = EYES
	sewrepair = TRUE
	tint = 2
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	icon = 'modular_abel/erp/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_abel/erp/icons/clothing/onmob/erp_cloth.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

// The old /datum/crafting_recipe system these were written against no longer exists - clothing recipes now
// live under /datum/repeatable_crafting_recipe/leather (see code/modules/crafting/quality_of_crafting/leatherworking.dm),
// which already covers "needle + cured hide" sewing. Reimplemented on that base with the same reqs/outputs.
/datum/repeatable_crafting_recipe/leather/pony_corset
	name = "pony corset"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/clothing/armor/corset/pony

/datum/repeatable_crafting_recipe/leather/pony_boots
	name = "pony boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/shoes/boots/pony

/datum/repeatable_crafting_recipe/leather/pony_hooves
	name = "pony hooves"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/gloves/leather/ponyhooves

/datum/repeatable_crafting_recipe/leather/pony_harness
	name = "pony harness gag"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/head/helmet/pony_harness

/datum/repeatable_crafting_recipe/leather/pony_blindfold
	name = "pony blindfold"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/clothing/face/pony_blindfold
