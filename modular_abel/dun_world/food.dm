/obj/item/reagent_containers/food/snacks/cooked/smoked_z
	name = "foul jerky bundle"
	desc = "Harder than leather, devoid of soul. At least it seems to be purified to the point of being edible."
	icon = 'modular_abel/dun_world/icons/cooked_meat.dmi'
	icon_state = "meat_smoked_z"
	biting = TRUE
	eat_effect = null
	tastes = list("smoky meat" = 1)
	slices_num = 0
	nutrition = SNACK_DECENT
	rotprocess = null
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks
	var/smoked_type

/obj/item/reagent_containers/food/snacks/cooked/smoked_meat
	name = "smoked meat"
	desc = "A slab of flesh cured slow over smouldering wood. Keeps for a season, tastes of the fire that made it."
	icon = 'modular_abel/dun_world/icons/cooked_meat.dmi'
	icon_state = "meat_smoked"
	biting = TRUE
	eat_effect = null
	tastes = list("smoky meat" = 1)
	slices_num = 0
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/cooked/smoked_fish
	name = "smoked fish"
	desc = "Split, salted and hung in the smoke until the flesh turns amber and firm."
	icon = 'modular_abel/dun_world/icons/cooked_meat.dmi'
	icon_state = "salmon_smoked"
	biting = TRUE
	eat_effect = null
	tastes = list("smoked fish" = 1)
	slices_num = 0
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/meat
	smoked_type = /obj/item/reagent_containers/food/snacks/cooked/smoked_meat

/obj/item/reagent_containers/food/snacks/fish
	smoked_type = /obj/item/reagent_containers/food/snacks/cooked/smoked_fish
