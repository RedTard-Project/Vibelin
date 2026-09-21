#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)

/datum/unit_test/modular_loadout_panel/Run()
	var/list/seen_names = list()
	var/list/seen_sprite_ids = list()
	var/azure_entries = 0

	for(var/path in GLOB.loadout_items)
		var/datum/loadout_item/entry = GLOB.loadout_items[path]
		var/atom/entry_item = entry.item_path
		if(!entry_item)
			continue
		var/is_ours = findtext("[entry.ui_icon]", "modular_abel")
		if(initial(entry_item.abstract_type) == entry.item_path)
			if(is_ours)
				TEST_FAIL("[entry.type] points at abstract type [entry.item_path]")
			else
				TEST_NOTICE(src, "upstream [entry.type] points at abstract type [entry.item_path]; taking it from the panel spawns an abstract atom")
		if(!entry.ui_category)
			TEST_FAIL("[entry.type] has no ui_category, so no tab can reach it")

		if(seen_names[entry.name])
			TEST_FAIL("[entry.type] reuses the loadout name \"[entry.name]\", already held by [seen_names[entry.name]]")
		else
			seen_names[entry.name] = entry.type

		var/sprite_id = sanitize_css_class_name("[entry.item_path]")
		if(seen_sprite_ids[sprite_id])
			TEST_FAIL("[entry.type] and [seen_sprite_ids[sprite_id]] collapse to spritesheet id \"[sprite_id]\", so one of them renders the other's sprite")
		else
			seen_sprite_ids[sprite_id] = entry.type

		if(entry.ui_category == LOADOUT_PANEL_CATEGORY_AZURE)
			azure_entries++

		if(entry.loadout_flags & LOADOUT_FLAG_NO_EQUIP)
			continue
		if(!is_ours)
			continue
		if(!entry.ui_icon || !entry.ui_icon_state)
			TEST_FAIL("[entry.type] resolved no ui_icon/ui_icon_state, so its panel tile renders blank")
			continue
		if(!icon_exists(entry.ui_icon, entry.ui_icon_state))
			TEST_FAIL("[entry.type] ui_icon_state \"[entry.ui_icon_state]\" is missing from [entry.ui_icon]")

	if(!azure_entries)
		TEST_FAIL("the [LOADOUT_PANEL_CATEGORY_AZURE] tab has no entries, so it will not appear in the panel")

/datum/unit_test/modular_loadout_roundtrip/Run()
	var/datum/loadout_panel/panel = new(null)
	var/list/categories = panel.build_categories(null)
	var/list/every_entry = categories[LOADOUT_PANEL_CATEGORY_ALL]
	qdel(panel)

	if(!length(every_entry))
		TEST_FAIL("the panel built no entries at all")
		return
	for(var/list/entry as anything in every_entry)
		var/resolved = text2path(entry["path"])
		if(!GLOB.loadout_items[resolved])
			TEST_FAIL("panel entry \"[entry["name"]]\" sends path \"[entry["path"]]\", which is not a key of GLOB.loadout_items, so add and remove silently do nothing")
			continue
		var/expected_id = sanitize_css_class_name("[resolved]")
		if(!findtext(entry["iconClass"], expected_id))
			TEST_FAIL("panel entry \"[entry["name"]]\" advertises class \"[entry["iconClass"]]\" but the spritesheet stores it under \"[expected_id]\"")

