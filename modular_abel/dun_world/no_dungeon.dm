#define DUN_WORLD_MAP_PATH "map_files/dun_world"

/datum/controller/subsystem/mapping/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, delve = 0)
	if(config?.map_path == DUN_WORLD_MAP_PATH)
		for(var/list/z_traits in traits)
			if(z_traits[ZTRAIT_MATTHIOS_DUNGEON])
				return list()
	return ..()

/datum/controller/subsystem/mapping/preloadTemplates()
	if(config?.map_path != DUN_WORLD_MAP_PATH)
		return ..()
	for(var/item in subtypesof(/datum/map_template))
		if(ispath(item, /datum/map_template/dungeon))
			continue
		var/datum/map_template/template = new item()
		map_templates[template.id] = template

#undef DUN_WORLD_MAP_PATH
