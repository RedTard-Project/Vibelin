// Odds and ends from the Azure-Peak port that did not fit the clothing batches.
// Added upstream after Vibelin PR #5.

// ---------------------------------------------------------------------------
// The traditional Psydonian tabard.
//
// Azure hangs this off /obj/item/clothing/cloak/tabard/psydontabard, which Vanderlin does
// not have. Per the "variation on what is in stock" rule it is declared straight off our own
// /obj/item/clothing/cloak/tabard instead of importing that family.
//
// Azure's "bared" variant (/white/alt) is not ported: it declares
// icon_state = "whitepsydontabard_alt", and no such state exists in Azure's own cloaks.dmi
// or its onmob sheet - the same defect as its bared toga and its banneret sallet.
// ---------------------------------------------------------------------------

/obj/item/clothing/cloak/tabard/psydon_traditional
	name = "traditional tabard"
	desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a sleeveless garment \
	that harks back to the ancient yils of the Holy Inquisition."
	icon = 'modular_abel/sundries/icons/sundries_world.dmi'
	mob_overlay_icon = 'modular_abel/sundries/icons/sundries_onmob.dmi'
	icon_state = "whitepsydontabard"
	item_state = "whitepsydontabard"
	// The parent tabard carries detail_tag = "_spl" for its heraldic split. This one is a
	// fixed white design (Azure marks it custom_design), so it has no _spl state and must
	// clear the tag or item_detail_sanity fails on the missing icon.
	detail_tag = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	sellprice = 30

// ---------------------------------------------------------------------------
// Flavoured zigs.
//
// Azure loads these with /datum/reagent/drug/westleach, /apple and /mentha. Vanderlin has
// none of the three, and importing a reagent line for two cigarettes is out of proportion,
// so they are built on our own nicotine at the same total potency. They are flavour items:
// the taste is in the name and the description, not in a bespoke reagent.
// ---------------------------------------------------------------------------

/obj/item/clothing/face/cigarette/rollie/apple
	name = "apple zig"
	desc = "Dried leaf carefully wrapped in fine paper. It has a particularly smooth taste with a cooling effect."
	list_reagents = list(/datum/reagent/drug/nicotine = 45)

/obj/item/clothing/face/cigarette/rollie/menthaapple
	name = "mentha-apple zig"
	desc = "Dried leaf carefully wrapped in fine paper, sweetened and sharpened at once. It has a particularly smooth taste with a cooling effect."
	list_reagents = list(/datum/reagent/drug/nicotine = 45)
