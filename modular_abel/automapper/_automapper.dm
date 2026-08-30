#define INIT_ORDER_AUTOMAPPER 88
#define AUTOMAPPER_MAP_BUILTIN "builtin"

/datum/map_template
	var/depth = 1

/datum/map_template/preload_size(path, cache = FALSE)
	var/datum/parsed_map/parsed = new(file(path))
	var/bounds = parsed?.bounds
	if(bounds)
		width = (bounds[MAP_MAXX] - bounds[MAP_MINX] + 1)
		height = (bounds[MAP_MAXY] - bounds[MAP_MINY] + 1)
		depth = (bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1)
		if(cache)
			cached_map = parsed
	return bounds

/datum/map_template/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	var/x2 = placement.x + width - 1
	var/y2 = placement.y + height - 1
	var/z2 = placement.z + depth - 1
	return block(placement, locate(x2, y2, z2))

/datum/map_template/proc/nuke_placement_area(turf/T, centered = FALSE, turf/empty_type = /turf/open/openspace)
	var/list/turfs = get_affected_turfs(T, centered)
	for(var/turf/iter as anything in turfs)
		for(var/atom/movable/A as anything in iter.contents)
			qdel(A, force = TRUE)
		if(iter.type == empty_type)
			continue
		var/bt = initial(empty_type.baseturfs)
		if(islist(bt))
			bt = bt[1]
		iter.ChangeTurf(empty_type, bt, CHANGETURF_FORCEOP)

/datum/map_template/automap_template
	name = "Automap Template"
	keep_cached_map = TRUE
	var/required_map
	var/affects_builtin_map
	var/turf/load_turf
	var/load_x
	var/load_y
	var/load_z

/datum/map_template/automap_template/New(path, rename, incoming_required_map, incoming_coordinates)
	. = ..(path, rename, cache = TRUE)
	if(!incoming_required_map || !islist(incoming_coordinates) || (length(incoming_coordinates) != 3))
		return
	required_map = incoming_required_map
	affects_builtin_map = incoming_required_map == AUTOMAPPER_MAP_BUILTIN
	load_x = text2num("[incoming_coordinates[1]]")
	load_y = text2num("[incoming_coordinates[2]]")
	load_z = text2num("[incoming_coordinates[3]]")

/datum/map_template/automap_template/proc/resolve_load_turf()
	if(load_turf)
		return load_turf
	var/real_z = load_z
	if(required_map && !affects_builtin_map)
		if(!islist(SSautomapper.map_start_z) || !SSautomapper.map_start_z[required_map])
			CRASH("Automapper: missing map context for required_map='[required_map]' (template='[name]')")
		var/start_z = SSautomapper.map_start_z[required_map]
		var/map_depth = SSautomapper.map_depth?[required_map] || 1
		if(load_z < 1 || load_z > map_depth)
			CRASH("Automapper: template '[name]' has z=[load_z] out of bounds (required_map='[required_map]', depth=[map_depth])")
		real_z = start_z + load_z - 1
	load_turf = locate(load_x, load_y, real_z)
	return load_turf

SUBSYSTEM_DEF(automapper)
	name = "Automapper"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_AUTOMAPPER
	var/config_file = "_maps/automapper.toml"
	var/loaded_config
	var/list/preloaded_map_templates = list()
	var/list/map_start_z = null
	var/list/map_depth = null

/datum/controller/subsystem/automapper/proc/set_map_context(list/in_start_z, list/in_depth)
	map_start_z = in_start_z
	map_depth = in_depth

/datum/controller/subsystem/automapper/Initialize(timeofday)
	loaded_config = list("templates" = list())
	if(!fexists(config_file))
		return ..()
	var/txt = file2text(config_file)
	if(!istext(txt) || !length(txt))
		return ..()
	var/raw = rustg_read_toml_file(config_file)
	if(!raw)
		return ..()
	var/list/decoded = null
	if(islist(raw))
		if(islist(raw["templates"]))
			decoded = raw
		else if(raw["success"] != null)
			if(!raw["success"])
				CRASH("Automapper TOML error: [raw["content"]]")
			if(istext(raw["content"]) && length(raw["content"]))
				decoded = json_decode(raw["content"])
		else if(istext(raw["content"]) && length(raw["content"]))
			decoded = json_decode(raw["content"])
		else if(istext(raw["json"]) && length(raw["json"]))
			decoded = json_decode(raw["json"])
	else if(istext(raw) && length(raw))
		decoded = json_decode(raw)
	if(!islist(decoded))
		return ..()
	loaded_config = decoded
	normalize_templates_in_config()
	if(!islist(loaded_config) || !islist(loaded_config["templates"]))
		loaded_config = list("templates" = list())
	return ..()

/datum/controller/subsystem/automapper/proc/normalize_templates_in_config()
	if(!islist(loaded_config))
		loaded_config = list()
	var/list/t = loaded_config["templates"]
	if(!islist(t) || !length(t))
		loaded_config["templates"] = list()
		return
	if(islist(t[1]))
		var/list/assoc = list()
		for(var/i = 1 to length(t))
			var/list/entry = t[i]
			if(!islist(entry))
				continue
			var/name = entry["template"] || entry["name"] || entry["id"]
			if(!istext(name) || !length(name))
				name = "template_[i]"
			assoc[name] = entry
		loaded_config["templates"] = assoc

