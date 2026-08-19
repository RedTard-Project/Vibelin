/datum/map_config
	/// Whether this map runs the Abyssor dream-cult content (dream pool, rituals, Painter).
	var/abyssor_cult = FALSE

/datum/map_config/LoadConfig(filename, error_if_missing)
	. = ..()
	if(!.)
		return
	var/json = file(filename)
	if(!json)
		return
	json = file2text(json)
	if(!json)
		return
	json = json_decode(json)
	if(!json)
		return
	abyssor_cult = !!json["abyssor_cult"]
