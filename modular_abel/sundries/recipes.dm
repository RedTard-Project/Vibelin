// The tabard is a garment, so craftable_clothes wants a recipe for it. Sewn from cloth,
// matching the other tabards' weight. The zigs are not clothing subtypes for the test's
// purposes only in the sense that they are - /obj/item/clothing/face/cigarette - so they are
// covered by the existing rollie crafting upstream; if that ever changes they need one too.

/datum/repeatable_crafting_recipe/sewing/psydon_traditional_tabard
	name = "traditional tabard"
	output = /obj/item/clothing/cloak/tabard/psydon_traditional
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

// The flavoured zigs are rolled the same way as the plain westleach one
// (/datum/repeatable_crafting_recipe/sigdry), with dried apple worked into the leaf. Azure's mentha has no Vanderlin
// equivalent, so the mentha-apple zig differs only by being the finer roll of the two.
// craftable_clothes counts cigarettes as clothing, so they need these.

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
