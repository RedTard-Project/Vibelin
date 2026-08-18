// Pottery wheel recipes for the ported ceramic vessels.
// Ported from Azure-Peak code/modules/roguetown/roguecrafting/ceramics.dm.
//
// Azure declares these as /datum/crafting_recipe/roguetown/ceramics with reqs/result and a
// separate firing step. Vanderlin already has its own wheel (code/datums/pottery_recipes/),
// where each unit of clay is one throwing step and the finished piece comes off the wheel
// directly - so the clay cost becomes that many recipe_steps.
//
// Difficulty: Azure grades these craftdiff 1-5. Vanderlin's difficulty feeds
// success_chance = 25 * ((skill - difficulty) + 1), and its own recipes sit at 0-1, so the
// Azure spread is compressed into 1-3 rather than copied literally - a 5 would be
// unthrowable for anyone below master.
//
// Not ported: Azure's clay mug (Vanderlin already has /datum/pottery_recipe/mug) and its
// clay box, which fires into a porcelain storage container Vanderlin has no equivalent for.

/datum/pottery_recipe/ceramic
	abstract_type = /datum/pottery_recipe/ceramic
	skill = /datum/attribute/skill/craft/crafting

/datum/pottery_recipe/ceramic/skinny_vase
	name = "Skinny Ceramic Vase"
	created_item = /obj/item/reagent_containers/glass/bottle/ceramic/skinny
	difficulty = 1
	recipe_steps = list(
		/obj/item/natural/clay,
		/obj/item/natural/clay,
	)
	step_to_time = list(
		4 SECONDS,
		4 SECONDS,
	)

/datum/pottery_recipe/ceramic/bamana
	name = "Ceramic Bamana Pot"
	created_item = /obj/item/reagent_containers/glass/bottle/ceramic/bamana
	difficulty = 2
	recipe_steps = list(
		/obj/item/natural/clay,
		/obj/item/natural/clay,
		/obj/item/natural/clay,
	)
	step_to_time = list(
		4 SECONDS,
		5 SECONDS,
		5 SECONDS,
	)

/datum/pottery_recipe/ceramic/tall_vase
	name = "Tall Ceramic Vase"
	created_item = /obj/item/reagent_containers/glass/bottle/ceramic/tallvase
	difficulty = 2
	recipe_steps = list(
		/obj/item/natural/clay,
		/obj/item/natural/clay,
		/obj/item/natural/clay,
	)
	step_to_time = list(
		4 SECONDS,
		5 SECONDS,
		6 SECONDS,
	)

/datum/pottery_recipe/ceramic/standing_vase
	name = "Standing Ceramic Vase"
	created_item = /obj/item/reagent_containers/glass/bottle/ceramic/standing
	difficulty = 3
	recipe_steps = list(
		/obj/item/natural/clay,
		/obj/item/natural/clay,
		/obj/item/natural/clay,
	)
	step_to_time = list(
		5 SECONDS,
		6 SECONDS,
		6 SECONDS,
	)

/datum/pottery_recipe/ceramic/amphora
	name = "Ceramic Amphora"
	created_item = /obj/item/reagent_containers/glass/bottle/ceramic/amphora
	difficulty = 3
	recipe_steps = list(
		/obj/item/natural/clay,
		/obj/item/natural/clay,
		/obj/item/natural/clay,
		/obj/item/natural/clay,
	)
	step_to_time = list(
		5 SECONDS,
		5 SECONDS,
		6 SECONDS,
		7 SECONDS,
	)
