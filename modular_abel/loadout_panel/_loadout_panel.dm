#define LOADOUT_PANEL_CATEGORY_ALL "Всё"
#define LOADOUT_PANEL_CATEGORY_DONATOR "Донат"
#define LOADOUT_PANEL_CATEGORY_AZURE "Azure Content"

#define LOADOUT_PANEL_SLOTS_BASE 3
#define LOADOUT_PANEL_SLOTS_TIER1 7
#define LOADOUT_PANEL_SLOTS_TIER2 11
#define LOADOUT_PANEL_SLOTS_TIER3 17
#define LOADOUT_PANEL_SLOTS_TIER4 21
#define LOADOUT_PANEL_SLOTS_TIER5 27

/datum/config_entry/string/boostyurl
	config_entry_value = ""

/datum/config_entry/flag/loadout_panel_free_for_all
	config_entry_value = TRUE
	default = TRUE

/datum/preferences
	var/list/panel_loadout_items = list()
	var/datum/loadout_panel/loadout_panel_ui

/datum/mind
	var/panel_loadout_applied = FALSE

/datum/preferences/Destroy(force)
	QDEL_NULL(loadout_panel_ui)
	return ..()

/datum/preferences/proc/get_panel_loadout_size(mob/user)
	if(CONFIG_GET(flag/loadout_panel_free_for_all))
		return LOADOUT_PANEL_SLOTS_TIER5
	var/client/user_client = user?.client || parent
	switch(user_client?.patreon?.access_rank)
		if(ACCESS_THANKS_RANK)
			return LOADOUT_PANEL_SLOTS_TIER1
		if(ACCESS_ASSISTANT_RANK)
			return LOADOUT_PANEL_SLOTS_TIER2
		if(ACCESS_COMMAND_RANK)
			return LOADOUT_PANEL_SLOTS_TIER3
		if(ACCESS_TRAITOR_RANK)
			return LOADOUT_PANEL_SLOTS_TIER4
		if(ACCESS_NUKIE_RANK)
			return LOADOUT_PANEL_SLOTS_TIER5
	return LOADOUT_PANEL_SLOTS_BASE

/datum/preferences/proc/clean_panel_loadout(mob/user)
	var/list/valid_items = list()
	for(var/path_str in panel_loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item || !item.item_path || (item.loadout_flags & LOADOUT_FLAG_NO_EQUIP))
			continue
		valid_items += path_str
	if(length(valid_items) != length(panel_loadout_items))
		panel_loadout_items = valid_items
		if(user)
			to_chat(user, span_warning("Часть твоего лодаута была убрана из-за изменений в предметах."))
	var/slot_limit = get_panel_loadout_size(user)
	if(user && length(panel_loadout_items) > slot_limit)
		to_chat(user, span_warning("В лодауте [length(panel_loadout_items)] предметов, а слотов сейчас [slot_limit]. Выданы будут только первые [slot_limit] — остальные сохранены и вернутся вместе со слотами."))

/datum/preferences/proc/open_donor_loadout(mob/user)
	if(!loadout_panel_ui)
		loadout_panel_ui = new(src)
	clean_panel_loadout(user)
	loadout_panel_ui.ui_interact(user)

/datum/preferences/_load_appearence(savefile/save)
	. = ..()
	save["panel_loadout_items"] >> panel_loadout_items
	if(!islist(panel_loadout_items))
		panel_loadout_items = list()

/datum/preferences/save_character()
	. = ..()
	if(!. || !path)
		return
	var/savefile/save = new /savefile(path)
	if(!save)
		return
	save.cd = "/character[default_slot]"
	WRITE_FILE(save["panel_loadout_items"], panel_loadout_items)

/datum/loadout_item
	/// Shows the item under the panel's donator tab instead of its own category.
	var/panel_donator = FALSE

