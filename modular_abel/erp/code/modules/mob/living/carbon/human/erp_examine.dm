/mob/living/carbon/human/Topic(href, href_list)
	. = ..()
	if(!href_list["view_descriptors"])
		return
	if(!ismob(usr))
		return
	if(!isobserver(usr) && !usr.can_perform_action(src, NEED_LIGHT))
		return
	var/list/organ_lines = erp_examine_features(usr)
	if(length(organ_lines))
		to_chat(usr, span_info("[organ_lines.Join("\n")]"))

/mob/living/carbon/human/proc/erp_zone_uncovered(zone)
	for(var/obj/item/equipped in get_equipped_items())
		if(zone2covered(zone, equipped.body_parts_covered))
			return FALSE
	if(zone == BODY_ZONE_PRECISE_GROIN && taur_groin_covered())
		return FALSE
	if(zone == BODY_ZONE_PRECISE_GROIN && underwear != "Nude")
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/erp_examine_features(mob/user)
	. = list()
	if(!client?.prefs?.erp_enabled)
		return

	var/groin_exposed = erp_zone_uncovered(BODY_ZONE_PRECISE_GROIN)
	var/chest_exposed = erp_zone_uncovered(BODY_ZONE_CHEST)
	if(!groin_exposed && !chest_exposed)
		return

	var/list/features = list()

	if(groin_exposed)
		var/obj/item/organ/penis/penis = getorganslot(ORGAN_SLOT_PENIS)
		if(penis?.visible_organ && penis.accessory_type)
			var/size_name = find_key_by_value(PENIS_SIZES_BY_NAME, penis.penis_size)
			features += "a[size_name ? " [LOWER_TEXT(size_name)]" : ""] penis"
		var/obj/item/organ/testicles/balls = getorganslot(ORGAN_SLOT_TESTICLES)
		if(balls?.visible_organ && balls.accessory_type)
			var/size_name = find_key_by_value(TESTICLE_SIZES_BY_NAME, balls.ball_size)
			features += "[size_name ? "[LOWER_TEXT(size_name)] " : ""]testicles"
		var/obj/item/organ/vagina/cunt = getorganslot(ORGAN_SLOT_VAGINA)
		if(cunt?.visible_organ && cunt.accessory_type)
			features += "a vagina"

	if(chest_exposed)
		var/obj/item/organ/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
		if(breasts?.visible_organ && breasts.accessory_type)
			var/size_name = find_key_by_value(BREAST_SIZES_BY_NAME, breasts.breast_size)
			features += "[size_name ? "[LOWER_TEXT(size_name)] " : ""]breasts[breasts.lactating ? ", lactating" : ""]"

	if(length(features))
		. += "<span style='color: #6e3aa8'>[capitalize(english_list(features))].</span>"
