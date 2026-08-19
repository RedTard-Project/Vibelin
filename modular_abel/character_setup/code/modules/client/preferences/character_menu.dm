/datum/preferences/var/character_setup_preferences_initial_tab = "identity"
/datum/preferences/var/character_setup_preferences_open_sequence = 0
/datum/preferences/var/character_setup_tgui_theme = "grim"
/datum/preferences/var/character_setup_preferences_fullscreen = TRUE
/datum/preferences/var/character_setup_preferences_scale = 1
/datum/preferences/var/character_setup_preferences_scale_version = 3
/datum/preferences/var/character_setup_preview_underwear = TRUE
/datum/preferences/var/character_setup_preview_clothes = TRUE
/datum/preferences/var/character_setup_preview_dir = SOUTH
/datum/preferences/var/character_setup_preview_background
/datum/preferences/var/character_setup_static_sig
/datum/preferences/var/atom/movable/screen/map_view/character_setup_view
/datum/preferences/var/atom/movable/screen/map_view/character_setup_view_front
/datum/preferences/var/atom/movable/screen/map_view/character_setup_view_side
/datum/preferences/var/atom/movable/screen/background/character_setup_bg
/datum/preferences/var/atom/movable/screen/background/character_setup_bg_front
/datum/preferences/var/atom/movable/screen/background/character_setup_bg_side
/datum/preferences/var/character_setup_view_extent_w = 1
/datum/preferences/var/character_setup_view_extent_h = 1
/datum/preferences/var/character_setup_view_bbox_w = 32
/datum/preferences/var/character_setup_view_bbox_h = 33
/datum/preferences/var/character_setup_view_zoom_w = 32
/datum/preferences/var/character_setup_view_zoom_h = 36
/datum/preferences/var/character_setup_view_off_x = 0
/datum/preferences/var/character_setup_view_off_y = 0
/datum/preferences/var/character_setup_view_bbox_sent = ""
/datum/preferences/var/character_setup_view_doll_x = 1
/datum/preferences/var/character_setup_view_doll_y = 1
/datum/preferences/var/character_setup_view_doll_px = 0
/datum/preferences/var/character_setup_view_doll_py = 0
/datum/preferences/var/character_setup_view_canvas_w = 20
/datum/preferences/var/character_setup_view_canvas_h = 15
/datum/preferences/var/character_setup_view_canvas_cx = 320
/datum/preferences/var/character_setup_view_canvas_cy = 240
/datum/preferences/var/character_setup_view_tile_top = 15
/datum/preferences/var/character_setup_view_tile_center = 8
/datum/preferences/var/character_setup_view_scale = 12
/datum/preferences/var/character_setup_view_feet_margin = 20
/datum/preferences/var/character_setup_view_last_flat = ""
/datum/preferences/var/character_setup_render_main_only = FALSE
/datum/preferences/var/mob/living/carbon/human/dummy/character_setup_body
/datum/preferences/var/character_setup_hover_acc
/datum/preferences/var/character_setup_hover_color
/datum/preferences/var/character_setup_hover_customizer
/datum/preferences/var/character_setup_view_busy = FALSE
/datum/preferences/var/character_setup_view_pending = FALSE
/datum/preferences/var/character_setup_view_shown = FALSE
/datum/preferences/var/list/character_setup_ui_heavy_cache
/datum/preferences/var/character_setup_ui_heavy_sig

GLOBAL_LIST_EMPTY(character_setup_chargen_ooc_messages)

GLOBAL_VAR_INIT(character_setup_debug, TRUE)
GLOBAL_VAR_INIT(character_setup_flat_origin_x, 0)
GLOBAL_VAR_INIT(character_setup_flat_origin_y, 0)

/proc/character_setup_glog(category, msg)
	if(!GLOB.character_setup_debug)
		return
	WRITE_LOG("[GLOB.log_directory]/character_setup.log", "[world.timeofday]ds render \[[category]\] [msg]")

/proc/character_setup_art_bounds(icon/scanned)
	if(!isicon(scanned))
		return null
	var/width = scanned.Width()
	var/height = scanned.Height()
	var/x1 = 0
	var/x2 = 0
	var/y1 = 0
	var/y2 = 0
	for(var/y in 1 to height)
		for(var/x in 1 to width)
			if(!scanned.GetPixel(x, y))
				continue
			if(!x1 || x < x1)
				x1 = x
			if(x > x2)
				x2 = x
			if(!y1)
				y1 = y
			y2 = y
	if(!x1)
		return null
	return list(x1, y1, x2, y2)

/proc/character_setup_push_all_prefs()
	for(var/client/lobby_client as anything in GLOB.clients)
		if(lobby_client?.prefs)
			SStgui.update_uis(lobby_client.prefs)

/datum/preferences/var/list/character_setup_log_counts
/datum/preferences/var/character_setup_log_action_name = ""
/datum/preferences/var/character_setup_log_action_tod = 0

/datum/preferences/proc/character_setup_log(category, msg)
	if(!GLOB.character_setup_debug)
		return
	WRITE_LOG("[GLOB.log_directory]/character_setup.log", "[world.timeofday]ds [parent?.ckey || "?"] \[[category]\] [msg]")

/datum/preferences/proc/character_setup_log_action(action_name, extra)
	if(!GLOB.character_setup_debug)
		return
	character_setup_log_counts = list()
	character_setup_log_action_name = action_name
	character_setup_log_action_tod = world.timeofday
	character_setup_log("ACTION", ">>>>> [action_name][extra ? " ([extra])" : ""]")

/datum/preferences/proc/character_setup_log_op(op, start_tod, detail)
	if(!GLOB.character_setup_debug)
		return
	LAZYINITLIST(character_setup_log_counts)
	character_setup_log_counts[op] = (character_setup_log_counts[op] || 0) + 1
	var/cnt = character_setup_log_counts[op]
	var/delta = world.timeofday - start_tod
	character_setup_log("OP", "[op] x[cnt] took=[delta]ds[detail ? " {[detail]}" : ""][cnt > 1 ? "  *** MULTIPLICATIVE in [character_setup_log_action_name] ***" : ""]")

/datum/preferences/proc/cspref_age()
	return read_preference(/datum/preference/choiced/age)
/datum/preferences/proc/cspref_set_age(value)
	write_preference(/datum/preference/choiced/age, value)
/datum/preferences/proc/cspref_gender()
	return read_preference(/datum/preference/choiced/gender)
/datum/preferences/proc/cspref_set_gender(value)
	write_preference(/datum/preference/choiced/gender, value)
/datum/preferences/proc/cspref_underwear()
	return read_preference(/datum/preference/choiced/underwear)
/datum/preferences/proc/cspref_set_underwear(value)
	write_preference(/datum/preference/choiced/underwear, value)
/datum/preferences/proc/cspref_underwear_color()
	return read_preference(/datum/preference/color/underwear_color)
/datum/preferences/proc/cspref_set_underwear_color(value)
	write_preference(/datum/preference/color/underwear_color, value)
/datum/preferences/proc/cspref_undershirt()
	return read_preference(/datum/preference/choiced/undershirt)
/datum/preferences/proc/cspref_set_undershirt(value)
	write_preference(/datum/preference/choiced/undershirt, value)
/datum/preferences/proc/cspref_socks()
	return read_preference(/datum/preference/choiced/socks)
/datum/preferences/proc/cspref_set_socks(value)
	write_preference(/datum/preference/choiced/socks, value)
/datum/preferences/proc/cspref_skin_tone()
	return read_preference(/datum/preference/choiced/skin_tone)
/datum/preferences/proc/cspref_set_skin_tone(value)
	write_preference(/datum/preference/choiced/skin_tone, value)
/datum/preferences/proc/cspref_real_name()
	return read_preference(/datum/preference/text/real_name)
/datum/preferences/proc/cspref_set_real_name(value)
	write_preference(/datum/preference/text/real_name, value)
/datum/preferences/proc/cspref_pronouns()
	return read_preference(/datum/preference/choiced/pronouns)
/datum/preferences/proc/cspref_set_pronouns(value)
	write_preference(/datum/preference/choiced/pronouns, value)
/datum/preferences/proc/cspref_culture()
	return read_preference(/datum/preference/choiced/culture)
/datum/preferences/proc/cspref_set_culture(value)
	write_preference(/datum/preference/choiced/culture, value)
/datum/preferences/proc/cspref_domhand()
	return read_preference(/datum/preference/choiced/domhand)
/datum/preferences/proc/cspref_set_domhand(value)
	write_preference(/datum/preference/choiced/domhand, value)
/datum/preferences/proc/cspref_selected_patron()
	return read_preference(/datum/preference/choiced/patron)
/datum/preferences/proc/cspref_set_selected_patron(value)
	write_preference(/datum/preference/choiced/patron, value)
/datum/preferences/proc/cspref_faith()
	return read_preference(/datum/preference/choiced/faith)
/datum/preferences/proc/cspref_set_faith(value)
	write_preference(/datum/preference/choiced/faith, value)
/datum/preferences/proc/cspref_detail()
	return read_preference(/datum/preference/choiced/detail)
/datum/preferences/proc/cspref_set_detail(value)
	write_preference(/datum/preference/choiced/detail, value)
/datum/preferences/proc/cspref_flavortext()
	return read_preference(/datum/preference/text/flavortext)
/datum/preferences/proc/cspref_set_flavortext(value)
	write_preference(/datum/preference/text/flavortext, value)
/datum/preferences/proc/cspref_gender_choice()
	return read_preference(/datum/preference/choiced/gender_choice)
/datum/preferences/proc/cspref_set_gender_choice(value)
	write_preference(/datum/preference/choiced/gender_choice, value)
/datum/preferences/proc/cspref_family()
	return read_preference(/datum/preference/choiced/family_mode)
/datum/preferences/proc/cspref_set_family(value)
	write_preference(/datum/preference/choiced/family_mode, value)
/datum/preferences/proc/cspref_headshot_link()
	return read_preference(/datum/preference/text/headshot_link)
/datum/preferences/proc/cspref_set_headshot_link(value)
	write_preference(/datum/preference/text/headshot_link, value)
/datum/preferences/proc/cspref_accessory()
	return read_preference(/datum/preference/choiced/accessory)
/datum/preferences/proc/cspref_set_accessory(value)
	write_preference(/datum/preference/choiced/accessory, value)
/datum/preferences/proc/cspref_voice_type()
	return read_preference(/datum/preference/choiced/voice_type)