/datum/unit_test/modular_loadout_slots/Run()
	var/list/tier_slots = list(
		LOADOUT_PANEL_SLOTS_TIER1,
		LOADOUT_PANEL_SLOTS_TIER2,
		LOADOUT_PANEL_SLOTS_TIER3,
		LOADOUT_PANEL_SLOTS_TIER4,
		LOADOUT_PANEL_SLOTS_TIER5,
	)
	var/previous = LOADOUT_PANEL_SLOTS_BASE
	for(var/tier_index in 1 to length(tier_slots))
		var/slots = tier_slots[tier_index]
		if(slots <= previous)
			TEST_FAIL("patreon tier [tier_index] grants [slots] loadout slots, which is not more than the [previous] below it")
		previous = slots

	var/datum/loadout_panel/panel = new(null)
	var/list/advertised = panel.build_slot_tiers()
	qdel(panel)
	if(length(advertised) != length(tier_slots))
		TEST_FAIL("the panel advertises [length(advertised)] slot tiers but [length(tier_slots)] are defined")
		return
	for(var/tier_index in 1 to length(advertised))
		var/list/advertised_tier = advertised[tier_index]
		if(advertised_tier["slots"] != tier_slots[tier_index])
			TEST_FAIL("the panel advertises [advertised_tier["slots"]] slots for tier [advertised_tier["tier"]] but the define grants [tier_slots[tier_index]]")

/datum/unit_test/modular_stash_naming/Run()
	var/datum/mind/test_mind = allocate(/datum/mind, "modular-unit-test")
	var/item_path = /obj/item/clothing/neck/carved/silverjade
	for(var/repeat in 1 to 3)
		test_mind.add_special_item(item_path)

	if(length(test_mind.special_items) != 3)
		TEST_FAIL("three copies of the same loadout item produced [length(test_mind.special_items)] stash entries instead of 3")
	for(var/entry_name in test_mind.special_items)
		if(test_mind.special_items[entry_name] != item_path)
			TEST_FAIL("stash entry \"[entry_name]\" holds [test_mind.special_items[entry_name]] instead of [item_path]")

/datum/unit_test/modular_morphing_elixir/Run()
	for(var/obj/item/enchantingkit/kit_type as anything in subtypesof(/obj/item/enchantingkit))
		if(IS_ABSTRACT(kit_type))
			continue
		var/obj/item/enchantingkit/kit = allocate(kit_type)
		var/list/targets = kit.target_items
		var/fallback = kit.result_item
		if(!length(targets) && !fallback)
			TEST_FAIL("[kit_type] morphs nothing: target_items and result_item are both empty")
			continue

		var/list/seen_targets = list()
		for(var/target_type in targets)
			if(!ispath(target_type, /obj/item))
				TEST_FAIL("[kit_type] targets [target_type], which is not an /obj/item typepath")
				continue
			for(var/earlier_type in seen_targets)
				if(ispath(target_type, earlier_type))
					TEST_FAIL("[kit_type] lists [target_type] after its parent [earlier_type], so the parent claims it first and it can never match")
			seen_targets += target_type

			var/result_type = targets[target_type] || fallback
			if(!ispath(result_type, /obj/item))
				TEST_FAIL("[kit_type] maps [target_type] to [result_type], which is not an /obj/item typepath")
				continue
			if(result_type == target_type)
				TEST_FAIL("[kit_type] maps [target_type] onto itself, so applying it does nothing")
				continue
			var/obj/item/result_item = result_type
			if(initial(result_item.abstract_type) == result_type)
				TEST_FAIL("[kit_type] morphs [target_type] into abstract type [result_type]")
				continue
			if(!ispath(result_type, target_type))
				TEST_FAIL("[kit_type] morphs [target_type] into [result_type], which does not inherit from it, so the swap changes more than the appearance")
				continue
			if(!ispath(target_type, /obj/item/clothing))
				continue
			var/obj/item/clothing/target_clothing = target_type
			var/obj/item/clothing/result_clothing = result_type
			if(initial(target_clothing:armor_type) != initial(result_clothing:armor_type))
				TEST_FAIL("[kit_type] changes armor_type when morphing [target_type] into [result_type]")
			if(initial(target_clothing.max_integrity) != initial(result_clothing.max_integrity))
				TEST_FAIL("[kit_type] changes max_integrity when morphing [target_type] into [result_type]")
			if(initial(target_clothing.body_parts_covered) != initial(result_clothing.body_parts_covered))
				TEST_FAIL("[kit_type] changes body_parts_covered when morphing [target_type] into [result_type]")
			if(initial(target_clothing.armor_class) != initial(result_clothing.armor_class))
				TEST_FAIL("[kit_type] changes armor_class when morphing [target_type] into [result_type]")

