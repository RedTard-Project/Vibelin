/datum/preferences
	var/list/panel_loadout_items = list()
	var/datum/loadout_panel/loadout_panel_ui

/datum/mind
	var/panel_loadout_applied = FALSE

/datum/preferences/Destroy(force)
	QDEL_NULL(loadout_panel_ui)
	return ..()

/datum/preferences/proc/get_panel_loadout_size(mob/user)
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
		if(!item || (item.loadout_flags & LOADOUT_FLAG_NO_EQUIP))
			continue
		valid_items += path_str
	if(length(valid_items) != length(panel_loadout_items))
		panel_loadout_items = valid_items
		if(user)
			to_chat(user, span_warning("Твой лодаут был очищен из-за изменений в предметах."))
	if(length(panel_loadout_items) > get_panel_loadout_size(user))
		panel_loadout_items = list()
		if(user)
			to_chat(user, span_warning("Размер твоего лодаута был изменён и его пришлось сбросить!"))

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
