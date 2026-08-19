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