/datum/preferences/proc/cspref_set_voice_type(value)
	write_preference(/datum/preference/choiced/voice_type, value)
/datum/preferences/proc/cspref_voice_color()
	return read_preference(/datum/preference/color/voice_color)
/datum/preferences/proc/cspref_set_voice_color(value)
	write_preference(/datum/preference/color/voice_color, value)
/datum/preferences/proc/cspref_selected_accent()
	return read_preference(/datum/preference/choiced/selected_accent)
/datum/preferences/proc/cspref_set_selected_accent(value)
	write_preference(/datum/preference/choiced/selected_accent, value)
/datum/preferences/proc/cspref_setspouse()
	return read_preference(/datum/preference/text/setspouse)
/datum/preferences/proc/cspref_set_setspouse(value)
	write_preference(/datum/preference/text/setspouse, value)
/datum/preferences/proc/cspref_hotkeys()
	return read_preference(/datum/preference/toggle/hotkeys)
/datum/preferences/proc/cspref_buttons_locked()
	return read_preference(/datum/preference/toggle/buttons_locked)
/datum/preferences/proc/cspref_see_chat_non_mob()
	return read_preference(/datum/preference/toggle/see_chat_non_mob)
/datum/preferences/proc/cspref_tgui_fancy()
	return read_preference(/datum/preference/toggle/tgui_fancy)
/datum/preferences/proc/cspref_tgui_lock()
	return read_preference(/datum/preference/toggle/tgui_lock)
/datum/preferences/proc/cspref_windowflashing()
	return read_preference(/datum/preference/toggle/windowflashing)
/datum/preferences/proc/cspref_toggles()
	return read_preference(/datum/preference/bitwise/toggles)
/datum/preferences/proc/cspref_ambientocclusion()
	return read_preference(/datum/preference/toggle/ambientocclusion)
/datum/preferences/proc/cspref_auto_fit_viewport()
	return read_preference(/datum/preference/toggle/auto_fit_viewport)
/datum/preferences/proc/cspref_widescreenpref()
	return read_preference(/datum/preference/toggle/widescreenpref)
/datum/preferences/proc/cspref_pixel_size()
	return read_preference(/datum/preference/numeric/pixel_size)
/datum/preferences/proc/cspref_scaling_method()
	return read_preference(/datum/preference/choiced/scaling_method)
/datum/preferences/proc/cspref_language()
	return read_preference(/datum/preference/choiced/language)
/datum/preferences/var/current_tab = 0

/proc/character_setup_chargen_record_ooc(sender, message, lobby_only = FALSE)
	if(!istext(sender) || !istext(message))
		return

	var/clean_message = trim(STRIP_HTML_FULL(message, MAX_MESSAGE_LEN))
	if(!length(clean_message))
		return

	GLOB.character_setup_chargen_ooc_messages += list(list(
		"sender" = sender,
		"message" = clean_message,
		"time" = time2text(world.timeofday, "hh:mm"),
		"lobby" = !!lobby_only,
	))
	if(length(GLOB.character_setup_chargen_ooc_messages) > 40)
		GLOB.character_setup_chargen_ooc_messages.Cut(1, length(GLOB.character_setup_chargen_ooc_messages) - 39)

/datum/preferences/show_choices(mob/user, tabchoice)
	if(!user || !user.client)
		return
	if(slot_randomized)
		load_character(default_slot)
		slot_randomized = FALSE

	character_setup_preferences_initial_tab = (tabchoice == 1 || current_tab == 1) ? "game" : "identity"
	character_setup_preferences_open_sequence++
	current_tab = (character_setup_preferences_initial_tab == "game") ? 1 : 0
	build_and_show_menu(user)
	current_tab = 0

/datum/preferences/build_and_show_menu(mob/user)
	if(!user?.client)
		return

	user.client.acquire_dpi()
	winshow(user, "stonekeep_prefwin", FALSE)
	user << browse(null, "window=preferences_browser")

	validate_customizer_entries()
	character_setup_static_sig = "[pref_species?.type]-[cspref_gender()]"
	character_setup_log("LIFECYCLE", "build_and_show_menu user=[user.ckey] species=[pref_species?.id] gender=[cspref_gender()] static_sig=[character_setup_static_sig]")
	ui_interact(user)

/datum/preferences/update_menu_data(mob/user, list/fields_to_update)
	var/_t = world.timeofday
	character_setup_ui_heavy_sig = null
	var/new_static_sig = "[pref_species?.type]-[cspref_gender()]"
	var/static_refreshed = FALSE
	if(new_static_sig != character_setup_static_sig)
		character_setup_static_sig = new_static_sig
		update_static_data(user)
		static_refreshed = TRUE
	character_setup_update_view()
	character_setup_log_op("update_menu_data", _t, "fields=[fields_to_update ? jointext(fields_to_update, ",") : "all"] static_refresh=[static_refreshed]")

/datum/preferences/proc/character_setup_sanitize_preferences_scale(value)
	if(!isnum(value))
		value = text2num("[value]")
	if(!isnum(value))
		return 0.85
	return clamp(round(value * 20) / 20, 0.8, 1.25)

/datum/preferences/load_preferences()
	. = ..()
	if(!. || !path || !fexists(path))
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/"
	S["character_setup_tgui_theme"] >> character_setup_tgui_theme
	S["character_setup_preferences_fullscreen"] >> character_setup_preferences_fullscreen
	S["character_setup_preferences_scale"] >> character_setup_preferences_scale
	var/loaded_scale_version
	S["character_setup_preferences_scale_version"] >> loaded_scale_version

	if(!istext(character_setup_tgui_theme) || !length(character_setup_tgui_theme))
		character_setup_tgui_theme = initial(character_setup_tgui_theme)
	character_setup_preferences_fullscreen = !!character_setup_preferences_fullscreen
	if(!isnum(loaded_scale_version) || loaded_scale_version < character_setup_preferences_scale_version)
		character_setup_preferences_scale = initial(character_setup_preferences_scale)
	character_setup_preferences_scale = character_setup_sanitize_preferences_scale(character_setup_preferences_scale)

/datum/preferences/save_preferences()
	. = ..()
	if(!. || !path)
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/"
	WRITE_FILE(S["character_setup_tgui_theme"], character_setup_tgui_theme)
	WRITE_FILE(S["character_setup_preferences_fullscreen"], character_setup_preferences_fullscreen)
	WRITE_FILE(S["character_setup_preferences_scale"], character_setup_preferences_scale)
	WRITE_FILE(S["character_setup_preferences_scale_version"], character_setup_preferences_scale_version)

/datum/preferences/ui_state(mob/user)
	return GLOB.always_state

/datum/preferences/ui_assets(mob/user)
	character_setup_log("ASSETS", "ui_assets served chargen spritesheet user=[user?.ckey]")
	return list(get_asset_datum(/datum/asset/spritesheet/character_setup_chargen))

/datum/preferences/proc/character_setup_handle_color_task(mob/user, list/href_list)
	var/customizer_type = text2path(href_list["customizer"])
	if(!customizer_type)
		return FALSE
	var/datum/customizer_entry/hair/he = get_customizer_entry_for_customizer_type(customizer_type)
	if(!istype(he))
		return FALSE
	var/field
	switch(href_list["customizer_task"])
		if("hair_color")
			field = "hair_color"
		if("natural_gradient_color")
			field = "natural_color"
		if("dye_gradient_color")
			field = "dye_color"
		else
			return FALSE
	var/new_color = input(user, "Choose color", "Color", he.vars[field]) as color|null
	if(new_color)
		he.vars[field] = sanitize_hexcolor(new_color)
	character_setup_log("COLOR", "color_task field=[field] customizer=[customizer_type] new=[new_color || "cancel"]")
	return TRUE

/datum/preferences/ui_static_data(mob/user)
	var/_t = world.timeofday
	. = list()
	.["background_options"] = character_setup_background_options()
	.["thumbs"] = character_setup_thumbnail_catalog()
	.["species_options"] = character_setup_species_options()
	character_setup_log_op("ui_static_data", _t, "thumbs=[length(.["thumbs"])] species=[length(.["species_options"])]")

/datum/preferences/proc/character_setup_species_lock_reason(datum/species/species)
	if(!species)
		return "Unavailable"
	if(species.preference_accessible(src))
		return ""
	switch(species.id)
		if(SPEC_ID_DWARF_SUBTERRAN, SPEC_ID_KOBOLD_FORMIKRAG)
			return "Triumph unlock"
	return "Unavailable"

/datum/preferences/proc/character_setup_stat_modifiers_for_sheet(sheet_type)
	. = list()
	if(!sheet_type)
		return

	var/datum/attribute_holder/sheet/sheet = GLOB.attribute_sheets[sheet_type]
	if(!sheet)
		sheet = GLOB.attribute_sheets[sheet_type] = new sheet_type()
	for(var/stat_type in MOBSTATS)
		var/value = sheet.raw_attribute_list[stat_type]
		if(!isnum(value) || !value)
			continue
		var/datum/attribute/stat/stat = GET_ATTRIBUTE_DATUM(stat_type)
		. += list(list(
			"name" = stat ? stat.name : "[stat_type]",
			"label" = stat ? stat.shorthand : "[stat_type]",
			"value" = value,
		))

/datum/preferences/proc/character_setup_species_stat_modifiers(datum/species/species)
	if(!species)
		return list()
	var/sheet_type = species.statsheet_male
	if(cspref_gender() == FEMALE && species.statsheet_female)
		sheet_type = species.statsheet_female
	return character_setup_stat_modifiers_for_sheet(sheet_type)

/datum/preferences/proc/character_setup_age_sheet_type(age_name)
	switch(age_name)
		if(AGE_MIDDLEAGED)
			return /datum/attribute_holder/sheet/age/middleaged
		if(AGE_OLD)
			return /datum/attribute_holder/sheet/age/old
		if(AGE_CHILD)
			return /datum/attribute_holder/sheet/age/child

/datum/preferences/proc/character_setup_stat_modifier_summary(list/modifiers)
	if(!length(modifiers))
		return "No stat modifiers."
	var/list/parts = list()
	for(var/list/modifier as anything in modifiers)
		var/value = modifier["value"]
		parts += "[modifier["label"]] [value > 0 ? "+" : ""][value]"
	return parts.Join(", ")

