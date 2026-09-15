GLOBAL_DATUM_INIT(map_vote_panel, /datum/map_vote_panel, new)

/datum/map_vote_panel

/datum/map_vote_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/map_vote_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MapVote")
		ui.open()

/datum/map_vote_panel/proc/broadcast()
	set waitfor = FALSE
	for(var/client/target as anything in GLOB.clients)
		if(target?.mob)
			ui_interact(target.mob)

/datum/map_vote_panel/proc/close_all()
	SStgui.close_uis(src)

/datum/map_vote_panel/proc/pool_entries()
	. = list()
	if(!islist(global.config?.maplist))
		return
	var/active_map = SSmapping?.config?.map_name
	var/next_map = SSmapping?.next_map_config?.map_name
	for(var/map_name in global.config.maplist)
		var/datum/map_config/entry = global.config.maplist[map_name]
		if(!entry)
			continue
		. += list(list(
			"index" = 0,
			"name" = entry.map_name,
			"category" = entry.map_category,
			"blurb" = entry.map_blurb || "",
			"votes" = 0,
			"votable" = !!entry.available_for_vote(),
			"min_players" = entry.config_min_users,
			"max_players" = entry.config_max_users,
			"current" = (entry.map_name == active_map),
			"next" = (entry.map_name == next_map),
		))

/datum/map_vote_panel/proc/live_entries()
	. = list()
	var/active_map = SSmapping?.config?.map_name
	var/next_map = SSmapping?.next_map_config?.map_name
	for(var/i in 1 to length(SSvote.choices))
		var/map_name = SSvote.choices[i]
		var/datum/map_config/entry = map_pool_config_for(map_name)
		. += list(list(
			"index" = i,
			"name" = map_name,
			"category" = map_pool_category_of(map_name),
			"blurb" = map_pool_blurb_of(map_name),
			"votes" = SSvote.choices[map_name] || 0,
			"votable" = TRUE,
			"min_players" = entry?.config_min_users || 0,
			"max_players" = entry?.config_max_users || 0,
			"current" = (map_name == active_map),
			"next" = (map_name == next_map),
		))

/datum/map_vote_panel/ui_data(mob/user)
	var/list/data = list()
	var/active = (SSvote.mode == "map")
	var/list/entries = active ? live_entries() : pool_entries()
	var/list/names = list()
	for(var/list/entry as anything in entries)
		names += entry["name"]

	data["lang"] = ui_lang_code(user?.client)
	data["active"] = active
	data["maps"] = entries
	data["categories"] = map_pool_ordered_categories(names)
	data["time_remaining"] = active ? SSvote.time_remaining : 0
	data["has_voted"] = active && (user?.ckey in SSvote.voted)
	data["is_admin"] = !!user?.client?.holder
	data["voting_allowed"] = !!CONFIG_GET(flag/allow_vote_map)
	data["other_vote_running"] = (SSvote.mode && !active)
	data["other_vote_mode"] = SSvote.mode || ""
	data["current_map"] = SSmapping?.config?.map_name || ""
	data["next_map"] = SSmapping?.next_map_config?.map_name || ""
	return data

/datum/map_vote_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui?.user
	switch(action)
		if("vote")
			if(SSvote.mode != "map" || !usr?.client)
				return TRUE
			var/index = text2num(params["index"])
			if(!isnum(index))
				return TRUE
			SSvote.submit_vote(round(index))
			return TRUE
		if("start")
			if(!CONFIG_GET(flag/allow_vote_map) && !user?.client?.holder)
				return TRUE
			SSvote.initiate_vote("map", user?.key)
			return TRUE
		if("cancel")
			if(!user?.client?.holder)
				return TRUE
			SSvote.reset()
			return TRUE
	return FALSE

/mob/verb/map_vote_panel()
	set category = "OOC"
	set name = "Map Vote"
	GLOB.map_vote_panel?.ui_interact(src)