/datum/unit_test/modular_test_exclusions/Run()
	var/list/exclusion_lists = list(
		"modular_craftable_clothes_exclusions" = GLOB.modular_craftable_clothes_exclusions,
		"modular_craftable_clothes_subtree_exclusions" = GLOB.modular_craftable_clothes_subtree_exclusions,
	)
	var/list/seen = list()
	for(var/list_name in exclusion_lists)
		var/list/paths = exclusion_lists[list_name]
		if(!length(paths))
			TEST_FAIL("[list_name] is empty, so the exemptions it used to carry are silently gone")
			continue
		for(var/path in paths)
			if(!ispath(path, /obj/item))
				TEST_FAIL("[list_name] holds [path], which is not an /obj/item typepath")
				continue
			if(seen[path])
				TEST_FAIL("[path] is excluded twice, in [seen[path]] and [list_name]")
			else
				seen[path] = list_name

/datum/unit_test/modular_telemetry/Run()
	var/list/before = GLOB.tgui_census_interfaces.Copy()
	var/list/record = tgui_census_record("UnitTestInterface")
	for(var/field in list("opens", "closes", "full", "partial", "process", "process_ms", "payloads", "payload_ms", "payload_ms_max", "full_payload_ms", "full_payloads", "bytes", "bytes_max", "static_bytes", "static_repeats", "acts", "act_ms", "act_ms_max", "slow"))
		if(isnull(record[field]))
			TEST_FAIL("tgui census record has no \"[field]\" counter, so tgui_census_format will print null for it")
	if(!islist(record["actions"]))
		TEST_FAIL("tgui census record has no actions list")

	record["payloads"] = 4
	record["payload_ms"] = 10
	record["bytes"] = 400
	record["acts"] = 2
	record["act_ms"] = 3
	record["actions"]["unit_test_action"] = 2
	var/formatted = tgui_census_format("UnitTestInterface", record)
	if(!findtext(formatted, "UnitTestInterface") || !findtext(formatted, "unit_test_action"))
		TEST_FAIL("tgui_census_format dropped the interface or its actions: [formatted]")

	tgui_census_flush()
	if(length(GLOB.tgui_census_interfaces))
		TEST_FAIL("tgui_census_flush left [length(GLOB.tgui_census_interfaces)] interfaces behind instead of resetting the window")
	GLOB.tgui_census_interfaces = before

	var/list/cases = list(
		list("tgui" = 1, "type" = "act/toggle") = "act/toggle",
		list("tgui" = 1, "type" = "ready") = "ready",
		list("tgui" = 1) = "tgui:?",
		list("_src_" = "prefs", "proc" = "set_name") = "legacy:prefs/set_name",
	)
	for(var/list/href_list in cases)
		var/classified = topic_census_classify(href_list, null)
		if(classified != cases[href_list])
			TEST_FAIL("topic_census_classify returned \"[classified]\" for [json_encode(href_list)], expected \"[cases[href_list]]\"")
	if(topic_census_classify(list(), null) != "raw")
		TEST_FAIL("topic_census_classify does not fall back to \"raw\" for an empty href list")

