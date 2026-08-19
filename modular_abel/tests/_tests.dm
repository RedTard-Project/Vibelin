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

/datum/unit_test/modular_abyssor_gating/Run()
	for(var/datum/map_config/map_type as anything in subtypesof(/datum/map_config))
		if(initial(map_type.abyssor_cult))
			TEST_FAIL("[map_type] enables abyssor_cult in code; the pack is meant to be switched on per map from _maps/*.json only")

#endif
