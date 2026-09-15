/datum/map_config/var/map_category = MAP_CATEGORY_STANDARD
/datum/map_config/var/map_blurb

GLOBAL_LIST_INIT(map_pool_category_order, list(
	MAP_CATEGORY_STANDARD,
	MAP_CATEGORY_OLD_BETA,
))

/datum/map_config/LoadConfig(filename, error_if_missing)
	. = ..()
	if(!.)
		return
	var/raw = file(filename)
	if(!raw)
		return
	raw = file2text(raw)
	if(!raw)
		return
	var/list/json = safe_json_decode(raw)
	if(!islist(json))
		return
	if(istext(json["category"]))
		map_category = json["category"]
	if(istext(json["blurb"]))
		map_blurb = json["blurb"]

/proc/map_pool_config_for(map_name)
	if(!map_name || !islist(global.config?.maplist))
		return null
	return global.config.maplist[map_name]

/proc/map_pool_category_of(map_name)
	var/datum/map_config/found = map_pool_config_for(map_name)
	return found?.map_category || MAP_CATEGORY_STANDARD

/proc/map_pool_blurb_of(map_name)
	var/datum/map_config/found = map_pool_config_for(map_name)
	return found?.map_blurb || ""

/proc/map_pool_active_map_file()
	var/map = SSmapping?.config?.map_file
	if(islist(map))
		var/list/maps = map
		return length(maps) ? maps[1] : null
	return map

/proc/map_pool_ordered_categories(list/names)
	var/list/present = list()
	for(var/map_name in names)
		present |= map_pool_category_of(map_name)
	. = list()
	for(var/category in GLOB.map_pool_category_order)
		if(category in present)
			. += category
			present -= category
	for(var/category in present)
		. += category
