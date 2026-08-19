/datum/loadout_panel
	var/datum/preferences/owner_prefs

/datum/loadout_panel/New(datum/preferences/prefs)
	owner_prefs = prefs

/datum/loadout_panel/Destroy()
	owner_prefs = null
	return ..()

/datum/loadout_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/loadout_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LoadoutPanel")
		ui.open()

/datum/loadout_panel/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet_batched/loadout_panel_icons))

/datum/loadout_panel/proc/build_item_entry(datum/loadout_item/item, client/user_client)
	var/path_str = "[item.item_path]"
	return list(
		"name" = item.name,
		"path" = path_str,
		"iconClass" = "loadout_panel_icons128x128 [sanitize_css_class_name(path_str)]",
		"isDonatorItem" = item.panel_donator,
		"unavailableReason" = item.panel_block_reason(user_client),
	)

/datum/loadout_panel/proc/build_slot_tiers()
	return list(
		list("tier" = ACCESS_THANKS_RANK, "slots" = LOADOUT_PANEL_SLOTS_TIER1),
		list("tier" = ACCESS_ASSISTANT_RANK, "slots" = LOADOUT_PANEL_SLOTS_TIER2),
		list("tier" = ACCESS_COMMAND_RANK, "slots" = LOADOUT_PANEL_SLOTS_TIER3),
		list("tier" = ACCESS_TRAITOR_RANK, "slots" = LOADOUT_PANEL_SLOTS_TIER4),
		list("tier" = ACCESS_NUKIE_RANK, "slots" = LOADOUT_PANEL_SLOTS_TIER5),
	)

/datum/loadout_panel/proc/build_categories(client/user_client)
	var/list/every_entry = list()
	var/list/by_category = list()
	for(var/path in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[path]
		if(!item.item_path)
			continue
		if(item.loadout_flags & LOADOUT_FLAG_NO_EQUIP)
			continue
		var/list/entry = build_item_entry(item, user_client)
		every_entry += list(entry)
		var/category = item.panel_donator ? LOADOUT_PANEL_CATEGORY_DONATOR : item.ui_category
		if(!by_category[category])
			by_category[category] = list()
		by_category[category] += list(entry)

	var/list/categories = list()
	categories[LOADOUT_PANEL_CATEGORY_ALL] = every_entry
	for(var/category in list(LOADOUT_PANEL_CATEGORY_DONATOR, LOADOUT_PANEL_CATEGORY_AZURE))
		if(!by_category[category])
			continue
		categories[category] = by_category[category]
		by_category -= category
	for(var/category in by_category)
		categories[category] = by_category[category]
	return categories

/datum/loadout_panel/ui_static_data(mob/user)
	return list(
		"categories" = build_categories(user?.client),
		"maxLoadoutSlots" = owner_prefs.get_panel_loadout_size(user),
		"slotTiers" = build_slot_tiers(),
	)

/datum/loadout_panel/ui_data(mob/user)
	var/list/selected = list()
	for(var/path_str in owner_prefs.panel_loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item)
			continue
		selected += list(list("path" = path_str, "name" = item.name))
	return list(
		"selectedLoadoutItems" = selected,
		"curLoadoutSlots" = length(owner_prefs.panel_loadout_items),
	)

/datum/loadout_panel/proc/add_item(mob/user, path_str)
	var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
	if(!item?.item_path)
		return
	if(path_str in owner_prefs.panel_loadout_items)
		return
	if(length(owner_prefs.panel_loadout_items) >= owner_prefs.get_panel_loadout_size(user))
		to_chat(user, span_warning("Лимит исчерпан!"))
		return
	var/block_reason = item.panel_block_reason(user.client)
	if(block_reason)
		to_chat(user, span_warning(block_reason))
		return
	owner_prefs.panel_loadout_items += path_str
	owner_prefs.save_character()

/datum/loadout_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("add")
			add_item(user, params["item"])
			return TRUE
		if("remove")
			owner_prefs.panel_loadout_items -= params["item"]
			owner_prefs.save_character()
			return TRUE
		if("clear")
			owner_prefs.panel_loadout_items = list()
			owner_prefs.save_character()
			to_chat(user, span_notice("Лодаут очищен!"))
			return TRUE
		if("boosty")
			var/boosty_url = CONFIG_GET(string/boostyurl)
			if(boosty_url)
				user << link(boosty_url)
			return TRUE
