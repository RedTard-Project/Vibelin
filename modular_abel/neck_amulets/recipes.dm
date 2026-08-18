// Anvil recipes for the gold and silver gem amulets.
//
// Azure ships these purely as loot. Vanderlin makes every other amulet craftable - the plain
// stone ones on the carving bench (code/modules/crafting/quality_of_crafting/carving.dm) and
// the bare metal ones at the anvil (code/modules/crafting/anvil_recipes/valuables.dm) - and
// its craftable_clothes unit test enforces that every garment has a recipe, so these get one
// too rather than an exemption.
//
// The setting is the anvil half of that pair: a precious ingot plus the matching cut gem,
// following the "+1 X" naming and additional_items convention already used for armour.
// craftdiff mirrors /datum/anvil_recipe/valuables/{silver,gold}.

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

// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// The fur scarf is sewn, not forged.
// ---------------------------------------------------------------------------

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