/datum/preferences/proc/character_setup_age_stat_tooltip(age_name)
	var/list/modifiers = character_setup_stat_modifiers_for_sheet(character_setup_age_sheet_type(age_name))
	if(!length(modifiers))
		return "[age_name]: No age stat modifiers."
	return "[age_name]: [character_setup_stat_modifier_summary(modifiers)]"

/datum/preferences/proc/character_setup_species_tags(datum/species/species, available)
	. = list()
	if(!species)
		return
	if(species.native_language)
		. += "[species.native_language]"
	if(species.skin_tone_wording && species.skin_tone_wording != "Ancestry")
		. += "[species.skin_tone_wording]"
	var/list/display_ages = character_setup_species_display_ages(species)
	if(length(display_ages) == 1)
		. += "[display_ages[1]]"
	if(!(species.id in RACES_PLAYER_NONDISCRIMINATED))
		. += "Discriminated"
	if(!(species.id in RACES_PLAYER_NONEXOTIC))
		. += "Exotic"
	if(species.forced_taur)
		. += "Taur"
	if(!available)
		. += "Locked"

/datum/preferences/proc/character_setup_species_tag_description(datum/species/species, tag, available)
	switch(tag)
		if("Discriminated")
			return "This species faces social discrimination; expect a more difficult roundstart experience."
		if("Exotic")
			return "This species is considered uncommon or exotic in most local cultures."
		if("Taur")
			return "Tauric body plan; some equipment and clothing may fit differently."
		if("Locked")
			return available ? "Available." : character_setup_species_lock_reason(species)

	if(species)
		if(species.native_language && tag == "[species.native_language]")
			return "Native language or culture group: [tag]."
		if(species.skin_tone_wording && tag == "[species.skin_tone_wording]")
			return "This species uses [tag] as its ancestry/color choice."
		if(tag in character_setup_species_display_ages(species))
			return "Available age category: [tag]."

	return "[tag] species tag."

/datum/preferences/proc/character_setup_species_tag_descriptions(datum/species/species, available)
	. = list()
	for(var/tag in character_setup_species_tags(species, available))
		.["[tag]"] = character_setup_species_tag_description(species, tag, available)

/datum/preferences/proc/character_setup_species_display_ages(datum/species/species)
	. = list()
	if(!species)
		return
	for(var/possible_age in species.possible_ages)
		if(possible_age == AGE_CHILD)
			continue
		if(!(possible_age in .))
			. += possible_age

/datum/preferences/proc/character_setup_species_options()
	. = list()
	for(var/species_id in GLOB.roundstart_species)
		var/species_type = GLOB.species_list[species_id]
		if(!species_type)
			continue
		var/datum/species/species = new species_type()
		var/lock_reason = character_setup_species_lock_reason(species)
		var/available = !lock_reason
		var/description = species.desc ? character_setup_chargen_clean_text(species.desc, 900) : "No description available."
		var/list/display_ages = character_setup_species_display_ages(species)
		. += list(list(
			"id" = species.id,
			"name" = species.name,
			"description" = trim(description),
			"available" = available,
			"lock_reason" = lock_reason,
			"language" = species.native_language || "Imperial",
			"ancestry_label" = species.skin_tone_wording || "Ancestry",
			"ages" = length(display_ages) ? display_ages.Join(", ") : "Any",
			"tags" = character_setup_species_tags(species, available),
			"tag_descriptions" = character_setup_species_tag_descriptions(species, available),
			"stats" = character_setup_species_stat_modifiers(species),
		))

/datum/preferences/proc/character_setup_apply_species(mob/user, species_id)
	var/_t = world.timeofday
	if(!user || !species_id)
		return FALSE
	if(!(species_id in GLOB.roundstart_species))
		return FALSE

	var/species_type = GLOB.species_list[species_id]
	if(!species_type)
		return FALSE

	var/datum/species/new_species = new species_type()
	if(!new_species.preference_accessible(src))
		to_chat(user, span_warning("[new_species.name] is not available for this character."))
		return TRUE

	if(pref_species?.type == species_type)
		return TRUE

	var/saved_age = cspref_age()
	var/saved_name = cspref_real_name()
	cspref_set_selected_accent(ACCENT_DEFAULT)
	pref_species = new_species

	to_chat(user, "<em>[pref_species.name]</em>")
	if(pref_species.desc)
		to_chat(user, "[pref_species.desc]")

	if(!length(pref_species.allowed_pronouns))
		to_chat(user, span_warning("This species does not have any allowed pronouns. Please contact a coder to add them."))
	else if(length(pref_species.allowed_pronouns) == 1)
		cspref_set_pronouns(pref_species.allowed_pronouns[1])
	else if(!(cspref_pronouns() in pref_species.allowed_pronouns))
		cspref_set_pronouns(pref_species.allowed_pronouns[1])

	cspref_set_real_name(pref_species.random_name(cspref_gender(), TRUE))
	reset_jobs(user)
	reset_patron(user)
	reset_culture(user)
	write_preference(/datum/preference/choiced/species, pref_species.id)
	randomise_appearance_prefs(~(RANDOMIZE_SPECIES))
	var/list/enabled_genital_customizers = list()
	for(var/customizer_type in GLOB.character_setup_genital_customizers)
		var/datum/customizer_entry/old_entry = get_customizer_entry_for_customizer_type(customizer_type)
		if(old_entry && !old_entry.disabled)
			enabled_genital_customizers += customizer_type
	customizer_entries = list()
	validate_customizer_entries()
	reset_all_customizer_accessory_colors()
	randomize_all_customizer_accessories()
	cspref_set_accessory("Nothing")
	for(var/customizer_type in enabled_genital_customizers)
		var/datum/customizer_entry/new_entry = get_customizer_entry_for_customizer_type(customizer_type)
		if(new_entry)
			new_entry.disabled = FALSE

	var/list/selectable_ages = character_setup_species_display_ages(pref_species)
	if(saved_age && (saved_age in selectable_ages))
		cspref_set_age(saved_age)
	else if(length(selectable_ages))
		cspref_set_age(selectable_ages[1])
	if(saved_name)
		cspref_set_real_name(saved_name)

	update_menu_data(user)
	character_setup_log_op("apply_species", _t, "species=[species_id] age=[cspref_age()] gender=[cspref_gender()]")
	return TRUE

/datum/preferences/proc/character_setup_thumbnail_catalog()
	var/_t = world.timeofday
	. = list()
	if(!pref_species)
		return
	for(var/customizer_type in pref_species.customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer)
			continue
		for(var/choice_type in customizer.customizer_choices)
			var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(choice_type)
			if(!choice || !LAZYLEN(choice.sprite_accessories))
				continue
			for(var/accessory_type in choice.sprite_accessories)
				var/key = "[accessory_type]"
				if(.[key])
					continue
				var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
				if(accessory)
					.[key] = sanitize_css_class_name("[accessory_type]")
	character_setup_log_op("thumbnail_catalog", _t, "entries=[length(.)] species=[pref_species?.id]")

/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	var/window_width = character_setup_preferences_fullscreen ? 7680 : 1180
	var/window_height = character_setup_preferences_fullscreen ? 4320 : 760
	ui = SStgui.try_update_ui(user, src, ui)
	var/created = FALSE
	if(!ui)
		created = TRUE
		ui = new(user, src, "PreferencesMenu", "Character Setup", window_width, window_height)
		ui.set_autoupdate(FALSE)
		ui.open()
	character_setup_log("LIFECYCLE", "ui_interact user=[user?.ckey] created=[created] fullscreen=[character_setup_preferences_fullscreen] win=[window_width]x[window_height]")
	character_setup_ensure_view(user, ui)

/datum/preferences/ui_close(mob/user)
	. = ..()
	character_setup_log("LIFECYCLE", "ui_close user=[user?.ckey]")
	var/remaining = 0
	for(var/datum/tgui/open_ui in open_uis)
		if(open_ui.user == user)
			remaining++
	if(remaining > 1)
		character_setup_log("VIEW", "ui_close keep view, other windows remain=[remaining - 1]")
		return
	character_setup_teardown_view(user)

/mob/dead/new_player/proc/character_setup_chargen_set_ready(new_ready)
	ready = new_ready
	if(ready == PLAYER_READY_TO_PLAY)
		cache_multi_ready_characters()
	else
		multi_ready_characters = list()

	var/datum/hud/new_player/lobby_hud = hud_used
	if(istype(lobby_hud))
		for(var/atom/movable/screen/lobby/button/ready/ready_button as anything in lobby_hud.static_inventory)
			ready_button.ready = (ready == PLAYER_READY_TO_PLAY)
			ready_button.base_icon_state = ready_button.ready ? "ready" : "not_ready"
			ready_button.update_appearance(UPDATE_ICON)
			break
		SEND_SIGNAL(lobby_hud, COMSIG_HUD_PLAYER_READY_TOGGLE)
	character_setup_push_all_prefs()
	return TRUE

/mob/dead/new_player/proc/character_setup_chargen_join_round()
	if(!SSticker?.IsRoundInProgress())
		to_chat(src, span_boldwarning("The round is either not ready, or has already finished..."))
		return TRUE

	var/relevant_cap
	var/hard_popcap = CONFIG_GET(number/hard_popcap)
	var/extreme_popcap = CONFIG_GET(number/extreme_popcap)
	if(hard_popcap && extreme_popcap)
		relevant_cap = min(hard_popcap, extreme_popcap)
	else
		relevant_cap = max(hard_popcap, extreme_popcap)

	if(SSticker.queued_players.len || (relevant_cap && living_player_count() >= relevant_cap && !(ckey(key) in GLOB.admin_datums)))
		to_chat(src, span_danger("[CONFIG_GET(string/hard_popcap_message)]"))

		var/queue_position = SSticker.queued_players.Find(src)
		if(queue_position == 1)
			to_chat(src, span_notice("You are next in line to join the game. You will be notified when a slot opens up."))
		else if(queue_position)
			to_chat(src, span_notice("There are [queue_position-1] players in front of you in the queue to join the game."))
		else
			SSticker.queued_players += src
			to_chat(src, span_notice("You have been added to the queue to join the game. Your position in queue is [SSticker.queued_players.len]."))
		return TRUE

	LateChoices()
	return TRUE

