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
	for(var/path_str in prefs.panel_loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item?.item_path)
			continue
		user.mind.add_special_item(item.item_path)

/obj/structure/try_fetch_special_item(mob/user)
	if(user.mind && isliving(user))
		apply_panel_loadout(user)
	return ..()