/datum/unit_test/modular_tgui_themes/Run()
	if(!length(GLOB.tgui_themes))
		TEST_FAIL("GLOB.tgui_themes is empty, so the theme picker renders nothing")
		return
	if(sanitize_tgui_theme(TGUI_THEME_DEFAULT) != TGUI_THEME_DEFAULT)
		TEST_FAIL("the default theme \"[TGUI_THEME_DEFAULT]\" is not in GLOB.tgui_themes, so every client falls back to a stylesheet that may not exist")
	if(sanitize_tgui_theme("hackerman") != TGUI_THEME_DEFAULT)
		TEST_FAIL("sanitize_tgui_theme let an unshipped theme through; a stale savefile or a crafted href would leave the window unstyled")
	if(sanitize_tgui_theme(null) != TGUI_THEME_DEFAULT)
		TEST_FAIL("sanitize_tgui_theme does not fall back on a null theme")

	for(var/value in GLOB.tgui_themes)
		if(!istext(value) || !length(value))
			TEST_FAIL("GLOB.tgui_themes holds a non-text key, which cannot become a theme-<name> class")
			continue
		if(!istext(GLOB.tgui_themes[value]) || !length(GLOB.tgui_themes[value]))
			TEST_FAIL("theme \"[value]\" has no label, so its picker button renders blank")

	var/list/options = tgui_theme_options()
	if(length(options) != length(GLOB.tgui_themes))
		TEST_FAIL("tgui_theme_options() emitted [length(options)] entries for [length(GLOB.tgui_themes)] themes")
	for(var/list/option in options)
		if(!GLOB.tgui_themes[option["value"]])
			TEST_FAIL("tgui_theme_options() offers \"[option["value"]]\", which is not a known theme")

/datum/unit_test/modular_abyssor_gating/Run()
	for(var/datum/map_config/map_type as anything in subtypesof(/datum/map_config))
		if(initial(map_type.abyssor_cult))
			TEST_FAIL("[map_type] enables abyssor_cult in code; the pack is meant to be switched on per map from _maps/*.json only")

/// Counts capturing groups in a regex source, so a template cannot reference a
/// $N the pattern never captures.
/proc/count_capture_groups(pattern)
	var/groups = 0
	var/total = length_char(pattern)
	var/i = 1
	while(i <= total)
		var/char = copytext_char(pattern, i, i + 1)
		if(char == "\\")
			i += 2
			continue
		if(char == "(" && copytext_char(pattern, i + 1, i + 2) != "?")
			groups++
		i++
	return groups

/datum/unit_test/modular_chat_localization/Run()
	var/static/list/valid_cases = list("nom", "gen", "dat", "acc", "ins", "pre")

	var/datum/asset/json/chat_localization/asset = get_asset_datum(/datum/asset/json/chat_localization)
	if(!asset)
		TEST_FAIL("the chat localization asset does not exist, so the panel is never handed a dictionary and chat stays English")
		return

	var/list/payload = asset.generate()
	for(var/section in list("nouns", "fragments", "patterns"))
		if(!length(payload[section]))
			TEST_FAIL("dictionary section \"[section]\" came back empty; its strings file is missing or every line in it was skipped")

	var/list/nouns = payload["nouns"]
	for(var/noun in nouns)
		var/list/cases = nouns[noun]
		if(!islist(cases) || !length(cases))
			TEST_FAIL("noun \"[noun]\" has no cases, so every pattern declining it silently renders the English word")
			continue
		if(length(cases) != length(GLOB.chat_noun_cases))
			TEST_FAIL("noun \"[noun]\" resolved [length(cases)] of [length(GLOB.chat_noun_cases)] cases; a blank field renders that case in English")
		for(var/case_key in cases)
			if(!(case_key in valid_cases))
				TEST_FAIL("noun \"[noun]\" declares case \"[case_key]\", which no template can ever ask for")
		if(findtext(noun, regex(@"^(?:the|an|a)\s", "i")))
			TEST_FAIL("noun \"[noun]\" carries an article; the panel strips articles before lookup, so this entry can never be found")

	var/list/body_parts = asset.load_nouns("nouns.txt")
	for(var/noun in asset.load_nouns("items.txt"))
		if(body_parts[noun])
			TEST_NOTICE(src, "\"[noun]\" is declined in both items.txt and nouns.txt; the body part wins and the other meaning renders wrong")

	var/list/fragments = payload["fragments"]
	for(var/english in fragments)
		if(!length(fragments[english]))
			TEST_FAIL("fragment \"[english]\" maps to an empty string, which blanks the line out in chat instead of leaving it in English")
		if(english == fragments[english])
			TEST_FAIL("fragment \"[english]\" maps to itself, so the entry costs a lookup and changes nothing")

	var/regex/token_regex = new(@"\$(\d+)(?:\|([a-z]+))?", "g")
	var/list/seen_patterns = list()
	for(var/list/entry as anything in payload["patterns"])
		var/pattern = entry["re"]
		var/template = entry["ru"]
		if(!length(pattern) || !length(template))
			TEST_FAIL("a pattern entry is missing its \"re\" or \"ru\" field and will be dropped on load")
			continue

		if(seen_patterns[pattern])
			TEST_FAIL("pattern \"[pattern]\" is listed twice; only the first can ever match, so the second translation is dead")
		else
			seen_patterns[pattern] = TRUE

		var/groups = count_capture_groups(pattern)
		token_regex.index = 0
		while(token_regex.Find(template))
			var/index = text2num(token_regex.group[1])
			var/case_key = token_regex.group[2]
			if(index > groups)
				TEST_FAIL("template \"[template]\" uses $[index] but pattern \"[pattern]\" only captures [groups] group(s), so chat prints the token literally")
			if(case_key && !(case_key in valid_cases))
				TEST_FAIL("template \"[template]\" asks for case \"[case_key]\", which is not one of [jointext(valid_cases, ", ")]")