/datum/preferences/proc/character_setup_round_action(mob/user)
	character_setup_log("ROUND", "round_action user=[user?.ckey] state=[SSticker?.current_state]")
	var/mob/dead/new_player/new_player
	if(istype(user, /mob/dead/new_player))
		new_player = user
	if(!new_player?.client || !SSticker)
		return TRUE

	if(parent && new_player.client != parent)
		return TRUE

	if(is_active_migrant())
		to_chat(new_player, span_boldwarning("You are in the migrant queue."))
		return TRUE

	if(SSticker.IsRoundInProgress())
		return new_player.character_setup_chargen_join_round()

	if(SSticker.current_state <= GAME_STATE_PREGAME)
		if(new_player.ready == PLAYER_READY_TO_PLAY)
			if(SSticker.job_change_locked)
				return TRUE
			return new_player.character_setup_chargen_set_ready(PLAYER_NOT_READY)
		return new_player.character_setup_chargen_set_ready(PLAYER_READY_TO_PLAY)

	to_chat(new_player, span_boldwarning("The game is starting. You cannot join yet."))
	return TRUE

/datum/preferences/proc/character_setup_selectable_ages()
	. = list()
	if(!pref_species)
		return
	for(var/possible_age in pref_species.possible_ages)
		if(possible_age == AGE_CHILD)
			continue
		. += possible_age

/datum/preferences/proc/character_setup_validate_smallclothes()
	validate_customizer_entries()

/datum/preferences/proc/character_setup_preview_job()
	var/datum/job/result
	var/highest = 0
	for(var/job_type in job_preferences)
		if(job_preferences[job_type] > highest)
			highest = job_preferences[job_type]
			result = SSjob.GetJob(job_type)
	return result

/datum/preferences/proc/character_setup_ensure_view(mob/user, datum/tgui/ui)
	if(!ui || QDELETED(ui))
		return
	if(!character_setup_view)
		var/client/view_client = user?.client
		var/list/view_size = view_client?.view ? getviewsize(view_client.view) : null
		character_setup_view_tile_top = (islist(view_size) && length(view_size) >= 2) ? view_size[2] : 15
		character_setup_view_tile_center = max(1, round((character_setup_view_tile_top + 1) / 2))
		character_setup_view_scale = max(1, character_setup_view_tile_top - 2)
		character_setup_view = new
		character_setup_view.generate_view("character_setup_main_[REF(src)]_map")
		character_setup_view_front = new
		character_setup_view_front.generate_view("character_setup_front_[REF(src)]_map")
		character_setup_view_side = new
		character_setup_view_side.generate_view("character_setup_side_[REF(src)]_map")
		character_setup_bg = new
		character_setup_bg.assigned_map = character_setup_view.assigned_map
		character_setup_bg_front = new
		character_setup_bg_front.assigned_map = character_setup_view_front.assigned_map
		character_setup_bg_side = new
		character_setup_bg_side.assigned_map = character_setup_view_side.assigned_map
		if(!character_setup_body)
			character_setup_body = new
		character_setup_log("VIEW", "ensure_view created map=[character_setup_view.assigned_map] user=[user?.ckey] window=[ui?.window ? "yes" : "NO"] window_visible=[ui?.window?.visible] tile_top=[character_setup_view_tile_top]")
		character_setup_update_view()
	if(character_setup_view_shown)
		return
	var/client/target_client = user?.client
	if(!target_client || QDELETED(ui) || !ui.window)
		return
	if(!ui.window.visible)
		character_setup_log("VIEW", "await window visible, retry queued")
		addtimer(CALLBACK(src, PROC_REF(character_setup_ensure_view), user, ui), 5, TIMER_UNIQUE)
		return
	character_setup_view_shown = TRUE
	character_setup_view.display_to_client(target_client)
	character_setup_view_front.display_to_client(target_client)
	character_setup_view_side.display_to_client(target_client)
	target_client.register_map_obj(character_setup_bg)
	target_client.register_map_obj(character_setup_bg_front)
	target_client.register_map_obj(character_setup_bg_side)
	character_setup_log("VIEW", "displayed maps=[character_setup_view.assigned_map],[character_setup_view_front.assigned_map],[character_setup_view_side.assigned_map] window=[ui.window.id] tile_center=[character_setup_view_tile_center] scale=[character_setup_view_scale]")
	character_setup_diag_controls(user, "post_display")

/datum/preferences/proc/character_setup_diag_controls(mob/user, context)
	set waitfor = FALSE
	if(!GLOB.character_setup_debug || !user?.client)
		return
	sleep(1 SECONDS)
	if(!user?.client)
		return
	var/client/C = user.client
	var/window_id = character_setup_active_window_id(user)
	character_setup_log("CTRL", "[context] === geometry dump === window_id=[window_id] view=[C.view] scaling=[C.window_scaling] tile_center=[character_setup_view_tile_center] feet_margin=[character_setup_view_feet_margin] last_flat=[character_setup_view_last_flat]")
	if(window_id)
		character_setup_log("CTRL", "[context] WINDOW [window_id] winget=[winget(user, window_id, "size;pos;is-visible;is-maximized;inner-size")]")
		character_setup_log("CTRL", "[context] WINDOW.map winget=[winget(user, "[window_id].map", "size;pos;is-visible")]")
	for(var/atom/movable/screen/map_view/view as anything in list(character_setup_view, character_setup_view_front, character_setup_view_side))
		if(!view)
			continue
		var/list/bound = C.screen_maps[view.assigned_map]
		var/in_screen = (view in C.screen) ? "yes" : "NO"
		var/ctrl = winget(user, view.assigned_map, "parent;type;pos;size;view-size;icon-size;zoom;letterbox;zoom-mode;is-visible")
		character_setup_log("CTRL", "[context] MAP id=[view.assigned_map] screen_loc=[view.screen_loc] transform_scale=[character_setup_current_view_scale()] registered=[length(bound)] in_screen=[in_screen] winget=[ctrl ? ctrl : "MISSING"]")

/datum/preferences/proc/character_setup_apply_map_background(mob/user)
	if(!user?.client)
		return
	var/bg_hex = "#0d0d0d"
	switch(character_setup_preview_background)
		if("white")
			bg_hex = "#d8d8d8"
		if("dark")
			bg_hex = "#0a0a0a"
	for(var/atom/movable/screen/map_view/view as anything in list(character_setup_view, character_setup_view_front, character_setup_view_side))
		if(view)
			winset(user, view.assigned_map, "background-color=[bg_hex]")
	character_setup_log("BACKDROP", "apply_map_background bg=[character_setup_preview_background || "none"] hex=[bg_hex]")

/datum/preferences/proc/character_setup_apply_reported_zoom(mob/user, zoom_main, zoom_mini)
	if(!user?.client)
		return
	if(zoom_main > 0 && character_setup_view)
		winset(user, character_setup_view.assigned_map, "zoom=[zoom_main]")
	if(zoom_mini > 0)
		if(character_setup_view_front)
			winset(user, character_setup_view_front.assigned_map, "zoom=[zoom_mini]")
		if(character_setup_view_side)
			winset(user, character_setup_view_side.assigned_map, "zoom=[zoom_mini]")
	character_setup_apply_map_background(user)
	if(GLOB.character_setup_debug)
		character_setup_log("ZOOM", "applied main=[zoom_main] mini=[zoom_mini]")

/datum/preferences/proc/character_setup_active_window_id(mob/user)
	for(var/datum/tgui/open_ui in open_uis)
		if(open_ui.user == user && open_ui.window)
			return open_ui.window.id
	return null

/datum/preferences/proc/character_setup_teardown_view(mob/user)
	character_setup_log("VIEW", "teardown map=[character_setup_view?.assigned_map] user=[user?.ckey]")
	character_setup_hover_acc = null
	character_setup_hover_color = null
	character_setup_hover_customizer = null
	character_setup_view_shown = FALSE
	character_setup_view?.hide_from(user)
	character_setup_view_front?.hide_from(user)
	character_setup_view_side?.hide_from(user)
	QDEL_NULL(character_setup_body)
	QDEL_NULL(character_setup_view)
	QDEL_NULL(character_setup_view_front)
	QDEL_NULL(character_setup_view_side)
	QDEL_NULL(character_setup_bg)
	QDEL_NULL(character_setup_bg_front)
	QDEL_NULL(character_setup_bg_side)

/datum/preferences/proc/character_setup_update_view()
	set waitfor = FALSE
	if(!character_setup_view || !character_setup_body || !pref_species)
		character_setup_log("VIEW", "update_view SKIP view=[!!character_setup_view] body=[!!character_setup_body] species=[!!pref_species]")
		return
	if(character_setup_view_busy)
		character_setup_view_pending = TRUE
		character_setup_log("VIEW", "update_view BUSY -> pending")
		return
	character_setup_view_busy = TRUE
	do
		character_setup_view_pending = FALSE
		var/_t = world.timeofday
		character_setup_render_body()
		character_setup_log_op("render_body", _t, "dir=[character_setup_preview_dir] hover=[character_setup_hover_acc || "none"] species=[pref_species?.id]")
	while(character_setup_view_pending)
	character_setup_view_busy = FALSE
	var/bbox_sig = "[character_setup_view_zoom_w]x[character_setup_view_zoom_h]"
	if(bbox_sig != character_setup_view_bbox_sent)
		character_setup_view_bbox_sent = bbox_sig
		SStgui.update_uis(src)

