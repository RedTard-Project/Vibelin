/datum/sprite_accessory/proc/apply_taur_genital_offset(list/appearance_list, mob/living/carbon/owner)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	var/obj/item/bodypart/taur_part = H.get_taur_tail()
	if(!taur_part)
		return
	var/offset_y = taur_part.vars["genital_offset_y"]
	var/offset_x = taur_part.vars["genital_offset_x"]
	if(!isnum(offset_y))
		offset_y = 0
	if(!isnum(offset_x))
		offset_x = 0
	var/list/to_remove = list()
	for(var/mutable_appearance/appearance as anything in appearance_list)
		if(appearance.layer == -BODY_BEHIND_LAYER)
			to_remove += appearance
			continue
		if(isnum(offset_y))
			appearance.pixel_y += offset_y
		if(isnum(offset_x))
			appearance.pixel_x += offset_x
	appearance_list -= to_remove

/datum/sprite_accessory/penis
	icon = 'modular_abel/erp/icons/mob/sprite_accessory/genitals/pintle.dmi'
	color_keys = 2
	color_key_names = list("Member", "Skin")
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	var/has_erect_states = TRUE
	var/erp_has_knot = FALSE

/datum/sprite_accessory/penis/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_PENIS)
	apply_taur_genital_offset(appearance_list, owner)
	genital_apply_stack_layer(appearance_list, GENITAL_LAYER_PENIS)

/datum/sprite_accessory/penis/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/pp = organ
	if(pp.sheath_type != SHEATH_TYPE_NONE && pp.erect_state != ERECT_STATE_HARD)
		switch(pp.sheath_type)
			if(SHEATH_TYPE_NORMAL)
				return (pp.erect_state == ERECT_STATE_NONE) ? "sheath_1" : "sheath_2"
			if(SHEATH_TYPE_SLIT)
				return (pp.erect_state == ERECT_STATE_NONE) ? "slit_1" : "slit_2"
	if(pp.erect_state == ERECT_STATE_HARD && has_erect_states)
		return "[icon_state]_[pp.penis_size]_erect"
	return "[icon_state]_[pp.penis_size]"

/datum/sprite_accessory/penis/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/H = owner
	if(istype(H) && smallclothes_groin_covered(H))
		return FALSE
	if(istype(H) && H.taur_groin_covered())
		return FALSE
	if(istype(H) && !get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT)

/datum/sprite_accessory/penis/human
	icon_state = "human"
	name = "Plain"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/penis/knotted
	icon_state = "knotted"
	name = "Knotted"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)
	erp_has_knot = TRUE

/datum/sprite_accessory/penis/flared
	icon_state = "flared"
	name = "Flared"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/penis/flared_knotted
	icon_state = "flared"
	name = "Flared, Knotted"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)
	erp_has_knot = TRUE

/datum/sprite_accessory/penis/barbknot
	icon_state = "barbknot"
	name = "Barbed, Knotted"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)
	erp_has_knot = TRUE

/datum/sprite_accessory/penis/tapered_knot
	icon_state = "knotted2"
	name = "Tapered, Knotted"
	default_colors = list("C52828", "C52828")
	has_erect_states = FALSE
	erp_has_knot = TRUE

/datum/sprite_accessory/penis/tapered
	icon_state = "tapered"
	name = "Tapered"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/penis/tapered_mammal
	icon_state = "tapered"
	name = "Tapered (Mammal)"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/penis/tentacle
	icon_state = "tentacle"
	name = "Tentacled"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/penis/hemi
	icon_state = "hemi"
	name = "Hemi"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/penis/hemiknot
	icon_state = "hemiknot"
	name = "Knotted Hemi"
	default_colors = list("C52828", "C52828")
	erp_has_knot = TRUE

/datum/sprite_accessory/testicles
	icon = 'modular_abel/erp/icons/mob/sprite_accessory/genitals/gonads.dmi'
	color_key_name = "Sack"
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER)

/datum/sprite_accessory/testicles/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_TESTICLES)
	apply_taur_genital_offset(appearance_list, owner)
	genital_apply_stack_layer(appearance_list, GENITAL_LAYER_TESTICLES)

/datum/sprite_accessory/testicles/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/testicles/testes = organ
	return "[icon_state]_[testes.ball_size]"

/datum/sprite_accessory/testicles/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/H = owner
	if(istype(H) && smallclothes_groin_covered(H))
		return FALSE
	var/obj/item/organ/penis/pp = owner?.getorganslot(ORGAN_SLOT_PENIS)
	if(pp && pp.sheath_type == SHEATH_TYPE_SLIT)
		return FALSE
	if(istype(H) && H.taur_groin_covered())
		return FALSE
	if(istype(H) && !get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT)

/datum/sprite_accessory/testicles/pair
	name = "Pair"
	icon_state = "pair"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/breasts
	icon = 'modular_abel/erp/icons/mob/sprite_accessory/genitals/breasts.dmi'
	color_key_name = "Breasts"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/breasts/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/breasts/badonkers = organ
	if(badonkers.breast_size <= 0)
		return null
	return "[icon_state]_[badonkers.breast_size]"

/datum/sprite_accessory/breasts/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_BREASTS)
	genital_apply_stack_layer(appearance_list, GENITAL_LAYER_BREASTS)

/datum/sprite_accessory/breasts/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/breasts/pair
	icon_state = "pair"
	name = "Pair"
	color_key_defaults = list(KEY_CHEST_COLOR)

/datum/sprite_accessory/breasts/quad
	icon_state = "quad"
	name = "Quad"
	color_key_defaults = list(KEY_CHEST_COLOR)

/datum/sprite_accessory/breasts/sextuple
	icon_state = "sextuple"
	name = "Sextuple"
	color_key_defaults = list(KEY_CHEST_COLOR)

/datum/sprite_accessory/vagina
	icon = 'modular_abel/erp/icons/mob/sprite_accessory/genitals/nethers.dmi'
	color_key_name = "Nethers"
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/vagina/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_VAGINA)
	apply_taur_genital_offset(appearance_list, owner)
	genital_apply_stack_layer(appearance_list, GENITAL_LAYER_VAGINA)

/datum/sprite_accessory/vagina/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/H = owner
	if(istype(H) && smallclothes_groin_covered(H))
		return FALSE
	if(istype(H) && H.taur_groin_covered())
		return FALSE
	if(istype(H) && !get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT)

/datum/sprite_accessory/vagina/human
	icon_state = "human"
	name = "Plain"
	default_colors = list("ea6767")

/datum/sprite_accessory/vagina/hairy
	icon_state = "hairy"
	name = "Hairy"
	color_key_defaults = list(KEY_HAIR_COLOR)

/datum/sprite_accessory/vagina/spade
	icon_state = "spade"
	name = "Spade"
	default_colors = list("C52828")

/datum/sprite_accessory/vagina/furred
	icon_state = "furred"
	name = "Furred"
	color_key_defaults = list(KEY_MUT_COLOR_ONE)

/datum/sprite_accessory/vagina/gaping
	icon_state = "gaping"
	name = "Gaping"
	default_colors = list("f99696")

/datum/sprite_accessory/vagina/cloaca
	icon_state = "cloaca"
	name = "Cloaca"
	default_colors = list("f99696")
