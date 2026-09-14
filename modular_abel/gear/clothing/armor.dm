/obj/item/clothing/armor/chainmail/bronze
	name = "bronze haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked bronze rings. The value of flexible protection, especially in the centuries before plate, made any form of chainmail a rather valuable commodity."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "bhaubergeon"
	item_state = "bhaubergeon"
	armor_type = /datum/armor/maille/bronze
	max_integrity = INTEGRITY_OLD_STRONG + 75
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/armor/chainmail/hauberk/bronze
	name = "bronze hauberk"
	desc = "A maille-aketon of bronze, sleeved to cover both the arms and legs. Light enough to leave a well-trained warrior unfettered, yet still capable of turning away both arrow and blade."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "bhauberk"
	item_state = "bhauberk"
	armor_type = /datum/armor/maille/bronze
	max_integrity = INTEGRITY_OLD_STRONG + 75
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/armor/chainmail/light
	name = "haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked steel rings. Light enough to comfortably tuck underneath a blouse, yet tough enough to thwart the razor-sharp edges of unwelcomed company."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "haubyrnie"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	armor_class = AC_LIGHT
	armor_type = /datum/armor/maille
	body_parts_covered = COVERAGE_TORSO
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL
	material_category = ARMOR_MAT_CHAINMAIL
	smeltresult = /obj/item/ingot/steel_slag

/obj/item/clothing/armor/chainmail/light/iron
	name = "iron haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked iron rings. For the discerning peasant."
	icon_state = "ihaubyrnie"
	item_state = "ihaubyrnie"
	armor_type = /datum/armor/maille/iron
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL * 0.6
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron

/obj/item/clothing/armor/chainmail/light/bronze
	name = "bronze haubyrnie"
	desc = "A sleeveless maille shirt, fashioned from dozens of interlinked bronze rings. For the discerning traveler - ideally, from an antique land."
	icon_state = "bhaubyrnie"
	item_state = "bhaubyrnie"
	armor_type = /datum/armor/maille/bronze
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL * 0.75
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/armor/medium/scale/bronze
	name = "bronze lamellar"
	desc = "A coat of small bronze plates, segmented together in a manner not unlike chainmail. Divorced from the romanticized images of bare-chested legionnaires, but venerable nevertheless."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "blamellar"
	armor_type = /datum/armor/maille/bronze
	max_integrity = INTEGRITY_OLD_STRONG - 25
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/armor/medium/scale/iron
	name = "iron lamellar"
	desc = "A coat of small iron plates, segmented together in a manner not unlike chainmail. This curious combination provides the best of both worlds; protection on par with more rigid sets of plate armor, but without all the weight."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "ilamellar"
	armor_type = /datum/armor/maille/iron
	max_integrity = INTEGRITY_OLD_STANDARD + 50
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron

/obj/item/clothing/armor/leather/jacket/newmoon
	name = "newmoon jacket"
	desc = "A heavy, ornate coat of dense and sturdy fabric, protected well enough to see use in the field. A distinctive mark of a sacred order, worn with a holy amulet at the center of its chestpiece."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "newmoon_jacket"
	item_state = "newmoon_jacket"
	blocksound = SOFTHIT
	armor_type = /datum/armor/minimal
	nodismemsleeves = TRUE
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	max_integrity = INTEGRITY_OLD_STRONG
	armor_class = AC_MEDIUM

/obj/item/clothing/armor/chainmail/hauberk/donator
	name = "maillekini"
	desc = "A curious - and particularly revealing - variant of a common maille-aketon. It's said that the intentionally provocative design excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "chainkinis"
	item_state = "chainkinis"

/obj/item/clothing/armor/chainmail/hauberk/iron/donator
	name = "iron maillekini"
	desc = "A curious - and particularly revealing - variant of an iron maille-aketon. It's said that the intentionally provocative design excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "chainkinii"
	item_state = "chainkinii"

/obj/item/clothing/armor/chainmail/hauberk/bronze/donator
	name = "bronze maillekini"
	desc = "A curious - and particularly revealing - variant of a bronze maille-aketon. It's said that the intentionally provocative design excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "chainkinib"
	item_state = "chainkinib"

/obj/item/clothing/armor/chainmail/donator
	name = "cropped haubergeon"
	desc = "A curious - and particularly revealing - variant of a common maille-garment. It's said that the intentionally provocative design excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "cropmailles"
	item_state = "cropmailles"

/obj/item/clothing/armor/chainmail/iron/donator
	name = "cropped iron haubergeon"
	desc = "A curious - and particularly revealing - variant of an iron maille-garment. It's said that the intentionally provocative design excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "cropmaillei"
	item_state = "cropmaillei"

/obj/item/clothing/armor/chainmail/bronze/donator
	name = "cropped bronze haubergeon"
	desc = "A curious - and particularly revealing - variant of a bronze maille-garment. It's said that the intentionally provocative design excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "cropmailleb"
	item_state = "cropmailleb"

/obj/item/clothing/armor/chainmail/donator_elven
	name = "elven haubergeon"
	desc = "An ancestral design, passed down from the oldest of the land's native elven inhabitants. The greenish tint present along the leatherbound steel maille is the byproduct of its links being fashioned through magicks, not a forge's heat."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "elven_chain"
	item_state = "elven_chain"