/datum/preferences/proc/character_setup_render_body()
	var/mob/living/carbon/human/dummy/body = character_setup_body
	var/datum/job/preview_job = character_setup_preview_clothes ? character_setup_preview_job() : null
	var/datum/outfit/preview_outfit
	if(preview_job)
		preview_outfit = (cspref_gender() == FEMALE && preview_job.outfit_female) ? preview_job.outfit_female : preview_job.outfit
	character_setup_validate_smallclothes()
	var/was_sync_suppressed = character_setup_suppress_smallclothes_sync
	character_setup_suppress_smallclothes_sync = TRUE
	var/datum/customizer_entry/hover_entry
	var/hover_old_acc
	var/hover_old_colors
	var/hover_old_disabled
	var/hover_acc_path = character_setup_hover_acc ? text2path(character_setup_hover_acc) : null
	var/hover_customizer_path = character_setup_hover_customizer ? text2path(character_setup_hover_customizer) : null
	if(hover_acc_path && hover_customizer_path)
		hover_entry = get_customizer_entry_for_customizer_type(hover_customizer_path)
		if(hover_entry)
			hover_old_acc = hover_entry.accessory_type
			hover_old_colors = hover_entry.accessory_colors
			hover_old_disabled = hover_entry.disabled
			hover_entry.accessory_type = hover_acc_path
			if(character_setup_hover_color)
				hover_entry.accessory_colors = character_setup_hover_color
			hover_entry.disabled = FALSE
	body.wipe_state()
	body.smallclothes_render_suppressed = !character_setup_preview_underwear
	apply_prefs_to(body, TRUE)
	if(hover_entry)
		hover_entry.accessory_type = hover_old_acc
		hover_entry.accessory_colors = hover_old_colors
		hover_entry.disabled = hover_old_disabled
	character_setup_suppress_smallclothes_sync = was_sync_suppressed
	if(!character_setup_preview_underwear)
		body.underwear = "Nude"
		body.undershirt = "Nude"
		body.socks = "Nude"
		body.update_body_parts(TRUE)
	if(preview_job)
		body.dna.species.pre_equip_species_outfit(preview_job, body, TRUE)
	if(preview_outfit)
		body.equipOutfit(preview_outfit, TRUE)
	body.update_inv_hands(hide_experimental = TRUE)
	body.update_inv_belt(hide_experimental = TRUE)
	body.update_inv_back(hide_experimental = TRUE)
	body.update_inv_head(hide_nonstandard = TRUE)
	var/main_only = character_setup_render_main_only
	character_setup_render_main_only = FALSE
	character_setup_measure_body(character_setup_preview_dir)
	if(!main_only)
		var/list/perp_art = character_setup_measure_art(turn(character_setup_preview_dir, 90))
		var/zoom_dim_w = max(character_setup_view_bbox_w, perp_art ? perp_art[1] : 0)
		var/zoom_dim_h = max(character_setup_view_bbox_h, perp_art ? perp_art[2] : 0)
		character_setup_view_zoom_w = CEILING(zoom_dim_w, 4)
		character_setup_view_zoom_h = CEILING(zoom_dim_h, 4)
	character_setup_apply_to_view(character_setup_view, body, character_setup_preview_dir)
	if(!main_only)
		character_setup_apply_to_view(character_setup_view_front, body, SOUTH)
		character_setup_apply_to_view(character_setup_view_side, body, EAST)
	character_setup_log("VIEW", "render done main_only=[main_only] dir=[character_setup_preview_dir] flat=[character_setup_view_last_flat] feet_margin=[character_setup_view_feet_margin] underwear=[body.underwear]")

/datum/preferences/proc/character_setup_measure_art(dir)
	var/mob/living/carbon/human/dummy/body = character_setup_body
	if(!body)
		return null
	var/icon/measure = character_setup_get_flat_icon(body, dir, no_anim = TRUE)
	var/measure_w = isicon(measure) ? measure.Width() : 32
	var/measure_h = isicon(measure) ? measure.Height() : 32
	var/art_x = 0
	var/art_y = 0
	var/list/art = character_setup_art_bounds(measure)
	if(art)
		art_x = art[1] - 1
		art_y = art[2] - 1
		measure_w = art[3] - art[1] + 1
		measure_h = art[4] - art[2] + 1
	return list(measure_w, measure_h, GLOB.character_setup_flat_origin_x + art_x, GLOB.character_setup_flat_origin_y + art_y)

/datum/preferences/proc/character_setup_measure_body(dir)
	var/list/art = character_setup_measure_art(dir)
	if(!art)
		return
	character_setup_view_bbox_w = art[1]
	character_setup_view_bbox_h = art[2]
	character_setup_view_off_x = art[3]
	character_setup_view_off_y = art[4]
	character_setup_view_extent_w = max(1, CEILING(character_setup_view_bbox_w / 32, 1))
	character_setup_view_extent_h = max(1, CEILING(character_setup_view_bbox_h / 32, 1))
	character_setup_bg?.fill_rect(1, 1, character_setup_view_canvas_w, character_setup_view_canvas_h)
	character_setup_bg_front?.fill_rect(1, 1, character_setup_view_canvas_w, character_setup_view_canvas_h)
	character_setup_bg_side?.fill_rect(1, 1, character_setup_view_canvas_w, character_setup_view_canvas_h)
	if(GLOB.character_setup_debug)
		character_setup_log("VIEW", "measure dir=[dir] art=[character_setup_view_bbox_w]x[character_setup_view_bbox_h] origin=[character_setup_view_off_x],[character_setup_view_off_y] extent=[character_setup_view_extent_w]x[character_setup_view_extent_h] zoom_dims=[character_setup_view_zoom_w]x[character_setup_view_zoom_h] species=[pref_species?.id] taur=[pref_species?.forced_taur ? 1 : 0]")
		var/mob/living/carbon/human/dummy/diag_body = character_setup_body
		if(diag_body)
			var/list/slot_bits = list()
			for(var/slot in list("smallclothes_bottom", "smallclothes_top", "smallclothes_legs"))
				var/datum/bodypart_feature/smallclothes/feature = diag_body.get_bodypart_feature_of_slot(slot)
				slot_bits += "[slot]=[feature ? "[feature.accessory_type] colors=[feature.accessory_colors]" : "NONE"]"
			character_setup_log("SMALL", "[slot_bits.Join(" | ")] mob_underwear=[diag_body.underwear] mob_undershirt=[diag_body.undershirt] mob_socks=[diag_body.socks] suppressed=[diag_body.smallclothes_render_suppressed]")

/proc/character_setup_get_flat_icon(image/appearance, defdir, deficon, defstate, defblend, start = TRUE, no_anim = FALSE)
	#define CHARACTER_SETUP_PROCESS_OVERLAYS_OR_UNDERLAYS(flat, process, base_layer) \
		for (var/i in 1 to length(process)) { \
			var/image/current = process[i]; \
			if (!current) { \
				continue; \
			} \
			if (current.plane != FLOAT_PLANE && current.plane != appearance.plane) { \
				continue; \
			} \
			var/current_layer = current.layer; \
			if (current_layer < 0) { \
				if (current_layer <= -1000) { \
					return flat; \
				} \
				current_layer = base_layer + appearance.layer + current_layer / 1000; \
			} \
			for (var/index_to_compare_to in 1 to length(layers)) { \
				var/compare_to = layers[index_to_compare_to]; \
				if (current_layer < layers[compare_to]) { \
					layers.Insert(index_to_compare_to, current); \
					break; \
				} \
			} \
			layers[current] = current_layer; \
		}

	var/static/icon/flat_template = icon('icons/blanks/32x32.dmi', "nothing")
	var/icon/flat = icon(flat_template)

	if(!appearance || appearance.alpha <= 0)
		return flat

	if(start)
		GLOB.character_setup_flat_origin_x = 0
		GLOB.character_setup_flat_origin_y = 0
		if(!defdir)
			defdir = appearance.dir
		if(!deficon)
			deficon = appearance.icon
		if(!defstate)
			defstate = appearance.icon_state
		if(!defblend)
			defblend = appearance.blend_mode

	var/curicon = appearance.icon || deficon
	var/curstate = appearance.icon_state || defstate
	var/curdir = (!appearance.dir || appearance.dir == SOUTH) ? defdir : appearance.dir

	var/render_icon = curicon

	if(render_icon)
		if(!icon_exists(curicon, curstate))
			if(icon_exists(curicon, ""))
				curstate = ""
			else
				render_icon = FALSE

	var/base_icon_dir

	if(render_icon)
		if (curdir != SOUTH)
			if(!length(icon_states(icon(curicon, curstate, NORTH))))
				base_icon_dir = SOUTH

		var/list/icon_dimensions = get_icon_dimensions(curicon)
		var/icon_width = icon_dimensions["width"]
		var/icon_height = icon_dimensions["height"]
		if(icon_width != 32 || icon_height != 32)
			flat.Scale(icon_width, icon_height)

	if(!base_icon_dir)
		base_icon_dir = curdir

	var/curblend = appearance.blend_mode || defblend

	if(length(appearance.overlays) || length(appearance.underlays))
		var/list/layers = list()
		var/image/copy
		if(render_icon)
			copy = image(icon=curicon, icon_state=curstate, layer=appearance.layer, dir=base_icon_dir)
			copy.color = appearance.color
			copy.alpha = appearance.alpha
			copy.blend_mode = curblend
			layers[copy] = appearance.layer

		CHARACTER_SETUP_PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.underlays, 0)
		CHARACTER_SETUP_PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.overlays, 1)

		var/icon/add

		var/flatX1 = 1
		var/flatX2 = flat.Width()
		var/flatY1 = 1
		var/flatY2 = flat.Height()

		var/addX1 = 0
		var/addX2 = 0
		var/addY1 = 0
		var/addY2 = 0

		for(var/image/layer_image as anything in layers)
			if(layer_image.alpha == 0)
				continue

			if(layer_image == copy)
				curblend = BLEND_OVERLAY
				add = icon(layer_image.icon, layer_image.icon_state, base_icon_dir)
			else
				add = character_setup_get_flat_icon(image(layer_image), curdir, curicon, curstate, curblend, FALSE, no_anim)
			if(!add)
				continue

			addX1 = min(flatX1, layer_image.pixel_x + 1)
			addX2 = max(flatX2, layer_image.pixel_x + add.Width())
			addY1 = min(flatY1, layer_image.pixel_y + 1)
			addY2 = max(flatY2, layer_image.pixel_y + add.Height())

			if (
				addX1 != flatX1 \
				|| addX2 != flatX2 \
				|| addY1 != flatY1 \
				|| addY2 != flatY2 \
			)
				flat.Crop(
					addX1 - flatX1 + 1,
					addY1 - flatY1 + 1,
					addX2 - flatX1 + 1,
					addY2 - flatY1 + 1
				)

				flatX1 = addX1
				flatX2 = addX2
				flatY1 = addY1
				flatY2 = addY2

			flat.Blend(add, blendMode2iconMode(curblend), layer_image.pixel_x + 2 - flatX1, layer_image.pixel_y + 2 - flatY1)

		if(appearance.color)
			if(islist(appearance.color))
				flat.MapColors(arglist(appearance.color))
			else
				flat.Blend(appearance.color, ICON_MULTIPLY)

		if(appearance.alpha < 255)
			flat.Blend(rgb(255, 255, 255, appearance.alpha), ICON_MULTIPLY)

		if(start)
			GLOB.character_setup_flat_origin_x = flatX1 - 1
			GLOB.character_setup_flat_origin_y = flatY1 - 1

		if(no_anim)
			var/icon/cleaned = new /icon()
			cleaned.Insert(flat, "", SOUTH, 1, 0)
			return cleaned
		else
			return icon(flat, "", SOUTH)
	else if (render_icon)
		var/icon/final_icon = icon(icon(curicon, curstate, base_icon_dir), "", SOUTH, no_anim ? TRUE : null)

		if (appearance.alpha < 255)
			final_icon.Blend(rgb(255,255,255, appearance.alpha), ICON_MULTIPLY)

		if (appearance.color)
			if (islist(appearance.color))
				final_icon.MapColors(arglist(appearance.color))
			else
				final_icon.Blend(appearance.color, ICON_MULTIPLY)

		return final_icon

	#undef CHARACTER_SETUP_PROCESS_OVERLAYS_OR_UNDERLAYS

