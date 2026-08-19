GLOBAL_VAR_INIT(topic_census_debug, TRUE)

/client/var/list/topic_census_state

/proc/topic_census_path()
	return "[GLOB.log_directory]/topic_census.log"

/proc/topic_census_write(text)
	WRITE_LOG(topic_census_path(), text)

/proc/topic_census_payload_field(list/href_list)
	var/payload_text = href_list["payload"]
	if(!payload_text)
		return null
	if(!rustg_json_is_valid(payload_text))
		return "BADJSON"
	var/list/decoded = json_decode(payload_text)
	if(!islist(decoded))
		return null
	return decoded["preference"] || decoded["renderByondUi"] || decoded["action"] || decoded["key"]

/proc/topic_census_classify(list/href_list, hsrc)
	if(href_list["tgui"])
		var/type = href_list["type"]
		if(!type)
			return "tgui:?"
		if(copytext(type, 1, 5) == "act/")
			var/field = topic_census_payload_field(href_list)
			return "[type][field ? "/[field]" : ""]"
		if(type == "renderByondUi" || type == "unmountByondUi")
			var/target = topic_census_payload_field(href_list)
			return "[type][target ? "/[target]" : ""]"
		if(type == "log")
			return "log fatal=[href_list["fatal"] || "0"]"
		return type
	if(href_list["_src_"])
		. = "legacy:[href_list["_src_"]]"
		if(href_list["proc"])
			. += "/[href_list["proc"]]"
		else if(href_list["preference"])
			. += "/[href_list["preference"]]"
		return .
	if(hsrc)
		return "src:[hsrc]"
	return "raw"

/proc/log_topic_census(client/user, href, list/href_list, hsrc)
	if(!GLOB.topic_census_debug || !user)
		return
	var/list/state = user.topic_census_state
	if(!state)
		state = list("sec" = 0, "secn" = 0, "min" = 0, "minn" = 0, "classes" = list())
		user.topic_census_state = state
	var/second = round(world.time, 1 SECONDS)
	var/minute = round(world.time, 1 MINUTES)
	if(state["min"] != minute)
		if(state["minn"])
			topic_census_flush_minute(user, state)
		state["min"] = minute
		state["minn"] = 0
		state["classes"] = list()
	if(state["sec"] != second)
		state["sec"] = second
		state["secn"] = 0
	state["secn"] += 1
	state["minn"] += 1

	var/class = topic_census_classify(href_list, hsrc)
	var/list/classes = state["classes"]
	classes[class] = (classes[class] || 0) + 1

	var/wid = href_list["window_id"]
	var/exempt = (user.holder || wid == "statbrowser" || istype(hsrc, /datum/native_say))
	var/mtl = CONFIG_GET(number/minute_topic_limit)
	var/stl = CONFIG_GET(number/second_topic_limit)
	var/flags = ""
	if(exempt)
		flags += "EXEMPT "
	if(mtl && state["minn"] > mtl)
		flags += "OVER-MIN "
	if(stl && state["secn"] > stl)
		flags += "OVER-SEC "

	var/rawlen = length(href)
	var/rawshown = (rawlen > 240) ? "[copytext(href, 1, 240)]…" : href
	topic_census_write("[world.timeofday]ds [user.ckey] sec=[state["secn"]] min=[state["minn"]] [flags]wid=[wid] <[class]> len=[rawlen] raw=[rawshown]")

/proc/topic_census_flush_minute(client/user, list/state)
	var/list/classes = state["classes"]
	var/list/parts = list()
	for(var/c in classes)
		parts += "[c]=[classes[c]]"
	topic_census_write("[world.timeofday]ds [user.ckey] === MINUTE SUMMARY total=[state["minn"]] === [jointext(parts, " | ")]")

/proc/log_topic_census_drop(client/user, kind, count, limit, href)
	if(!GLOB.topic_census_debug || !user)
		return
	var/rawshown = (length(href) > 200) ? "[copytext(href, 1, 200)]…" : href
	topic_census_write("[world.timeofday]ds [user.ckey] *** DROPPED [kind] ([count]/[limit]) raw=[rawshown]")
