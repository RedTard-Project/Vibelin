// Per-map switch for the Abyssor dream-cult content pack.
//
// Upstream /datum/map_config/LoadConfig() ignores keys it does not know about, so
// the flag is read back out of the same json here instead of editing upstream.
// Defaults to FALSE: stock maps stay exactly as they are unless they opt in.

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
