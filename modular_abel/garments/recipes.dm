// Sewing recipes for the ported garments.
//
// Azure has its own sewing recipes for these (crafting_recipe/roguetown/sewing/*), which is
// the batch-4 item of the port list - they belong with the garments rather than on their own,
// so they are here. Re-expressed for /datum/repeatable_crafting_recipe/sewing: hold the
// needle, click the cloth, pick the garment.
//
// Cloth costs follow Azure's reqs where it declares them and the surrounding Vanderlin
// sewing recipes otherwise. craftdiff uses Vanderlin's 0-6 scale, not Azure's SKILL_LEVEL_*.

/datum/repeatable_crafting_recipe/sewing/taverndress
	name = "tavern dress"
	output = /obj/item/clothing/shirt/dress/tavern
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/datum/repeatable_crafting_recipe/sewing/bluedress
	name = "blue dress"
	output = /obj/item/clothing/shirt/dress/blue
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sewing/greendress
	name = "green dress"
	output = /obj/item/clothing/shirt/dress/green
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sewing/formalskirt
	name = "formal skirt"
	output = /obj/item/clothing/pants/skirt/formal
	requirements = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sewing/toga_dress
	name = "toga"
	output = /obj/item/clothing/cloak/tabard/toga/dress
	requirements = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/datum/repeatable_crafting_recipe/sewing/leopardrobe
	name = "leopard bathrobe"
	output = /obj/item/clothing/shirt/robe/leopard
	requirements = list(/obj/item/natural/cloth = 2, /obj/item/natural/fur = 2)
	craftdiff = 2

/datum/repeatable_crafting_recipe/sewing/wintercoat
	name = "winter coat"
	output = /obj/item/clothing/shirt/tunic/winter
	requirements = list(/obj/item/natural/cloth = 3, /obj/item/natural/fur = 1)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/lunarrobe
	name = "lunar robe"
	output = /obj/item/clothing/shirt/robe/lunar
	requirements = list(/obj/item/natural/cloth = 4)
	craftdiff = 3

/datum/repeatable_crafting_recipe/sewing/magerobe
	name = "magician's robe"
	output = /obj/item/clothing/shirt/robe/magician
	requirements = list(/obj/item/natural/cloth = 4)
	craftdiff = 3

// The open-fronted variant is its own garment upstream (Vanderlin does the same for
// robe/eora/alt, which has its own weaving recipe), so it gets its own sewing recipe rather
// than an exemption.
/datum/repeatable_crafting_recipe/sewing/leopardrobe_open
	name = "open leopard bathrobe"
	output = /obj/item/clothing/shirt/robe/leopard/alt
	requirements = list(/obj/item/natural/cloth = 2, /obj/item/natural/fur = 2)
	craftdiff = 2
