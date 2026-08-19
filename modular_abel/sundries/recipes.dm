/datum/repeatable_crafting_recipe/sewing/psydon_traditional_tabard
	name = "traditional tabard"
	output = /obj/item/clothing/cloak/tabard/psydon_traditional
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sigdry/apple
	name = "apple zig"
	output = /obj/item/clothing/face/cigarette/rollie/apple
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/dry_westleach = 2,
		/obj/item/reagent_containers/food/snacks/apple_dried = 1,
	)
	crafting_message = "starts rolling an apple zig"
	craftdiff = 1

/datum/repeatable_crafting_recipe/sigdry/menthaapple
	name = "mentha-apple zig"
	output = /obj/item/clothing/face/cigarette/rollie/menthaapple
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/dry_westleach = 2,
		/obj/item/reagent_containers/food/snacks/apple_dried = 1,
	)
	crafting_message = "starts rolling a mentha-apple zig"
	craftdiff = 2