/obj/item/clothing/armor/chainmail/iron/donator_elven
	name = "elven iron haubergeon"
	desc = "An ancestral design, passed down from the oldest of the land's native elven inhabitants. The greenish tint present along the leatherbound iron maille is the byproduct of its links being fashioned through magicks, not a forge's heat."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "elven_chain"
	item_state = "elven_chain"

/obj/item/clothing/armor/leather/donator
	name = "leather heartplate"
	desc = "A curious - and particularly revealing - variant of a leather vest. It's said that the intentionally provocative design excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "heartplatel"
	item_state = "heartplatel"

/obj/item/clothing/armor/leather/donator_cuirass
	name = "heroic leather cuirass"
	desc = "A flexible vest, stitched together from lengths of cured leather. It hugs the wearer's form, gifting them a mimicked form of a sculpted physique - or maybe that's just a byproduct of it being so damn tight."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "leathercuirass"
	item_state = "leathercuirass"

/obj/item/clothing/armor/leather/studded/psyaltrist/donator_cuirass
	name = "heroic leather cuirass"
	desc = "A flexible vest, stitched together from lengths of cured leather. It hugs the wearer's form, gifting them a mimicked form of a sculpted physique - or maybe that's just a byproduct of it being so damn tight."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "leathercuirass"
	item_state = "leathercuirass"

/obj/item/clothing/armor/plate/iron/donator_gothic
	name = "gothic iron half-plate"
	desc = "A magnificent iron cuirass, fitted with tassets and assembled by a mastersmith. The intricate fluting and interlocked plates are clear signs of foreign heritage; expensive, but second-to-none when it comes to what truly matters in life."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "ighalfplate"
	item_state = "ighalfplate"

/obj/item/clothing/armor/plate/full/iron/donator_gothic
	name = "gothic iron plate armor"
	desc = "A magnificent set of iron plate armor, assembled by a mastersmith. The intricate fluting and interlocked plates are clear signs of foreign heritage; expensive, but second-to-none when it comes to what truly matters in life."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "igplate"
	item_state = "igplate"

/obj/item/clothing/armor/plate/donator_gothic
	name = "gothic half-plate"
	desc = "A magnificent steel cuirass, fitted with tassets and assembled by a mastersmith. The intricate fluting and interlocked plates are clear signs of foreign heritage; expensive, but second-to-none when it comes to what truly matters in life."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "ghalfplate"
	item_state = "ghalfplate"

/obj/item/clothing/armor/plate/full/donator_gothic
	name = "gothic plate armor"
	desc = "A magnificent set of steel plate armor, assembled by a mastersmith. The intricate fluting and interlocked plates are clear signs of foreign heritage; expensive, but second-to-none when it comes to what truly matters in life."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "gplate"
	item_state = "gplate"

/obj/item/clothing/armor/plate/full/donator_triheartfelt
	name = "regal plate armor"
	desc = "A complete set of finely-styled plate armor, decorated with a furred coif and a silk robe dyed a deep blue. Most intimately associated with foreign diplomats and champions, these suits are traditionally restricted to the battlefields of garish noble courtrooms and balls."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "triheartfelt"
	item_state = "triheartfelt"

/obj/item/clothing/armor/gambeson/tombraider
	name = "tomb raider's vest"
	desc = "A dashing outfit for an experienced tomb raider."
	armor_type = /datum/armor/leather
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "tombraidervest"
	item_state = "tombraidervest"
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	sleeved = 'modular_abel/gear/icons/onmob/armor_sleeves.dmi'

/obj/item/clothing/armor/gambeson/sophisticated_jacket
	name = "sophisticated jacket"
	desc = "A finely tailored jacket of sophisticated design, favored by those who value refinement, status, and impeccable presentation."
	icon_state = "sophisticatedjacket"
	item_state = "sophisticatedjacket"
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	sleeved = 'modular_abel/gear/icons/onmob/armor_sleeves.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	dropshrink = null

/obj/item/clothing/armor/gambeson/sophisticated_coat
	name = "sophisticated coat"
	desc = "A sophisticated coat of fine tailoring and subtle elegance, worn to project refinement, confidence, and social standing."
	icon_state = "sophisticatedcoat"
	item_state = "sophisticatedcoat"
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	sleeved = 'modular_abel/gear/icons/onmob/armor_sleeves.dmi'
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	dropshrink = null

/obj/item/clothing/armor/gambeson/winter_coat
	name = "warm winter coat"
	desc = "A thick, well-crafted winter coat designed to retain heat and protect against harsh cold while remaining comfortable for daily wear."
	icon_state = "wintercoat"
	item_state = "wintercoat"
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	sleeved = 'modular_abel/gear/icons/onmob/armor_sleeves.dmi'
	salvage_result = /obj/item/natural/fur
	min_cold_protection_temperature = -40
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR

/obj/item/clothing/armor/leather/druid
	name = "druid armor"
	desc = "A carefully layered armor of cured leather, living oak bark, and woven leaves. Flexible yet resilient, it carries the quiet strength of the forest."
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	sleeved = 'modular_abel/gear/icons/onmob/armor_sleeves.dmi'
	icon_state = "druid"
	item_state = "druid"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/armor/plate/decorated/corset/colored
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	icon = 'modular_abel/gear/icons/armor.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/armor.dmi'
	icon_state = "corset"
	item_state = "corset"
