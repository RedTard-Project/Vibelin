/obj/item/reagent_containers/glass/bottle/ceramic
	abstract_type = /obj/item/reagent_containers/glass/bottle/ceramic
	icon = 'modular_abel/ceramics/icons/ceramics.dmi'
	desc = "A fired clay vessel."
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 20)
	grid_height = 64
	grid_width = 64
	dropshrink = 0.9
	sellprice = 12

/obj/item/reagent_containers/glass/bottle/ceramic/amphora
	name = "ceramic amphora"
	desc = "A large ceramic amphora, a vessel with an ancient design that originated off of Etrusca's coast."
	icon_state = "clayamphorabaked"
	volume = 200
	sellprice = 24

/obj/item/reagent_containers/glass/bottle/ceramic/tallvase
	name = "tall ceramic vase"
	desc = "A remarkably tall clay vessel for storing copious amounts of liquid."
	icon_state = "claytallvasebaked"
	volume = 160
	sellprice = 20

/obj/item/reagent_containers/glass/bottle/ceramic/bamana
	name = "ceramic bamana pot"
	desc = "A wide Naledian style pot that is useful for holding large amounts of liquid."
	icon_state = "claybamanabaked"
	volume = 130
	sellprice = 18

/obj/item/reagent_containers/glass/bottle/ceramic/standing
	name = "standing ceramic vase"
	desc = "A curious ceramic vessel with two humenoid legs helping it stand upright."
	icon_state = "clayfeetbaked"
	volume = 100
	sellprice = 16

/obj/item/reagent_containers/glass/bottle/ceramic/skinny
	name = "skinny ceramic vase"
	desc = "A skinny ceramic vessel that holds a meager amount of liquid."
	icon_state = "clayskinnybaked"
	volume = 35
	grid_height = 32
	grid_width = 32
	sellprice = 8

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
