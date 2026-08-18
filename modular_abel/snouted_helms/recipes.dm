// Anvil recipes for the snouted helmet variants.
//
// Required by craftable_clothes, and consistent with the helmets they vary: a snouted helm
// is the same forging job with the face plate drawn out, so each costs its parent's material
// plus one extra ingot for the muzzle, one craftdiff step above the plain version.

/datum/anvil_recipe/armor/iron/bascinet_snouted
	name = "Bascinet, Snouted, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/bascinet/snouted/iron
	craftdiff = 3

/datum/anvil_recipe/armor/steel/bascinet_snouted
	name = "Bascinet, Snouted (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/bascinet/snouted
	craftdiff = 3

/datum/anvil_recipe/armor/iron/sallet_snouted
	name = "Visored Sallet, Snouted, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/sallet/snouted/iron
	craftdiff = 3

/datum/anvil_recipe/armor/steel/sallet_snouted
	name = "Visored Sallet, Snouted (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/sallet/snouted
	craftdiff = 3

/datum/anvil_recipe/armor/iron/armet_snouted
	name = "Armet, Snouted, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/visored/snouted/iron
	craftdiff = 4

/datum/anvil_recipe/armor/steel/armet_snouted
	name = "Armet, Snouted (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/visored/snouted
	craftdiff = 4

/datum/anvil_recipe/armor/steel/nochelm_snouted
	name = "Nocturnal Helm, Snouted (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/nochelm/snouted
	craftdiff = 4

// The psydonic volfplate follows its own family's pattern rather than the snouted one:
// /datum/anvil_recipe/armor/volfplate_puritan is steel + a second steel at craftdiff 4.
/datum/anvil_recipe/armor/volfplate_psydonic
	name = "psydonic volfplate helm"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/volfplate/psydonic
	craftdiff = 4
