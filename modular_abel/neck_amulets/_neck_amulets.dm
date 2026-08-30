/obj/item/clothing/neck/carved
	abstract_type = /obj/item/clothing/neck/carved
	name = "carved amulet"
	desc = "You shouldn't be seeing this."
	icon = 'modular_abel/neck_amulets/icons/amulets_world.dmi'
	mob_overlay_icon = 'modular_abel/neck_amulets/icons/amulets_onmob.dmi'
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_WRISTS
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	resistance_flags = FIRE_PROOF
	grid_width = 32
	grid_height = 32
	sellprice = 90

/// Worn on the wrist these use the wrist sheet instead of the neck one.
/obj/item/clothing/neck/carved/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_WRISTS)
		mob_overlay_icon = 'modular_abel/neck_amulets/icons/amulets_wrists.dmi'
	else
		mob_overlay_icon = 'modular_abel/neck_amulets/icons/amulets_onmob.dmi'

/obj/item/clothing/neck/carved/silverjade
	name = "silver joapstone amulet"
	desc = "A silver amulet encrusted with a polished piece of joapstone, donnable both on neck and wrist."
	icon_state = "silver_jade"

/obj/item/clothing/neck/carved/silverturq
	name = "silver ceruleabaster amulet"
	desc = "A silver amulet encrusted with a polished piece of ceruleabaster, donnable both on neck and wrist."
	icon_state = "silver_turq"

/obj/item/clothing/neck/carved/silveronyxa
	name = "silver onyxa amulet"
	desc = "A silver amulet encrusted with a polished piece of onyxa, donnable both on neck and wrist."
	icon_state = "silver_onyxa"

/obj/item/clothing/neck/carved/silvercoral
	name = "silver heartstone amulet"
	desc = "A silver amulet encrusted with a polished piece of heartstone, donnable both on neck and wrist."
	icon_state = "silver_coral"

/obj/item/clothing/neck/carved/silveramber
	name = "silver amber amulet"
	desc = "A silver amulet encrusted with a polished piece of amber, donnable both on neck and wrist."
	icon_state = "silver_amber"

/obj/item/clothing/neck/carved/silveropal
	name = "silver opal amulet"
	desc = "A silver amulet encrusted with a polished piece of opal, donnable both on neck and wrist."
	icon_state = "silver_opal"

/obj/item/clothing/neck/carved/silverrose
	name = "silver rosestone amulet"
	desc = "A silver amulet encrusted with a polished piece of rosestone, donnable both on neck and wrist."
	icon_state = "silver_rose"

/obj/item/clothing/neck/carved/silvershell
	name = "silver shell amulet"
	desc = "A silver amulet encrusted with a polished piece of shell, donnable both on neck and wrist."
	icon_state = "silver_shell"

/obj/item/clothing/neck/carved/gold
	abstract_type = /obj/item/clothing/neck/carved/gold
	sellprice = 140

/obj/item/clothing/neck/carved/gold/amber
	name = "golden amber amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of amber, donnable both on neck and wrist."
	icon_state = "gold_amber"

/obj/item/clothing/neck/carved/gold/coral
	name = "golden heartstone amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of heartstone, donnable both on neck and wrist."
	icon_state = "gold_coral"

/obj/item/clothing/neck/carved/gold/onyxa
	name = "golden onyxa amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of onyxa, donnable both on neck and wrist."
	icon_state = "gold_onyxa"

/obj/item/clothing/neck/carved/gold/opal
	name = "golden opal amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of opal, donnable both on neck and wrist."
	icon_state = "gold_opal"

/obj/item/clothing/neck/carved/gold/rose
	name = "golden rosestone amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of rosestone, donnable both on neck and wrist."
	icon_state = "gold_rose"

/obj/item/clothing/neck/carved/gold/shell
	name = "golden shell amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of shell, donnable both on neck and wrist."
	icon_state = "gold_shell"

/obj/item/clothing/neck/carved/gold/turq
	name = "golden ceruleabaster amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of ceruleabaster, donnable both on neck and wrist."
	icon_state = "gold_turq"

/obj/item/clothing/neck/carved/gold/jade
	name = "golden joapstone amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of joapstone, donnable both on neck and wrist."
	icon_state = "gold_jade"

