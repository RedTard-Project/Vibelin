// Woodcarving recipes.
// Ported from Azure-Peak code/modules/roguetown/roguecrafting/crafting/woodcarving.dm.
//
// Azure declares these as /datum/crafting_recipe/roguetown with reqs/tools/result.
// Vanderlin uses /datum/repeatable_crafting_recipe: you hold the tool, click the material,
// and pick the recipe - so they are re-expressed with starting_atom/attacked_atom/output,
// following the gemstone carving in code/modules/crafting/quality_of_crafting/carving.dm.
//
// Difficulty mapping. Azure's craftdiff carries a SKILL_LEVEL_* constant (10/20/30/40);
// Vanderlin's craftdiff is a small integer where each point is -25% craft chance. The tiers
// map across one-for-one, matching how the jade recipes are graded:
//     SKILL_LEVEL_NOVICE     -> 0
//     SKILL_LEVEL_APPRENTICE -> 1
//     SKILL_LEVEL_JOURNEYMAN -> 2
//     SKILL_LEVEL_EXPERT     -> 3

// ---------------------------------------------------------------------------
// Stick-carved pieces.
// ---------------------------------------------------------------------------

/datum/repeatable_crafting_recipe/crafting/woodcarving
	abstract_type = /datum/repeatable_crafting_recipe/crafting/woodcarving
	requirements = list(
		/obj/item/grown/log/tree/stick = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to whittle the stick", "start to whittle the stick")
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom = /obj/item/weapon/knife
	skillcraft = /datum/attribute/skill/craft/crafting
	output_amount = 1
	craftdiff = 1
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/crafting/woodcarving/marble
	name = "wooden marble"
	output = /obj/item/carvedwood/marble
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/woodcarving/spire
	name = "wooden spire"
	output = /obj/item/carvedwood/spire
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/woodcarving/displaystand
	name = "wooden display stand"
	output = /obj/item/carvedwood/displaystand
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/woodcarving/comb
	name = "wooden comb"
	output = /obj/item/carvedwood/comb
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/woodcarving/cameo
	name = "wooden cameo"
	output = /obj/item/carvedwood/cameo
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/woodcarving/prism
	name = "wooden prism"
	output = /obj/item/carvedwood/prism
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/woodcarving/figurine
	name = "wooden figurine"
	output = /obj/item/carvedwood/figurine
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/figurineelf
	name = "wooden elf figurine"
	output = /obj/item/carvedwood/figurineelf
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/figurineanthro
	name = "wooden wildkin figurine"
	output = /obj/item/carvedwood/figurineanthro
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/fish
	name = "wooden fish figurine"
	output = /obj/item/carvedwood/fish
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/frog
	name = "wooden frog figurine"
	output = /obj/item/carvedwood/frog
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/duck
	name = "wooden duck figurine"
	output = /obj/item/carvedwood/duck
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/saiga
	name = "wooden saiga figurine"
	output = /obj/item/carvedwood/saiga
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/ashtray
	name = "wooden zigtray"
	output = /obj/item/carvedwood/ashtray
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/heart
	name = "wooden heart"
	output = /obj/item/carvedwood/heart
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/sun
	name = "wooden sun"
	output = /obj/item/carvedwood/sun
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/woodcarving/moon
	name = "wooden moon"
	output = /obj/item/carvedwood/moon
	craftdiff = 2

// ---------------------------------------------------------------------------
// Log-carved pieces - bigger stock, bigger results.
// ---------------------------------------------------------------------------

/datum/repeatable_crafting_recipe/crafting/woodcarving/log
	abstract_type = /datum/repeatable_crafting_recipe/crafting/woodcarving/log
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve the log", "start to carve the log")
	)
	attacked_atom = /obj/item/grown/log/tree/small

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/box
	name = "wooden box"
	output = /obj/item/carvedwood/box
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/vase
	name = "wooden vase"
	output = /obj/item/carvedwood/vase
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/gameboard
	name = "wooden game board"
	output = /obj/item/carvedwood/gameboard
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/plinth
	name = "wooden plinth"
	output = /obj/item/carvedwood/plinth
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/pillar
	name = "wooden pillar"
	output = /obj/item/carvedwood/pillar
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/vessel
	name = "large wooden vessel"
	output = /obj/item/carvedwood/vessel
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/fancyvase
	name = "fancy wooden vase"
	output = /obj/item/carvedwood/fancyvase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/shrine
	name = "wooden shrine"
	output = /obj/item/carvedwood/shrine
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/bust
	name = "wooden bust"
	output = /obj/item/carvedwood/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/beaver
	name = "wooden beaver statuette"
	output = /obj/item/carvedwood/beaver
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/woodcarving/log/bottle
	name = "wooden bottle"
	output = /obj/item/reagent_containers/glass/bottle/waterskin/wood
	craftdiff = 3