/datum/preferences/proc/character_setup_apply_to_view(atom/movable/screen/map_view/view, mob/living/carbon/human/dummy/body, view_dir)
	if(!view)
		return
	view.appearance = body.appearance
	view.setDir(view_dir)
	view.plane = GAME_PLANE
	view.layer = GAME_PLANE
	view.pixel_x = 0
	view.pixel_y = 0
	view.pixel_z = 0
	view.pixel_w = 0
	view.maptext = null
	view.appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
	view.transform = null
	var/anchor_px = round(character_setup_view_canvas_cx - character_setup_view_bbox_w / 2) - character_setup_view_off_x + character_setup_view_doll_px
	var/anchor_py = round(character_setup_view_canvas_cy - character_setup_view_bbox_h / 2) - character_setup_view_off_y + character_setup_view_doll_py
	view.set_position(character_setup_view_doll_x, character_setup_view_doll_y, anchor_px, anchor_py)
	if(GLOB.character_setup_debug)
		character_setup_log("VIEW", "apply map=[view.assigned_map] dir=[view_dir] bbox=[character_setup_view_bbox_w]x[character_setup_view_bbox_h] extent=[character_setup_view_extent_w]x[character_setup_view_extent_h] screen_loc=[view.screen_loc] base_icon=[body.icon] overlays=[length(view.overlays)] appearance_flags=[view.appearance_flags] view_dir=[view.dir]")
	character_setup_view_last_flat = "appearance dir=[view_dir] bbox=[character_setup_view_bbox_w]x[character_setup_view_bbox_h] extent=[character_setup_view_extent_w]x[character_setup_view_extent_h] overlays=[length(view.overlays)] view_dir=[view.dir]"

/datum/preferences/proc/character_setup_current_view_scale()
	if(pref_species?.forced_taur && LAZYLEN(pref_species.allowed_taur_types))
		return max(1, round(character_setup_view_scale * 0.55))
	return character_setup_view_scale

/datum/preferences/proc/character_setup_background_options()
	return list(
		list("name" = "None", "value" = "none"),
		list("name" = "White", "value" = "white"),
		list("name" = "Dark", "value" = "dark"),
	)

/datum/preferences/proc/character_setup_chargen_clean_text(text, limit = 900)
	if(!text)
		return ""
	return trim(STRIP_HTML_FULL(replacetext("[text]", "\n", " "), limit))

/datum/preferences/proc/character_setup_patron_options_for_faith(faith_type)
	. = list()
	var/list/patrons = GLOB.patrons_by_faith[faith_type]
	if(!length(patrons))
		return

	var/datum/patron/current_patron = cspref_selected_patron()
	var/current_patron_type = current_patron?.type
	for(var/patron_type in patrons)
		var/datum/patron/patron = GLOB.patron_list[patron_type]
		if(!patron)
			continue
		var/available = patron.preference_accessible(src)
		var/patron_name = patron.display_name ? patron.display_name : patron.name
		. += list(list(
			"id" = "[patron_type]",
			"name" = patron_name,
			"domain" = patron.domain || "",
			"description" = character_setup_chargen_clean_text(patron.desc, 700),
			"flaws" = patron.flaws || "",
			"worshippers" = patron.worshippers || "",
			"sins" = patron.sins || "",
			"boons" = patron.boons || "",
			"available" = available,
			"selected" = current_patron_type == patron_type,
		))

/datum/preferences/proc/character_setup_faith_options()
	. = list()
	var/datum/patron/current_patron = cspref_selected_patron()
	var/current_faith = current_patron ? current_patron.associated_faith : /datum/patron/divine/astrata::associated_faith
	for(var/faith_type in GLOB.faith_list)
		var/datum/faith/faith = GLOB.faith_list[faith_type]
		if(!faith)
			continue
		var/list/patrons = character_setup_patron_options_for_faith(faith_type)
		var/available = faith.preference_accessible(src)
		if(!available && !length(patrons))
			continue
		. += list(list(
			"id" = "[faith_type]",
			"name" = faith.name || "[faith_type]",
			"description" = character_setup_chargen_clean_text(faith.desc, 700),
			"available" = available,
			"selected" = faith_type == current_faith,
			"patrons" = patrons,
		))

/datum/preferences/proc/character_setup_current_ancestry_name()
	if(!pref_species)
		return "None"
	var/list/skins = pref_species.get_skin_list()
	for(var/skin_name in skins)
		if(skins[skin_name] == cspref_skin_tone())
			return "[skin_name]"
	return "None"

/datum/preferences/proc/character_setup_ancestry_options()
	. = list()
	if(!pref_species)
		return
	var/list/skins = pref_species.get_skin_list()
	for(var/skin_name in skins)
		var/skin_value = skins[skin_name]
		. += list(list(
			"name" = "[skin_name]",
			"value" = "[skin_name]",
			"color" = "[skin_value]",
			"selected" = skin_value == cspref_skin_tone(),
		))

/datum/preferences/proc/character_setup_apply_patron(mob/user, patron_id)
	if(!user || !patron_id)
		return TRUE
	var/patron_type = text2path(patron_id)
	var/datum/patron/patron = GLOB.patron_list[patron_type]
	if(!patron)
		return TRUE
	if(!patron.preference_accessible(src))
		to_chat(user, span_warning("[patron.display_name || patron.name] is not available for this character."))
		return TRUE

	cspref_set_selected_patron(patron_type)
	var/datum/patron/selected_patron = cspref_selected_patron()
	if(selected_patron.associated_faith)
		write_preference(/datum/preference/choiced/faith, selected_patron.associated_faith)
	to_chat(user, "<font color='purple'>Patron: [selected_patron.name]</font>")
	to_chat(user, "<font color='purple'>Domain: [selected_patron.domain]</font>")
	to_chat(user, "<font color='purple'>Background: [selected_patron.desc]</font>")
	to_chat(user, "<font color='purple'>Flawed aspects: [selected_patron.flaws]</font>")
	to_chat(user, "<font color='purple'>Likely Worshippers: [selected_patron.worshippers]</font>")
	to_chat(user, "<font color='red'>Considers these to be Sins: [selected_patron.sins]</font>")
	to_chat(user, "<font color='white'>Blessed with boon(s): [selected_patron.boons]</font>")
	save_character()
	character_setup_log("MUTATE", "apply_patron [patron_id] -> [selected_patron.name] faith=[selected_patron.associated_faith]")
	update_menu_data(user)
	return TRUE

/datum/preferences/proc/character_setup_apply_faith(mob/user, faith_id)
	if(!user || !faith_id)
		return TRUE
	var/faith_type = text2path(faith_id)
	var/datum/faith/faith = GLOB.faith_list[faith_type]
	if(!faith)
		return TRUE
	if(!faith.preference_accessible(src))
		to_chat(user, span_warning("[faith.name] is not available for this character."))
		return TRUE

	var/patron_type = faith.godhead
	var/datum/patron/patron = patron_type ? GLOB.patron_list[patron_type] : null
	if(!patron || !patron.preference_accessible(src))
		for(var/candidate_type in GLOB.patrons_by_faith[faith_type])
			var/datum/patron/candidate = GLOB.patron_list[candidate_type]
			if(candidate && candidate.preference_accessible(src))
				patron_type = candidate_type
				break
	if(!patron_type)
		return TRUE

	cspref_set_selected_patron(patron_type)
	write_preference(/datum/preference/choiced/faith, faith_type)
	to_chat(user, "<font color='purple'>Faith: [faith.name]</font>")
	to_chat(user, "<font color='purple'>Background: [faith.desc]</font>")
	save_character()
	character_setup_log("MUTATE", "apply_faith [faith_id] patron=[patron_type]")
	update_menu_data(user)
	return TRUE

/datum/preferences/proc/character_setup_apply_ancestry(mob/user, ancestry_name)
	if(!user || !pref_species || !ancestry_name)
		return TRUE
	var/list/skins = pref_species.get_skin_list()
	if(!(ancestry_name in skins))
		return TRUE
	var/new_skin_tone = skins[ancestry_name]
	if(cspref_skin_tone() != new_skin_tone)
		cspref_set_skin_tone(new_skin_tone)
		character_setup_log("MUTATE", "apply_ancestry [ancestry_name] tone=[new_skin_tone]")
		save_character()
		update_menu_data(user)
	return TRUE

/datum/preferences/proc/character_setup_send_ooc(mob/user, message)
	if(!user?.client || !istext(message))
		return TRUE
	message = trim(message)
	if(!length(message))
		return TRUE
	if(istype(user, /mob/dead/new_player))
		user.client.lobbyooc(message)
	else
		user.client.ooc(message)
	character_setup_log("OOC", "send_ooc user=[user?.ckey] len=[length(message)]")
	character_setup_push_all_prefs()
	return TRUE