/datum/controller/subsystem/automapper/proc/preload_templates_from_toml(map_names)
	if(!islist(loaded_config) || !islist(loaded_config["templates"]) || !length(loaded_config["templates"]))
		return
	if(!islist(map_names))
		map_names = list(map_names)
	var/list/templates = loaded_config["templates"]
	var/list/main_map_files = islist(SSmapping.config.map_file) ? SSmapping.config.map_file : list(SSmapping.config.map_file)
	for(var/template_name in templates)
		var/list/selected_template = templates[template_name]
		if(!islist(selected_template))
			continue
		var/required_map = selected_template["required_map"]
		if(!istext(required_map) || !length(required_map))
			continue
		var/requires_builtin = (required_map == AUTOMAPPER_MAP_BUILTIN) && (LAZYLEN(main_map_files & map_names) || (LAZYLEN(map_names) == 1 && (map_names[1] in main_map_files)))
		if(!requires_builtin && !(required_map in map_names))
			continue
		var/list/coordinates = selected_template["coordinates"]
		if(!islist(coordinates) || length(coordinates) != 3)
			CRASH("Invalid coordinates for automap template [template_name]!")
		var/list/map_files = selected_template["map_files"]
		if(!islist(map_files) || !length(map_files))
			CRASH("Could not find any valid map files for automap template [template_name]!")
		var/directory = selected_template["directory"]
		if(!istext(directory) || !length(directory))
			CRASH("Could not find directory for automap template [template_name]!")
		var/map_file = directory + pick(map_files)
		if(!fexists(map_file))
			CRASH("[template_name] could not find map file [map_file]!")
		var/datum/map_template/automap_template/map = new(map_file, template_name, required_map, coordinates)
		preloaded_map_templates += map

/datum/controller/subsystem/automapper/proc/load_templates_from_cache(map_names)
	if(!islist(map_names))
		map_names = list(map_names)
	var/list/main_map_files = islist(SSmapping.config.map_file) ? SSmapping.config.map_file : list(SSmapping.config.map_file)
	for(var/datum/map_template/automap_template/iterating_template as anything in preloaded_map_templates)
		if(iterating_template.affects_builtin_map && (LAZYLEN(main_map_files & map_names) || (LAZYLEN(map_names) == 1 && (map_names[1] in main_map_files))))
			iterating_template.resolve_load_turf()
			if(iterating_template.load_turf)
				for(var/turf/old_turf as anything in iterating_template.get_affected_turfs(iterating_template.load_turf, FALSE))
					init_contents(old_turf)
		else if(!(iterating_template.required_map in map_names))
			continue
		iterating_template.resolve_load_turf()
		if(!iterating_template.load_turf)
			CRASH("Automapper: locate failed for [iterating_template.name] at [iterating_template.load_x],[iterating_template.load_y],[iterating_template.load_z] (required_map=[iterating_template.required_map]) world=[world.maxx]x[world.maxy]x[world.maxz]")
		iterating_template.nuke_placement_area(iterating_template.load_turf, FALSE, /turf/open/openspace)
		if(iterating_template.load(iterating_template.load_turf, FALSE))
			log_world("AUTOMAPPER: Successfully loaded map template [iterating_template.name] at [iterating_template.load_turf.x], [iterating_template.load_turf.y], [iterating_template.load_turf.z]!")

/datum/controller/subsystem/automapper/proc/init_contents(atom/parent)
	var/static/list/mapload_args = list(TRUE)
	var/previous_initialized_value = SSatoms.initialized
	SSatoms.initialized = INITIALIZATION_INNEW_MAPLOAD
	for(var/atom/atom_to_init as anything in parent.get_all_contents() - parent)
		if(atom_to_init.flags_1 & INITIALIZED_1)
			continue
		SSatoms.InitAtom(atom_to_init, mapload_args)
	SSatoms.initialized = previous_initialized_value
	for(var/atom/atom_to_del as anything in parent.get_all_contents() - parent)
		qdel(atom_to_del, TRUE)

/datum/controller/subsystem/mapping/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, delve = 0)
	. = ..()
	if(!islist(.) || !length(.))
		return
	if(islist(errorList) && length(errorList))
		return
	if(!islist(files))
		files = list(files)
	var/list/parsed_maps = .
	var/total_z = 0
	for(var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if(!pm?.bounds)
			continue
		total_z += pm.bounds[MAP_MAXZ] - pm.bounds[MAP_MINZ] + 1
	if(!total_z)
		return
	var/start_z = world.maxz - total_z + 1
	var/list/group_start_z = list()
	var/list/group_depth = list()
	for(var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if(!pm?.bounds)
			continue
		var/filename = pm.original_path
		var/slash = findlasttext(filename, "/")
		if(slash)
			filename = copytext(filename, slash + 1)
		group_start_z[filename] = start_z + parsed_maps[P]
		group_depth[filename] = pm.bounds[MAP_MAXZ] - pm.bounds[MAP_MINZ] + 1
	SSautomapper.set_map_context(group_start_z, group_depth)
	SSautomapper.preload_templates_from_toml(files)
	SSautomapper.load_templates_from_cache(files)