/// Null when the client may take this item from the loadout panel, otherwise the reason it cannot.
/datum/loadout_item/proc/panel_block_reason(client/user_client)
	if(loadout_flags & LOADOUT_FLAG_NO_EQUIP)
		return "Недоступно."
	if(loadout_flags & LOADOUT_FLAG_GIVEAWAY_ONLY)
		return "Только с розыгрышей."
	if((loadout_flags & LOADOUT_FLAG_PATREON_LOCKED) && !CONFIG_GET(flag/loadout_panel_free_for_all) && !user_client?.patreon?.is_donator())
		return "Требуется донат-статус."
	if(required_award && (!user_client || !is_unlocked_for(user_client)))
		return "Требуется достижение."
	return null

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

/datum/loadout_panel/proc/build_item_entry(loadout_path, datum/loadout_item/item, client/user_client)
	var/path_str = "[loadout_path]"
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
		var/list/entry = build_item_entry(path, item, user_client)
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
		"curLoadoutSlots" = length(selected),
	)

/datum/loadout_panel/proc/add_item(mob/user, path_str)
	var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
	if(!item?.item_path)
		return FALSE
	if(path_str in owner_prefs.panel_loadout_items)
		return FALSE
	if(length(owner_prefs.panel_loadout_items) >= owner_prefs.get_panel_loadout_size(user))
		to_chat(user, span_warning("Лимит исчерпан!"))
		return FALSE
	var/block_reason = item.panel_block_reason(user.client)
	if(block_reason)
		to_chat(user, span_warning(block_reason))
		return FALSE
	owner_prefs.panel_loadout_items += path_str
	return TRUE

/datum/loadout_panel/proc/remove_item(path_str)
	if(!(path_str in owner_prefs.panel_loadout_items))
		return FALSE
	owner_prefs.panel_loadout_items -= path_str
	return TRUE

/datum/loadout_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("add")
			if(!istext(params["item"]))
				return TRUE
			if(add_item(user, params["item"]))
				owner_prefs.save_character()
			return TRUE
		if("remove")
			if(!istext(params["item"]))
				return TRUE
			if(remove_item(params["item"]))
				owner_prefs.save_character()
			return TRUE
		if("clear")
			if(!length(owner_prefs.panel_loadout_items))
				return TRUE
			owner_prefs.panel_loadout_items = list()
			owner_prefs.save_character()
			to_chat(user, span_notice("Лодаут очищен!"))
			return TRUE
		if("boosty")
			var/boosty_url = CONFIG_GET(string/boostyurl)
			if(boosty_url)
				user << link(boosty_url)
			return TRUE

/datum/mind/proc/add_special_item(atom/item_path)
	var/base_name = initial(item_path.name)
	var/entry_name = base_name
	var/suffix = 1
	while(entry_name in special_items)
		suffix++
		entry_name = "[base_name] ([suffix])"
	special_items[entry_name] = item_path

/proc/apply_panel_loadout(mob/user)
	if(!user?.mind || !user.client?.prefs)
		return
	if(user.mind.panel_loadout_applied)
		return
	var/datum/preferences/prefs = user.client.prefs
	if(!length(prefs.panel_loadout_items))
		return
	user.mind.panel_loadout_applied = TRUE
	var/slots_left = prefs.get_panel_loadout_size(user)
	for(var/path_str in prefs.panel_loadout_items)
		if(slots_left <= 0)
			break
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item?.item_path)
			continue
		user.mind.add_special_item(item.item_path)
		slots_left--

/obj/structure/try_fetch_special_item(mob/user)
	if(user.mind && isliving(user))
		apply_panel_loadout(user)
	return ..()

/datum/asset/spritesheet_batched/loadout_panel_icons
	name = "loadout_panel_icons"
	ignore_dir_errors = TRUE

/datum/asset/spritesheet_batched/loadout_panel_icons/create_spritesheets()
	for(var/path in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[path]
		if(!item.item_path || !item.ui_icon || !item.ui_icon_state)
			continue
		var/datum/universal_icon/entry_icon = uni_icon(item.ui_icon, item.ui_icon_state)
		entry_icon.scale(128, 128)
		insert_icon(sanitize_css_class_name("[path]"), entry_icon)