/datum/preferences/ui_data(mob/user)
	var/_t = world.timeofday
	var/list/data = list()

	data["lang"] = ui_lang_code(user?.client)

	var/datum/faith/selected_faith
	var/datum/patron/current_patron = cspref_selected_patron()
	if(current_patron)
		selected_faith = GLOB.faith_list[current_patron.associated_faith]

	var/high_job = "None"
	for(var/job_type in job_preferences)
		if(job_preferences[job_type] != JP_HIGH)
			continue
		high_job = "[job_type]"
		break

	var/gender_name = "Other"
	var/gender_short = "X"
	switch(cspref_gender())
		if(MALE)
			gender_name = "Masculine"
			gender_short = "M"
		if(FEMALE)
			gender_name = "Feminine"
			gender_short = "F"
		if(PLURAL)
			gender_name = "Plural"
			gender_short = "P"

	var/patron_name = "None"
	if(current_patron)
		patron_name = current_patron.display_name ? current_patron.display_name : current_patron.name
	var/current_faith_type = current_patron ? current_patron.associated_faith : /datum/patron/divine/astrata::associated_faith

	var/heavy_sig = "[pref_species?.type]|[cspref_gender()]|[current_patron?.type]|[cspref_age()]|[cspref_skin_tone()]|[erp_enabled]"
	var/heavy_rebuilt = (!character_setup_ui_heavy_cache || character_setup_ui_heavy_sig != heavy_sig)
	if(heavy_rebuilt)
		var/list/heavy = list()

		var/list/selectable_ages = character_setup_selectable_ages()
		var/list/age_options = list()
		var/age_index = 1
		if(length(selectable_ages))
			var/current_index = 1
			for(var/possible_age in selectable_ages)
				age_options += "[possible_age]"
				if(possible_age == cspref_age())
					age_index = current_index
				current_index++
		else
			age_options += "[cspref_age() || AGE_ADULT]"
		var/display_age = cspref_age()
		if(length(selectable_ages) && !(display_age in selectable_ages))
			display_age = selectable_ages[1]
		var/list/age_tooltips = list()
		for(var/age_option in age_options)
			age_tooltips["[age_option]"] = character_setup_age_stat_tooltip(age_option)

		heavy["age_options"] = age_options
		heavy["age_index"] = age_index
		heavy["display_age"] = display_age
		heavy["age_tooltips"] = age_tooltips
		heavy["faith_options"] = character_setup_faith_options()
		heavy["ancestry_options"] = character_setup_ancestry_options()
		heavy["features"] = character_setup_build_features_data()
		character_setup_ui_heavy_cache = heavy
		character_setup_ui_heavy_sig = heavy_sig
	var/list/heavy_cache = character_setup_ui_heavy_cache
	var/list/age_options = heavy_cache["age_options"]
	var/age_index = heavy_cache["age_index"]
	var/display_age = heavy_cache["display_age"]
	var/list/age_tooltips = heavy_cache["age_tooltips"]

	var/list/loadout_slots = list()
	for(var/slot_number in 1 to 3)
		var/loadout_name = "None"
		var/loadout_ref = _get_loadout_slot(slot_number)
		if(loadout_ref)
			var/loadout_path = istext(loadout_ref) ? text2path(loadout_ref) : loadout_ref
			var/datum/loadout_item/loadout_item = GLOB.loadout_items[loadout_path]
			if(loadout_item)
				loadout_name = loadout_item.name
		loadout_slots += list(list(
			"slot" = slot_number,
			"name" = loadout_name,
		))

	data["real_name"] = cspref_real_name() || "Unnamed"
	data["initial_tab"] = character_setup_preferences_initial_tab
	data["open_sequence"] = character_setup_preferences_open_sequence
	data["tgui_theme"] = character_setup_tgui_theme
	data["preferences_fullscreen"] = !!character_setup_preferences_fullscreen
	data["preferences_scale"] = character_setup_preferences_scale
	data["species_name"] = pref_species ? pref_species.name : "Human"
	data["species_id"] = pref_species ? pref_species.id : SPEC_ID_HUMEN
	data["gender"] = gender_name
	data["gender_short"] = gender_short
	data["default_slot"] = default_slot

	data["patron_name"] = patron_name
	data["faith_name"] = selected_faith ? selected_faith.name : "None"
	data["selected_patron_id"] = current_patron ? "[current_patron.type]" : ""
	data["selected_faith_id"] = current_faith_type ? "[current_faith_type]" : ""
	data["faith_options"] = heavy_cache["faith_options"]
	data["high_job"] = high_job
	data["age"] = display_age
	data["age_index"] = age_index
	data["age_min"] = 1
	data["age_max"] = max(1, length(age_options))
	data["age_options"] = age_options
	data["age_tooltips"] = age_tooltips
	data["pronouns"] = cspref_pronouns() || "None"
	data["domhand"] = (cspref_domhand() == 1) ? "Left" : "Right"
	data["ancestry_label"] = pref_species?.skin_tone_wording || "Ancestry"
	data["ancestry_value"] = character_setup_current_ancestry_name()
	data["ancestry_options"] = heavy_cache["ancestry_options"]

	data["erp_enabled"] = !!erp_enabled
	data["headshot"] = is_valid_headshot_link(null, cspref_headshot_link(), TRUE) ? cspref_headshot_link() : null
	data["features"] = heavy_cache["features"]
	data["preview_underwear"] = !!character_setup_preview_underwear
	data["preview_clothes"] = !!character_setup_preview_clothes
	data["preview_dir"] = character_setup_preview_dir
	data["background"] = character_setup_preview_background ? character_setup_preview_background : "none"
	data["preview_map"] = character_setup_view ? character_setup_view.assigned_map : null
	data["preview_map_front"] = character_setup_view_front ? character_setup_view_front.assigned_map : null
	data["preview_map_side"] = character_setup_view_side ? character_setup_view_side.assigned_map : null
	data["preview_bbox_w"] = character_setup_view_zoom_w
	data["preview_bbox_h"] = character_setup_view_zoom_h

	var/datum/culture/pref_culture = cspref_culture()
	data["culture_name"] = pref_culture ? pref_culture::name : "None"
	data["voice_type"] = cspref_voice_type() || "Default"
	data["voice_color"] = cspref_voice_color() ? "#[cspref_voice_color()]" : "#a0a0a0"
	data["selected_accent"] = cspref_selected_accent() || "None"
	data["family"] = cspref_family() || "None"
	data["gender_pref"] = cspref_gender_choice() || "Any"
	data["spouse"] = cspref_setspouse() || "None"

	data["loadouts"] = loadout_slots
	data["triumphs"] = triumphs
	data["special_role"] = next_special_trait ? "[next_special_trait]" : "None"
	var/mob/dead/new_player/new_player
	if(istype(user, /mob/dead/new_player))
		new_player = user
	var/list/ooc_messages = list()
	for(var/list/ooc_entry as anything in GLOB.character_setup_chargen_ooc_messages)
		if(ooc_entry["lobby"] && !user?.client?.holder && SSticker?.current_state != GAME_STATE_FINISHED && !new_player)
			continue
		ooc_messages += list(ooc_entry)
	data["ooc_messages"] = ooc_messages
	data["round_player_ready"] = new_player?.ready == PLAYER_READY_TO_PLAY
	data["round_action_label"] = "Unavailable"
	data["round_action_icon"] = "ban"
	data["round_action_color"] = null
	data["round_action_disabled"] = TRUE
	data["round_action_tooltip"] = "This action is only available in the lobby."
	if(SSticker)
		var/time_remaining = SSticker.GetTimeLeft()
		if(SSticker.HasRoundStarted())
			data["round_start_status"] = "Round Started"
			data["round_start_seconds"] = 0
		else if(SSticker.current_state == GAME_STATE_SETTING_UP)
			data["round_start_status"] = "Setting Up"
			data["round_start_seconds"] = 0
		else if(time_remaining > 0)
			data["round_start_status"] = "Starts In"
			data["round_start_seconds"] = max(0, round(time_remaining / 10))
		else if(time_remaining == -10)
			data["round_start_status"] = "Delayed"
			data["round_start_seconds"] = -1
		else
			data["round_start_status"] = "Starting Soon"
			data["round_start_seconds"] = 0
		data["round_ready_players"] = SSticker.totalPlayersReady
		data["round_total_players"] = SSticker.totalPlayers
		if(new_player)
			if(SSticker.IsRoundInProgress())
				data["round_action_label"] = "Join Now"
				data["round_action_icon"] = "sign-in-alt"
				data["round_action_color"] = "green"
				data["round_action_disabled"] = FALSE
				data["round_action_tooltip"] = "Open late join choices."
			else if(SSticker.current_state <= GAME_STATE_PREGAME)
				if(new_player.ready == PLAYER_READY_TO_PLAY)
					data["round_action_label"] = "Cancel Ready"
					data["round_action_icon"] = "times"
					data["round_action_color"] = "bad"
					data["round_action_disabled"] = !!SSticker.job_change_locked
					data["round_action_tooltip"] = "Cancel roundstart readiness."
				else
					data["round_action_label"] = "Ready"
					data["round_action_icon"] = "user-check"
					data["round_action_color"] = "green"
					data["round_action_disabled"] = FALSE
					data["round_action_tooltip"] = "Ready this character for roundstart."
			else if(SSticker.current_state == GAME_STATE_SETTING_UP)
				data["round_action_label"] = "Setting Up"
				data["round_action_icon"] = "hourglass-half"
				data["round_action_tooltip"] = "The game is starting."
			else
				data["round_action_label"] = "Round Finished"
				data["round_action_icon"] = "flag-checkered"
				data["round_action_tooltip"] = "The round has already finished."
	else
		data["round_start_status"] = "Unknown"
		data["round_start_seconds"] = -1
		data["round_ready_players"] = 0
		data["round_total_players"] = 0
	var/pq_raw = user?.ckey ? get_playerquality(user.ckey, text = TRUE) : "Unknown"
	var/regex/pq_tags = new(@"<[^>]*>", "g")
	var/regex/pq_color = new(@"color:\s*(#[0-9a-fA-F]+)")
	data["player_quality"] = pq_tags.Replace(pq_raw, "")
	data["player_quality_color"] = pq_color.Find(pq_raw) ? pq_color.group[1] : null

	data["game_prefs"] = list(
		"hotkeys" = !!cspref_hotkeys(),
		"buttons_locked" = !!cspref_buttons_locked(),
		"see_chat_non_mob" = !!cspref_see_chat_non_mob(),
		"tgui_fancy" = !!cspref_tgui_fancy(),
		"tgui_lock" = !!cspref_tgui_lock(),
		"windowflashing" = !!cspref_windowflashing(),
		"lobby_music" = !!(cspref_toggles() & SOUND_LOBBY),
		"hear_midis" = !!(cspref_toggles() & SOUND_MIDI),
		"ambientocclusion" = !!cspref_ambientocclusion(),
		"auto_fit_viewport" = !!cspref_auto_fit_viewport(),
		"widescreenpref" = !!cspref_widescreenpref(),
		"allow_midround_antag" = !!(cspref_toggles() & MIDROUND_ANTAG),
		"pixel_size" = "[cspref_pixel_size()]",
		"scaling_method" = "[cspref_scaling_method()]",
		"language" = "[cspref_language()]",
	)

	character_setup_log_op("ui_data", _t, "keys=[length(data)] heavy_rebuilt=[heavy_rebuilt] species=[pref_species?.id] dir=[character_setup_preview_dir]")
	return data