/datum/unit_test/modular_examine_descriptions/Run()
	var/datum/asset/json/chat_localization/asset = get_asset_datum(/datum/asset/json/chat_localization)
	if(!asset)
		TEST_FAIL("the localization asset is missing, so no description can be loaded")
		return

	var/list/pairs = asset.read_pairs("descriptions.txt")
	if(!length(pairs))
		TEST_FAIL("descriptions.txt produced no entries; the file is missing or every line was skipped")
		return

	var/list/seen = list()
	for(var/list/pair as anything in pairs)
		var/path = text2path(pair[1])
		if(!ispath(path))
			TEST_FAIL("\"[pair[1]]\" is not a type; the entry is dead and the item keeps its English description")
			continue
		if(!ispath(path, /atom))
			TEST_FAIL("[path] is not an /atom, so get_examine_desc() never runs for it")
			continue
		if(seen[path])
			TEST_FAIL("[path] is translated twice, and only the last of the two can ever win")
		else
			seen[path] = TRUE

		var/atom/subject = path
		if(!initial(subject.desc))
			TEST_NOTICE(src, "[path] has no English desc of its own, so this translation replaces an inherited one")

	load_examine_descriptions()
	if(length(GLOB.examine_descriptions) != length(seen))
		TEST_FAIL("loaded [length(GLOB.examine_descriptions)] descriptions but [length(seen)] keys resolved; some were dropped at load")

/datum/unit_test/modular_trait_sheet/Run()
	var/datum/asset/json/chat_localization/asset = get_asset_datum(/datum/asset/json/chat_localization)
	if(!asset)
		TEST_FAIL("the localization asset is missing, so the sheet cannot be loaded")
		return

	var/list/pairs = asset.read_pairs("traits.txt")
	if(!length(pairs))
		TEST_FAIL("traits.txt produced no entries; the file is missing or every line was skipped")
		return

	for(var/list/pair as anything in pairs)
		var/key = pair[1]
		if(copytext(key, 1, 2) == "/")
			var/path = text2path(key)
			if(!ispath(path))
				TEST_FAIL("\"[key]\" is not a type; the entry is dead and the sheet keeps its English")
			else if(!ispath(path, /datum/quirk) && !ispath(path, /datum/language))
				TEST_FAIL("[path] is neither a quirk nor a language, so the sheet never looks it up")
			continue
		if(!(key in GLOB.roguetraits))
			TEST_FAIL("\"[key]\" is not a trait the character sheet prints; the entry is dead")
			continue
		if(!findtext(pair[2], " | "))
			TEST_FAIL("trait \"[key]\" has no \" | \" between its name and description")

	load_trait_sheet()
	if(!length(GLOB.sheet_traits))
		TEST_FAIL("no traits loaded, so every sheet line falls back to English")

