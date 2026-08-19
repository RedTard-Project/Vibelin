/datum/asset/spritesheet_batched/loadout_panel_icons
	name = "loadout_panel_icons"
	ignore_dir_errors = TRUE

/datum/asset/spritesheet_batched/loadout_panel_icons/create_spritesheets()
	var/list/inserted_ids = list()
	for(var/path in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[path]
		if(!item.item_path || !item.ui_icon || !item.ui_icon_state)
			continue
		var/id = sanitize_css_class_name("[item.item_path]")
		if(inserted_ids[id])
			continue
		inserted_ids[id] = TRUE
		var/datum/universal_icon/entry_icon = uni_icon(item.ui_icon, item.ui_icon_state)
		entry_icon.scale(128, 128)
		insert_icon(id, entry_icon)