/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui?.user || usr
	if(!user)
		return FALSE

	character_setup_log("ACT", "ui_act action=[action] pref=[islist(params) ? params["preference"] : "?"]")
	switch(action)
		if("pref")
			if(!islist(params) || !params["preference"])
				return FALSE

			var/list/href_list = list()
			for(var/key in params)
				href_list[key] = params[key]

			if(href_list["preference"] == "tab")
				current_tab = text2num("[href_list["tab"]]")
				return TRUE

			var/handled = process_link(user, href_list)
			if(href_list["preference"] == "finished")
				ui?.close(FALSE)
			return handled || TRUE

		if("set_age")
			if(!islist(params))
				return FALSE

			var/new_age = params["value"]
			if(!isnum(new_age))
				new_age = text2num("[new_age]")
			if(!isnum(new_age))
				return FALSE

			var/list/selectable_ages = character_setup_selectable_ages()
			if(!length(selectable_ages))
				return FALSE

			var/age_index = clamp(round(new_age), 1, length(selectable_ages))
			var/selected_age = selectable_ages[age_index]
			if(cspref_age() != selected_age)
				cspref_set_age(selected_age)
				reset_jobs(user)
			return TRUE

	return FALSE

/datum/preferences/proc/character_setup_link_pref(mob/user, key)
	var/datum/preference/pref = GLOB.preference_entries_by_key[key]
	if(pref)
		pref.handle_link(src, user)
	return TRUE

/datum/preferences/proc/character_setup_handle_system_action(mob/user, list/href_list)
	character_setup_log("DISPATCH", "system/core fallthrough pref=[href_list["preference"]]")
	switch(href_list["preference"])
		if("save")
			to_chat(user, span_info("Preferences Saved."))
			save_preferences()
			save_character()
			if(isnewplayer(user))
				var/mob/dead/new_player/player = user
				player.cache_multi_ready_characters()
			return TRUE
		if("finished")
			save_character()
			return TRUE
		if("load")
			load_preferences()
			load_character()
			if(isnewplayer(user))
				var/mob/dead/new_player/player = user
				player.cache_multi_ready_characters()
			update_menu_data(user)
			return TRUE
		if("changeslot")
			var/list/choices = list()
			if(path)
				var/savefile/slot_file = new /savefile(path)
				if(slot_file)
					for(var/i in 1 to max_save_slots)
						var/slot_name
						slot_file.cd = "/character[i]"
						slot_file["real_name"] >> slot_name
						choices[slot_name || "Slot[i]"] = i
			var/choice = input(user, "WHO IS YOUR HERO?", "NECRA AWAITS") as null|anything in choices
			if(choice)
				load_character(choices[choice])
				update_menu_data(user)
			return TRUE
		if("name")
			return character_setup_link_pref(user, "real_name")
		if("voice")
			return character_setup_link_pref(user, "voice_color")
		if("voicetype")
			return character_setup_link_pref(user, "voice_type")
		if("headshot")
			return character_setup_link_pref(user, "headshot_link")
		if("loadout_item")
			open_loadout_shop(user)
			return TRUE
		if("donor_loadout")
			open_donor_loadout(user)
			return TRUE
		if("select_quirks")
			open_quirk_menu(user)
			return TRUE
		if("randomiseappearanceprefs")
			randomise_appearance_prefs()
			customizer_entries = list()
			validate_customizer_entries()
			reset_all_customizer_accessory_colors()
			randomize_all_customizer_accessories()
			reset_jobs(user)
			update_menu_data(user)
			return TRUE
	return FALSE

/datum/preferences/process_link(mob/user, list/href_list)
	character_setup_log_action("pref:[href_list["preference"]]", json_encode(href_list))
	switch(href_list["preference"])
		if("character_setup_select_species")
			return character_setup_apply_species(user, href_list["species_id"])
		if("character_setup_select_faith")
			return character_setup_apply_faith(user, href_list["faith_id"])
		if("character_setup_select_patron")
			return character_setup_apply_patron(user, href_list["patron_id"])
		if("character_setup_select_ancestry")
			return character_setup_apply_ancestry(user, href_list["ancestry"])
		if("character_setup_send_ooc")
			return character_setup_send_ooc(user, href_list["message"])
		if("character_setup_round_action")
			return character_setup_round_action(user)
		if("character_setup_preferences_fullscreen")
			character_setup_preferences_fullscreen = !character_setup_preferences_fullscreen
			character_setup_log("WINDOW", "fullscreen=[character_setup_preferences_fullscreen]")
			SStgui.update_uis(src)
			return TRUE
		if("character_setup_preferences_scale")
			character_setup_preferences_scale = character_setup_sanitize_preferences_scale(href_list["scale"])
			character_setup_log("WINDOW", "menu_scale=[character_setup_preferences_scale]")
			save_preferences()
			return TRUE
		if("character_setup_report_geometry")
			character_setup_log("GEOMETRY", "main=[href_list["main_w"]]x[href_list["main_h"]] front=[href_list["front_w"]]x[href_list["front_h"]] side=[href_list["side_w"]]x[href_list["side_h"]] window=[href_list["win_w"]]x[href_list["win_h"]] dpr=[href_list["dpr"]] menu_scale=[href_list["menu_scale"]] zoom_main=[href_list["zoom_main"]] zoom_mini=[href_list["zoom_mini"]] bbox=[href_list["bbox"]]")
			character_setup_apply_reported_zoom(user, text2num(href_list["zoom_main"]), text2num(href_list["zoom_mini"]))
			return TRUE
		if("character_setup_customizer")
			validate_customizer_entries()
			var/customizer_type = text2path(href_list["customizer"])
			if(!character_setup_handle_color_task(user, href_list))
				handle_customizer_topic(user, href_list)
			if(customizer_type in GLOB.character_setup_smallclothes_customizers)
				character_setup_sync_smallclothes_from_entries()
				save_character()
			update_menu_data(user)
			return TRUE
		if("character_setup_set_choice")
			var/customizer_type = text2path(href_list["key"])
			var/choice_type = text2path(href_list["choice_type"])
			if(!customizer_type || !choice_type)
				return TRUE
			var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
			var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
			if(!entry || !customizer)
				return TRUE
			if(!(choice_type in customizer.customizer_choices) || choice_type == entry.customizer_choice_type)
				return TRUE
			customizer_entries -= entry
			customizer_entries += customizer.create_customizer_entry(src, choice_type)
			update_menu_data(user)
			return TRUE
		if("character_setup_erp_toggle")
			erp_enabled = !erp_enabled
			save_character()
			var/mob/living/carbon/human/H = user
			if(istype(H))
				H.erp_on_spawn_setup()
			to_chat(user, span_notice("Intimacy opt-in [erp_enabled ? "enabled" : "disabled"] for this character (saved to slot)."))
			update_menu_data(user)
			return TRUE
		if("character_setup_erp_panel")
			var/mob/living/carbon/human/H = user
			if(!istype(H) || !erp_enabled)
				to_chat(user, span_warning("Enable the intimacy opt-in first, in a living body."))
				return TRUE
			H.start_erp_session(H)
			return TRUE
		if("character_setup_preview_layer")
			switch(href_list["layer"])
				if("underwear")
					character_setup_preview_underwear = !character_setup_preview_underwear
				if("clothes")
					character_setup_preview_clothes = !character_setup_preview_clothes
			update_menu_data(user)
			return TRUE
		if("gender")
			cspref_set_gender((cspref_gender() == MALE) ? FEMALE : MALE)
			character_setup_validate_smallclothes()
			save_character()
			update_menu_data(user)
			return TRUE
		if("character_setup_preview_rotate")
			var/list/dir_cycle = list(SOUTH, WEST, NORTH, EAST)
			var/idx = dir_cycle.Find(character_setup_preview_dir)
			if(!idx)
				idx = 1
			if(href_list["rotate"] == "left")
				idx = (idx <= 1) ? length(dir_cycle) : (idx - 1)
			else
				idx = (idx >= length(dir_cycle)) ? 1 : (idx + 1)
			character_setup_preview_dir = dir_cycle[idx]
			if(character_setup_view && character_setup_body)
				character_setup_measure_body(character_setup_preview_dir)
				character_setup_apply_to_view(character_setup_view, character_setup_body, character_setup_preview_dir)
			if(GLOB.character_setup_debug)
				character_setup_log("VIEW", "rotate main dir=[character_setup_preview_dir] view=[character_setup_view?.assigned_map] view_dir=[character_setup_view?.dir]")
			return TRUE
		if("character_setup_preview_background")
			var/bg_choice = href_list["bg"]
			if(bg_choice == "none")
				character_setup_preview_background = null
			else
				character_setup_preview_background = bg_choice
			character_setup_apply_map_background(user)
			save_character()
			update_menu_data(user)
			return TRUE
		if("species")
			var/saved_age = cspref_age()
			var/saved_name = cspref_real_name()
			..()
			var/list/selectable_ages = character_setup_species_display_ages(pref_species)
			if(saved_age && (saved_age in selectable_ages))
				cspref_set_age(saved_age)
			else if(length(selectable_ages))
				cspref_set_age(selectable_ages[1])
			if(saved_name)
				cspref_set_real_name(saved_name)
			character_setup_validate_smallclothes()
			update_menu_data(user)
			return TRUE
		if("character_setup_tgui_theme")
			var/new_theme = href_list["theme"]
			if(new_theme)
				character_setup_tgui_theme = new_theme
				save_preferences()
				SStgui.update_uis(src)
			return TRUE
		if("character_setup_hover")
			var/new_acc = href_list["acc"]
			var/new_customizer = href_list["customizer"]
			if(!new_acc || !new_customizer)
				if(!character_setup_hover_acc)
					return TRUE
				character_setup_hover_acc = null
				character_setup_hover_color = null
				character_setup_hover_customizer = null
				character_setup_render_main_only = TRUE
				character_setup_update_view()
				return TRUE
			if(new_acc == character_setup_hover_acc && href_list["color"] == character_setup_hover_color && new_customizer == character_setup_hover_customizer)
				return TRUE
			if(!text2path(new_acc) || !text2path(new_customizer))
				return TRUE
			character_setup_hover_acc = new_acc
			character_setup_hover_color = href_list["color"]
			character_setup_hover_customizer = new_customizer
			character_setup_render_main_only = TRUE
			character_setup_update_view()
			return TRUE
	if(character_setup_handle_system_action(user, href_list))
		return TRUE
	. = ..()
	update_menu_data(user)
	return .