/datum/unit_test/modular_chargen_sheet/Run()
	var/datum/asset/json/chat_localization/asset = get_asset_datum(/datum/asset/json/chat_localization)
	if(!asset)
		TEST_FAIL("the localization asset is missing, so the chargen sheet cannot be loaded")
		return

	var/list/allowed_fields = list("domain", "boons", "sins", "flaws", "worshippers")
	for(var/list/pair as anything in asset.read_pairs("chargen.txt"))
		var/key = pair[1]
		var/field_at = findtext(key, ":")
		var/path_text = field_at ? copytext(key, 1, field_at) : key
		var/path = text2path(path_text)

		if(!ispath(path))
			TEST_FAIL("\"[path_text]\" is not a type; the entry is dead and chargen keeps its English")
			continue
		if(!ispath(path, /datum/species) && !ispath(path, /datum/faith) && !ispath(path, /datum/patron))
			TEST_FAIL("[path] is not a species, faith or patron, so chargen never looks it up")
			continue

		if(ispath(path, /datum/species))
			var/datum/species/species = new path()
			if(!(species.id in GLOB.roundstart_species))
				TEST_FAIL("[path] is not roundstart-eligible, so the species picker never shows it; the entry is dead")
				continue

		if(field_at)
			var/field = copytext(key, field_at + 1)
			if(!(field in allowed_fields))
				TEST_FAIL("\"[key]\" uses field \"[field]\", which chargen does not render")
			else if(!ispath(path, /datum/patron))
				TEST_FAIL("\"[key]\" sets a patron field on [path], which is not a patron")
			continue

		if(!findtext(pair[2], " | "))
			TEST_FAIL("\"[key]\" has no \" | \" between its name and description")

	load_chargen_sheet()
	if(!length(GLOB.sheet_chargen))
		TEST_FAIL("no chargen entries loaded, so every species and faith falls back to English")

/datum/unit_test/modular_chargen_terms/Run()
	var/datum/asset/json/chat_localization/asset = get_asset_datum(/datum/asset/json/chat_localization)
	if(!asset)
		TEST_FAIL("the localization asset is missing, so the term sheet cannot be loaded")
		return

	var/list/produced = list("Any" = TRUE, "Imperial" = TRUE, "Ancestry" = TRUE)
	for(var/age in list(AGE_CHILD, AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL))
		produced["[age]"] = TRUE
	for(var/tag in list("Discriminated", "Exotic", "Taur", "Locked"))
		produced[tag] = TRUE
	for(var/species_id in GLOB.roundstart_species)
		var/species_type = GLOB.species_list[species_id]
		if(!species_type)
			continue
		var/datum/species/species = new species_type()
		if(species.native_language)
			produced["[species.native_language]"] = TRUE
		if(species.skin_tone_wording)
			produced["[species.skin_tone_wording]"] = TRUE

	var/list/templates = list(
		"tag:Discriminated", "tag:Exotic", "tag:Taur", "tag:Available",
		"tag:Language", "tag:Ancestry", "tag:Age", "tag:Generic",
		"warn:Discriminated", "warn:Nobles", "warn:Extreme", "warn:Challenge",
	)
	var/list/needs_term = list("tag:Language", "tag:Ancestry", "tag:Age", "tag:Generic")

	var/list/pairs = asset.read_pairs("chargen_terms.txt")
	if(!length(pairs))
		TEST_FAIL("chargen_terms.txt produced no entries; the file is missing or every line was skipped")
		return

	for(var/list/pair as anything in pairs)
		var/key = pair[1]
		if(copytext(key, 1, 5) == "tag:" || copytext(key, 1, 6) == "warn:")
			if(!(key in templates))
				TEST_FAIL("\"[key]\" is not a template chargen renders; the entry is dead")
			else if((key in needs_term) && !findtext(pair[2], "%TERM%"))
				TEST_FAIL("template \"[key]\" interpolates a term but its translation has no %TERM%")
			continue
		if(!produced[key])
			TEST_FAIL("\"[key]\" is not a language, ancestry wording, age or tag the game produces; the entry is dead")

	load_chargen_sheet()
	if(!length(GLOB.sheet_chargen_terms))
		TEST_FAIL("no chargen terms loaded, so languages, ages and tags stay English")