/obj/item/clothing/neck/furscarf
	name = "fur scarf"
	desc = "A thick band of fur worn about the neck against the cold."
	icon = 'modular_abel/neck_amulets/icons/amulets_world.dmi'
	mob_overlay_icon = 'modular_abel/neck_amulets/icons/amulets_onmob.dmi'
	icon_state = "furscarf"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	salvage_result = /obj/item/natural/fur
	salvage_amount = 1
	sellprice = 25

/datum/anvil_recipe/valuables/silver/carved_amulet
	abstract_type = /datum/anvil_recipe/valuables/silver/carved_amulet
	output_amount = 1

/datum/anvil_recipe/valuables/silver/carved_amulet/jade
	name = "Silver Joapstone Amulet (+1 Cut Joapstone)"
	additional_items = list(/obj/item/carvedgem/jade/cutgem)
	created_item = /obj/item/clothing/neck/carved/silverjade

/datum/anvil_recipe/valuables/silver/carved_amulet/turq
	name = "Silver Ceruleabaster Amulet (+1 Cut Ceruleabaster)"
	additional_items = list(/obj/item/carvedgem/turq/cutgem)
	created_item = /obj/item/clothing/neck/carved/silverturq

/datum/anvil_recipe/valuables/silver/carved_amulet/onyxa
	name = "Silver Onyxa Amulet (+1 Cut Onyxa)"
	additional_items = list(/obj/item/carvedgem/onyxa/cutgem)
	created_item = /obj/item/clothing/neck/carved/silveronyxa

/datum/anvil_recipe/valuables/silver/carved_amulet/coral
	name = "Silver Heartstone Amulet (+1 Cut Heartstone)"
	additional_items = list(/obj/item/carvedgem/coral/cutgem)
	created_item = /obj/item/clothing/neck/carved/silvercoral

/datum/anvil_recipe/valuables/silver/carved_amulet/amber
	name = "Silver Amber Amulet (+1 Cut Amber)"
	additional_items = list(/obj/item/carvedgem/amber/cutgem)
	created_item = /obj/item/clothing/neck/carved/silveramber

/datum/anvil_recipe/valuables/silver/carved_amulet/opal
	name = "Silver Opal Amulet (+1 Cut Opal)"
	additional_items = list(/obj/item/carvedgem/opal/cutgem)
	created_item = /obj/item/clothing/neck/carved/silveropal

/datum/anvil_recipe/valuables/silver/carved_amulet/rose
	name = "Silver Rosestone Amulet (+1 Cut Rosestone)"
	additional_items = list(/obj/item/carvedgem/rose/cutgem)
	created_item = /obj/item/clothing/neck/carved/silverrose

/datum/anvil_recipe/valuables/silver/carved_amulet/shell
	name = "Silver Shell Amulet (+1 Cut Shell)"
	additional_items = list(/obj/item/carvedgem/shell/cutgem)
	created_item = /obj/item/clothing/neck/carved/silvershell

/datum/anvil_recipe/valuables/gold/carved_amulet
	abstract_type = /datum/anvil_recipe/valuables/gold/carved_amulet
	output_amount = 1

/datum/anvil_recipe/valuables/gold/carved_amulet/jade
	name = "Golden Joapstone Amulet (+1 Cut Joapstone)"
	additional_items = list(/obj/item/carvedgem/jade/cutgem)
	created_item = /obj/item/clothing/neck/carved/gold/jade

/datum/anvil_recipe/valuables/gold/carved_amulet/turq
	name = "Golden Ceruleabaster Amulet (+1 Cut Ceruleabaster)"
	additional_items = list(/obj/item/carvedgem/turq/cutgem)
	created_item = /obj/item/clothing/neck/carved/gold/turq

/datum/anvil_recipe/valuables/gold/carved_amulet/onyxa
	name = "Golden Onyxa Amulet (+1 Cut Onyxa)"
	additional_items = list(/obj/item/carvedgem/onyxa/cutgem)
	created_item = /obj/item/clothing/neck/carved/gold/onyxa

/datum/anvil_recipe/valuables/gold/carved_amulet/coral
	name = "Golden Heartstone Amulet (+1 Cut Heartstone)"
	additional_items = list(/obj/item/carvedgem/coral/cutgem)
	created_item = /obj/item/clothing/neck/carved/gold/coral

/datum/anvil_recipe/valuables/gold/carved_amulet/amber
	name = "Golden Amber Amulet (+1 Cut Amber)"
	additional_items = list(/obj/item/carvedgem/amber/cutgem)
	created_item = /obj/item/clothing/neck/carved/gold/amber

