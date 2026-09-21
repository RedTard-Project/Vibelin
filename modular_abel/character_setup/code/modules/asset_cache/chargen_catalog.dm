/datum/asset/json/chargen_catalog
	name = "chargen_catalog"

/datum/asset/json/chargen_catalog/generate()
	var/list/data = list()
	data["background_options"] = character_setup_background_options()
	data["tgui_themes"] = tgui_theme_options()

	var/list/age_tooltips = list()
	for(var/age_name in ALL_AGES_LIST_CHILD)
		age_tooltips["[age_name]"] = character_setup_age_stat_tooltip(age_name)
	data["age_tooltips"] = age_tooltips

	var/list/order = list()
	var/list/species_entries = list()
	for(var/species_id in GLOB.character_setup_species_instances)
		var/datum/species/species = GLOB.character_setup_species_instances[species_id]
		var/species_type = species.type
		order += species.id

		var/list/display_ages = character_setup_species_display_ages(species)
		var/list/raw_tags = character_setup_species_tags(species, TRUE)
		var/list/entry = list(
			"id" = species.id,
			"stats" = list(
				"[MALE]" = character_setup_species_stats_for(species, MALE),
				"[FEMALE]" = character_setup_species_stats_for(species, FEMALE),
			),
		)
		for(var/ru in list(FALSE, TRUE))
			var/raw_desc = chargen_tr_desc_for(ru, species_type, species.desc)
			var/description = raw_desc ? character_setup_chargen_clean_text(character_setup_strip_species_warning(raw_desc), 900) : "No description available."
			entry[ru ? "ru" : "en"] = list(
				"name" = chargen_tr_name_for(ru, species_type, species.name),
				"description" = trim(description),
				"language" = chargen_tr_term_for(ru, species.native_language || "Imperial"),
				"ancestry_label" = chargen_tr_term_for(ru, species.skin_tone_wording || "Ancestry"),
				"ages" = character_setup_species_shown_ages(ru, display_ages),
				"tags" = character_setup_species_shown_tags(ru, species, TRUE),
				"tag_descriptions" = character_setup_species_tag_descriptions(ru, species, TRUE),
				"warning" = character_setup_species_warning(ru, species, raw_tags),
				"locked_tag" = chargen_tr_term_for(ru, "Locked"),
			)
		species_entries[species.id] = entry

	data["species_order"] = order
	data["species"] = species_entries

	var/list/option_lists = list()
	var/list/accessory_index = list()
	for(var/species_id in GLOB.character_setup_species_instances)
		var/datum/species/species = GLOB.character_setup_species_instances[species_id]
		for(var/customizer_type in species.customizers)
			var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
			if(!customizer)
				continue
			for(var/choice_type in customizer.customizer_choices)
				var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(choice_type)
				if(!choice)
					continue
				var/list/per_choice = accessory_index["[choice_type]"]
				if(!per_choice)
					per_choice = list()
					accessory_index["[choice_type]"] = per_choice
				for(var/gender in list(MALE, FEMALE, PLURAL))
					var/slot = "[species.id]|[gender]"
					if(per_choice[slot])
						continue
					var/list/options = character_setup_accessory_options_for(choice, species, gender)
					var/signature = "[length(options)]"
					for(var/list/option as anything in options)
						signature += "|[option["value"]]"
					if(!option_lists[signature])
						option_lists[signature] = options
					per_choice[slot] = signature

	for(var/choice_key in accessory_index)
		var/list/per_choice = accessory_index[choice_key]
		var/only = null
		var/uniform = TRUE
		for(var/slot in per_choice)
			if(isnull(only))
				only = per_choice[slot]
			else if(per_choice[slot] != only)
				uniform = FALSE
				break
		if(uniform)
			accessory_index[choice_key] = only

	data["option_lists"] = option_lists
	data["accessory_index"] = accessory_index
	return data
