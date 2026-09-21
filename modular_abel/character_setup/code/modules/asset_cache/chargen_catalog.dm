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
	for(var/species_id in GLOB.roundstart_species)
		var/species_type = GLOB.species_list[species_id]
		if(!species_type)
			continue
		var/datum/species/species = new species_type()
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
	return data
