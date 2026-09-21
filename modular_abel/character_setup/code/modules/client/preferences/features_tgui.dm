/datum/sprite_accessory/proc/character_setup_thumb_state()
	if(!icon || isnull(icon_state) || icon_state == "")
		return null
	var/state = icon_state
	if(length(relevant_layers))
		var/layer_for_thumb = (BODY_FRONT_LAYER in relevant_layers) ? BODY_FRONT_LAYER : relevant_layers[1]
		state = "[icon_state]_[get_layer_suffix(layer_for_thumb)]"
	if(color_keys > 1)
		state = "[state]_1"
	var/list/states = icon_states(icon)
	if(!(state in states))
		state = (icon_state in states) ? icon_state : null
	return state

/datum/asset/spritesheet/character_setup_chargen
	name = "character_setup_chargen"

/datum/asset/spritesheet/character_setup_chargen/create_spritesheets()
	var/list/seen = list()
	for(var/choice_type in subtypesof(/datum/customizer_choice))
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(choice_type)
		if(!choice || !LAZYLEN(choice.sprite_accessories))
			continue
		for(var/accessory_type in choice.sprite_accessories)
			character_setup_insert_chargen_sprite(accessory_type, seen)

/datum/asset/spritesheet/character_setup_chargen/proc/character_setup_insert_chargen_sprite(accessory_type, list/seen)
	var/key = sanitize_css_class_name("[accessory_type]")
	if(seen[key])
		return
	seen[key] = TRUE
	var/datum/sprite_accessory/acc = SPRITE_ACCESSORY(accessory_type)
	if(!acc)
		return
	var/state = acc.character_setup_thumb_state()
	if(!state)
		return
	var/icon/spr = icon(acc.icon, state)
	if(!spr)
		return
	spr.Scale(48, 48)
	Insert(key, spr)

/datum/customizer_choice/proc/character_setup_tgui_extras(datum/preferences/prefs, datum/customizer_entry/entry)
	return null

/datum/customizer_choice/bodypart_feature/hair/character_setup_tgui_extras(datum/preferences/prefs, datum/customizer_entry/entry)
	var/datum/customizer_entry/hair/hair_entry = entry
	var/list/out = list()
	out += list(list("task" = "hair_color", "label" = "Hair Color", "kind" = "color", "value" = hair_entry.hair_color))
	if(allows_natural_gradient)
		var/datum/hair_gradient/natural_gradient = HAIR_GRADIENT(hair_entry.natural_gradient)
		out += list(list("task" = "natural_gradient", "label" = "Natural Gradient", "kind" = "text", "value" = natural_gradient.name))
		if(hair_entry.natural_gradient != /datum/hair_gradient/none)
			out += list(list("task" = "natural_gradient_color", "label" = "Natural Color", "kind" = "color", "value" = hair_entry.natural_color))
	if(allows_dye_gradient)
		var/datum/hair_gradient/dye_gradient = HAIR_GRADIENT(hair_entry.dye_gradient)
		out += list(list("task" = "dye_gradient", "label" = "Dye Gradient", "kind" = "text", "value" = dye_gradient.name))
		if(hair_entry.dye_gradient != /datum/hair_gradient/none)
			out += list(list("task" = "dye_gradient_color", "label" = "Dye Color", "kind" = "color", "value" = hair_entry.dye_color))
	return out

/datum/customizer_choice/organ/eyes/character_setup_tgui_extras(datum/preferences/prefs, datum/customizer_entry/entry)
	var/datum/customizer_entry/organ/eyes/eyes_entry = entry
	var/list/out = list()
	out += list(list("task" = "right_eye_color", "label" = "Right Eye Color", "kind" = "color", "value" = eyes_entry.right_eye_color))
	if(allows_heterochromia)
		out += list(list("task" = "left_eye_color", "label" = "Left Eye Color", "kind" = "color", "value" = eyes_entry.left_eye_color))
	return out

/datum/customizer_choice/organ/penis/character_setup_tgui_extras(datum/preferences/prefs, datum/customizer_entry/entry)
	var/datum/customizer_entry/organ/penis/penis_entry = entry
	return list(
		list("task" = "penis_size", "label" = "Size", "kind" = "text", "value" = find_key_by_value(PENIS_SIZES_BY_NAME, penis_entry.penis_size)),
		list("task" = "functional", "label" = "Functional", "kind" = "text", "value" = penis_entry.functional ? "Yes" : "No"),
	)

/datum/customizer_choice/organ/testicles/character_setup_tgui_extras(datum/preferences/prefs, datum/customizer_entry/entry)
	var/datum/customizer_entry/organ/testicles/testicles_entry = entry
	return list(
		list("task" = "ball_size", "label" = "Size", "kind" = "text", "value" = find_key_by_value(TESTICLE_SIZES_BY_NAME, testicles_entry.ball_size)),
		list("task" = "virile", "label" = "Fertility", "kind" = "text", "value" = testicles_entry.virility ? "Virile" : "Sterile"),
	)

/datum/customizer_choice/organ/breasts/character_setup_tgui_extras(datum/preferences/prefs, datum/customizer_entry/entry)
	var/datum/customizer_entry/organ/breasts/breasts_entry = entry
	return list(
		list("task" = "breast_size", "label" = "Size", "kind" = "text", "value" = find_key_by_value(BREAST_SIZES_BY_NAME, breasts_entry.breast_size)),
		list("task" = "lactating", "label" = "Lactation", "kind" = "text", "value" = breasts_entry.lactating ? "Enabled" : "Disabled"),
	)