/datum/anvil_recipe/valuables/gold/carved_amulet/opal
	name = "Golden Opal Amulet (+1 Cut Opal)"
	additional_items = list(/obj/item/carvedgem/opal/cutgem)
	created_item = /obj/item/clothing/neck/carved/gold/opal

/datum/anvil_recipe/valuables/gold/carved_amulet/rose
	name = "Golden Rosestone Amulet (+1 Cut Rosestone)"
	additional_items = list(/obj/item/carvedgem/rose/cutgem)
	created_item = /obj/item/clothing/neck/carved/gold/rose

/datum/anvil_recipe/valuables/gold/carved_amulet/shell
	name = "Golden Shell Amulet (+1 Cut Shell)"
	additional_items = list(/obj/item/carvedgem/shell/cutgem)
	created_item = /obj/item/clothing/neck/carved/gold/shell

/datum/repeatable_crafting_recipe/sewing/furscarf
	name = "fur scarf"
	output = /obj/item/clothing/neck/furscarf
	requirements = list(
		/obj/item/natural/fur = 2,
	)
	tool_usage = list(
		/obj/item/needle = list("starts to stitch the furs together", "start to stitch the furs together")
	)
	attacked_atom = /obj/item/natural/fur
	starting_atom = /obj/item/needle
	craftdiff = 1
	subtypes_allowed = TRUE

/datum/loadout_item/azure_amulet
	abstract_type = /datum/loadout_item/azure_amulet
	ui_category = LOADOUT_PANEL_CATEGORY_AZURE

/datum/loadout_item/azure_amulet/silver_joapstone
	name = "Silver Joapstone Amulet"
	item_path = /obj/item/clothing/neck/carved/silverjade

/datum/loadout_item/azure_amulet/silver_ceruleabaster
	name = "Silver Ceruleabaster Amulet"
	item_path = /obj/item/clothing/neck/carved/silverturq

/datum/loadout_item/azure_amulet/silver_onyxa
	name = "Silver Onyxa Amulet"
	item_path = /obj/item/clothing/neck/carved/silveronyxa

/datum/loadout_item/azure_amulet/silver_heartstone
	name = "Silver Heartstone Amulet"
	item_path = /obj/item/clothing/neck/carved/silvercoral

/datum/loadout_item/azure_amulet/silver_amber
	name = "Silver Amber Amulet"
	item_path = /obj/item/clothing/neck/carved/silveramber

/datum/loadout_item/azure_amulet/silver_opal
	name = "Silver Opal Amulet"
	item_path = /obj/item/clothing/neck/carved/silveropal

/datum/loadout_item/azure_amulet/silver_rosestone
	name = "Silver Rosestone Amulet"
	item_path = /obj/item/clothing/neck/carved/silverrose

/datum/loadout_item/azure_amulet/silver_shell
	name = "Silver Shell Amulet"
	item_path = /obj/item/clothing/neck/carved/silvershell

/datum/loadout_item/azure_amulet/gold_amber
	name = "Golden Amber Amulet"
	item_path = /obj/item/clothing/neck/carved/gold/amber

/datum/loadout_item/azure_amulet/gold_heartstone
	name = "Golden Heartstone Amulet"
	item_path = /obj/item/clothing/neck/carved/gold/coral

/datum/loadout_item/azure_amulet/gold_onyxa
	name = "Golden Onyxa Amulet"
	item_path = /obj/item/clothing/neck/carved/gold/onyxa

/datum/loadout_item/azure_amulet/gold_opal
	name = "Golden Opal Amulet"
	item_path = /obj/item/clothing/neck/carved/gold/opal

/datum/loadout_item/azure_amulet/gold_rosestone
	name = "Golden Rosestone Amulet"
	item_path = /obj/item/clothing/neck/carved/gold/rose

/datum/loadout_item/azure_amulet/gold_shell
	name = "Golden Shell Amulet"
	item_path = /obj/item/clothing/neck/carved/gold/shell

/datum/loadout_item/azure_amulet/gold_ceruleabaster
	name = "Golden Ceruleabaster Amulet"
	item_path = /obj/item/clothing/neck/carved/gold/turq

/datum/loadout_item/azure_amulet/gold_joapstone
	name = "Golden Joapstone Amulet"
	item_path = /obj/item/clothing/neck/carved/gold/jade

/datum/loadout_item/azure_amulet/furscarf
	name = "Fur Scarf"
	item_path = /obj/item/clothing/neck/furscarf