/datum/unit_test/modular_description_composites/Run()
	for(var/obj/item/spellbook/path as anything in subtypesof(/obj/item/spellbook))
		var/form = initial(path.themed_form)
		if(!form)
			continue
		if(!GLOB.spellbook_theme_flavor_ru[form])
			TEST_FAIL("[path] is themed \"[form]\", which has no Russian flavour line; the book would examine as its plain tier text")
		if(!examine_description_for_type(path))
			TEST_FAIL("[path] resolves to no translated ancestor, so the theme line would be appended to nothing")

		if(examine_description_for_type(path) == GLOB.examine_descriptions[/obj/item/spellbook])
			TEST_FAIL("[path] falls all the way back to the generic spellbook text; its own tier is missing from descriptions.txt")

/datum/unit_test/modular_dreams/Run()
	var/list/pool = get_dream_pool()
	if(!length(pool))
		TEST_FAIL("the dream pool is empty, so sleeping players see nothing")
		return

	var/list/seen_beats = list()
	for(var/datum/dream/entry as anything in pool)
		if(!length(entry.en))
			TEST_FAIL("[entry.type] has no English beats, so English players get a silent dream")
		if(!length(entry.ru))
			TEST_FAIL("[entry.type] has no Russian beats, so Russian players get a silent dream")
		if(length(entry.en) != length(entry.ru))
			TEST_FAIL("[entry.type] has [length(entry.en)] English beats against [length(entry.ru)] Russian ones; the two languages would pace differently")

		for(var/beat in entry.en + entry.ru)
			if(!istext(beat) || !length(beat))
				TEST_FAIL("[entry.type] carries an empty beat, which prints as \"... ...\"")
			if(seen_beats[beat])
				TEST_FAIL("[entry.type] repeats the beat \"[beat]\", already used by [seen_beats[beat]]")
			else
				seen_beats[beat] = entry.type

	// dream_sequence() consumes the list it is handed with Cut(), so what comes
	// out of fragments_for() must not be the datum's own beats.
	// ui_lang_code(null) answers RU, so this exercises the Russian list.
	var/datum/dream/sample = pool[1]
	var/before = length(sample.ru)
	var/list/handed_out = sample.fragments_for(null)
	handed_out.Cut(1, 2)
	if(length(sample.ru) != before)
		TEST_FAIL("fragments_for() handed out the datum's own list; consuming it blanks that dream out for the rest of the round")

/datum/unit_test/modular_declension_prefs/Run()
	var/static/list/valid_cases = list("gen", "dat", "acc", "ins", "pre")
	var/list/seen_cases = list()
	var/list/seen_keys = list()

	for(var/datum/preference/text/declension/pref as anything in subtypesof(/datum/preference/text/declension))
		var/case_key = initial(pref.case_key)
		var/savefile_key = initial(pref.savefile_key)

		if(!(case_key in valid_cases))
			TEST_FAIL("[pref] declares case \"[case_key]\", which the chat dictionary can never ask for")
		else if(seen_cases[case_key])
			TEST_FAIL("[pref] and [seen_cases[case_key]] both claim case \"[case_key]\"; one of them can never reach chat")
		else
			seen_cases[case_key] = pref

		if(!savefile_key)
			TEST_FAIL("[pref] has no savefile_key, so what the player types is never saved")
		else if(seen_keys[savefile_key])
			TEST_FAIL("[pref] reuses savefile_key \"[savefile_key]\" with [seen_keys[savefile_key]], so the two cases overwrite each other")
		else
			seen_keys[savefile_key] = pref

		if(!initial(pref.prompt))
			TEST_FAIL("[pref] has no prompt, so the input box gives the player no idea which case is wanted")

	for(var/case_key in valid_cases)
		if(!seen_cases[case_key])
			TEST_FAIL("no preference offers case \"[case_key]\", but a template can ask for it")

#endif