/datum/customizer_choice/organ/vagina/character_setup_tgui_extras(datum/preferences/prefs, datum/customizer_entry/entry)
	var/datum/customizer_entry/organ/vagina/vagina_entry = entry
	return list(
		list("task" = "fertile", "label" = "Fertility", "kind" = "text", "value" = vagina_entry.fertility ? "Fertile" : "Sterile"),
	)

/datum/customizer_choice/proc/character_setup_is_erp()
	return FALSE

/datum/customizer_choice/organ/penis/character_setup_is_erp()
	return TRUE

/datum/customizer_choice/organ/testicles/character_setup_is_erp()
	return TRUE

/datum/customizer_choice/organ/breasts/character_setup_is_erp()
	return TRUE

/datum/customizer_choice/organ/vagina/character_setup_is_erp()
	return TRUE

/datum/preferences/proc/character_setup_accessory_option_list(datum/customizer_choice/choice)
	. = list()
	var/list/accessory_types = choice.character_setup_accessory_types(src)
	if(length(accessory_types) < 2)
		return .
	var/section = choice.character_setup_section()
	for(var/accessory_type in accessory_types)
		var/datum/sprite_accessory/iter_accessory = SPRITE_ACCESSORY(accessory_type)
		if(!iter_accessory)
			continue
		var/list/accessory_option = list(
			"name" = iter_accessory.name,
			"value" = "[accessory_type]",
		)
		if(section == "underwear")
			var/list/coverage = list()
			if(iter_accessory.smallclothes_covers_torso)
				coverage += "torso"
			if(iter_accessory.smallclothes_covers_groin)
				coverage += "groin"
			if(iter_accessory.smallclothes_covers_legs)
				coverage += "legs"
			accessory_option["coverage"] = length(coverage) ? jointext(coverage, ", ") : "decorative"
		. += list(accessory_option)

/datum/preferences/proc/character_setup_build_feature_options()
	var/_t = TICK_USAGE_REAL
	var/list/choices = list()
	var/list/accessories = list()
	. = list("choices" = choices, "accessories" = accessories)
	if(!pref_species)
		return .
	if(length(customizer_entries) < length(pref_species.customizers))
		validate_customizer_entries()
	for(var/customizer_type in pref_species.customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer || !customizer.is_allowed(src))
			continue
		if(length(customizer.customizer_choices) > 1)
			var/list/choice_options = list()
			for(var/choice_type in customizer.customizer_choices)
				var/datum/customizer_choice/iter_choice = CUSTOMIZER_CHOICE(choice_type)
				if(!iter_choice)
					continue
				choice_options += list(list("name" = iter_choice.name, "value" = "[choice_type]"))
			choices["[customizer_type]"] = choice_options
		for(var/choice_type in customizer.customizer_choices)
			var/datum/customizer_choice/iter_choice = CUSTOMIZER_CHOICE(choice_type)
			if(!iter_choice)
				continue
			var/list/accessory_options = character_setup_accessory_option_list(iter_choice)
			if(length(accessory_options))
				accessories["[choice_type]"] = accessory_options
	character_setup_log_op("build_feature_options", _t, "choices=[length(choices)] accessories=[length(accessories)]")

/datum/preferences/proc/character_setup_build_features_data()
	var/_t = TICK_USAGE_REAL
	var/list/features = list()
	if(!pref_species)
		return features
	if(length(customizer_entries) < length(pref_species.customizers))
		validate_customizer_entries()
	for(var/customizer_type in pref_species.customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer || !customizer.is_allowed(src))
			continue
		var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
		if(!entry)
			continue
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		if(!choice)
			continue

		var/list/feature = list(
			"key" = "[customizer_type]",
			"name" = customizer.name,
			"enabled" = !entry.disabled,
			"can_disable" = customizer.allows_disabling,
			"choice_name" = choice.name,
			"choice_value" = "[entry.customizer_choice_type]",
			"erp" = choice.character_setup_is_erp() ? TRUE : FALSE,
		)
		var/feature_section = choice.character_setup_section()
		if(feature_section)
			feature["section"] = feature_section

		var/list/accessory_types = choice.character_setup_accessory_types(src)
		if(length(accessory_types) && entry.accessory_type)
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
			if(accessory)
				feature["accessory_name"] = accessory.name
				feature["accessory_value"] = "[entry.accessory_type]"
				if(choice.allows_accessory_color_customization && accessory.color_keys)
					var/list/colors = list()
					var/list/color_list = color_string_to_list(entry.accessory_colors)
					for(var/index in 1 to accessory.color_keys)
						if(index > length(color_list))
							break
						colors += list(list(
							"name" = (accessory.color_keys == 1) ? accessory.color_key_name : accessory.color_key_names[index],
							"value" = color_list[index],
							"index" = "[index]",
						))
					if(length(colors))
						feature["colors"] = colors

		var/list/extras = choice.character_setup_tgui_extras(src, entry)
		if(length(extras))
			feature["extras"] = extras

		features += list(feature)
	character_setup_log_op("build_features_data", _t, "features=[length(features)]")
	return features
