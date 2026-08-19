GLOBAL_VAR_INIT(topic_census_debug, TRUE)
GLOBAL_VAR_INIT(tgui_census_debug, TRUE)
GLOBAL_VAR_INIT(tgui_census_payload_bytes, TRUE)
GLOBAL_VAR_INIT(tgui_census_slow_call_ms, 5)
GLOBAL_VAR_INIT(tgui_census_flush_running, FALSE)
GLOBAL_LIST_EMPTY(tgui_census_interfaces)
GLOBAL_LIST_EMPTY(tgui_census_clients)

/client/var/list/topic_census_state
/datum/tgui/var/tgui_census_static_hash
/datum/tgui/var/tgui_census_opened_at

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

/proc/tgui_census_path()
	return "[GLOB.log_directory]/tgui_census.log"

/proc/tgui_census_write(text)
	WRITE_LOG(tgui_census_path(), text)

/proc/tgui_census_record(interface)
	if(!interface)
		interface = "<unknown>"
	var/list/record = GLOB.tgui_census_interfaces[interface]
	if(record)
		return record
	record = list(
		"opens" = 0,
		"closes" = 0,
		"full" = 0,
		"partial" = 0,
		"process" = 0,
		"process_ms" = 0,
		"payloads" = 0,
		"payload_ms" = 0,
		"payload_ms_max" = 0,
		"full_payload_ms" = 0,
		"full_payloads" = 0,
		"bytes" = 0,
		"bytes_max" = 0,
		"static_bytes" = 0,
		"static_repeats" = 0,
		"acts" = 0,
		"act_ms" = 0,
		"act_ms_max" = 0,
		"slow" = 0,
		"actions" = list(),
	)
	GLOB.tgui_census_interfaces[interface] = record
	return record

/proc/tgui_census_touch_client(client/user, field)
	if(!user)
		return
	var/list/record = GLOB.tgui_census_clients[user.ckey]
	if(!record)
		record = list("payloads" = 0, "bytes" = 0, "acts" = 0, "slow" = 0)
		GLOB.tgui_census_clients[user.ckey] = record
	record[field] += 1
	return record

/proc/tgui_census_start_flush_loop()
	if(GLOB.tgui_census_flush_running)
		return
	GLOB.tgui_census_flush_running = TRUE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(tgui_census_flush)), 1 MINUTES, TIMER_LOOP | TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

/proc/tgui_census_flush()
	if(!length(GLOB.tgui_census_interfaces))
		return
	tgui_census_write("[world.timeofday]ds ===== MINUTE SUMMARY open_uis=[length(SStgui.all_uis)] clients=[length(GLOB.tgui_census_clients)] =====")
	for(var/interface in GLOB.tgui_census_interfaces)
		tgui_census_write("[world.timeofday]ds   [tgui_census_format(interface, GLOB.tgui_census_interfaces[interface])]")
	for(var/ckey in GLOB.tgui_census_clients)
		var/list/record = GLOB.tgui_census_clients[ckey]
		tgui_census_write("[world.timeofday]ds   client [ckey] payloads=[record["payloads"]] bytes=[record["bytes"]] acts=[record["acts"]] slow=[record["slow"]]")
	GLOB.tgui_census_interfaces = list()
	GLOB.tgui_census_clients = list()

/proc/tgui_census_format(interface, list/record)
	var/payloads = record["payloads"]
	var/avg_ms = payloads ? round(record["payload_ms"] / payloads, 0.01) : 0
	var/full_avg_ms = record["full_payloads"] ? round(record["full_payload_ms"] / record["full_payloads"], 0.01) : 0
	var/avg_bytes = payloads ? round(record["bytes"] / payloads) : 0
	var/act_avg_ms = record["acts"] ? round(record["act_ms"] / record["acts"], 0.01) : 0
	var/list/actions = record["actions"]
	var/list/action_parts = list()
	for(var/action in actions)
		action_parts += "[action]=[actions[action]]"
	return "[interface] open=[record["opens"]]/close=[record["closes"]] \
		payloads=[payloads] (full=[record["full"]] partial=[record["partial"]]) \
		ms avg=[avg_ms] max=[round(record["payload_ms_max"], 0.01)] full_avg=[full_avg_ms] \
		bytes avg=[avg_bytes] max=[record["bytes_max"]] static=[record["static_bytes"]] static_repeats=[record["static_repeats"]] \
		process=[record["process"]] ([round(record["process_ms"], 0.01)]ms) \
		acts=[record["acts"]] (avg=[act_avg_ms] max=[round(record["act_ms_max"], 0.01)]) slow=[record["slow"]]\
		[length(action_parts) ? " | [jointext(action_parts, " ")]" : ""]"

/proc/tgui_census_note_slow(interface, client/user, kind, ms, extra)
	tgui_census_write("[world.timeofday]ds *** SLOW [kind] [interface] [user?.ckey || "<noclient>"] [round(ms, 0.01)]ms[extra ? " [extra]" : ""]")

/datum/tgui/get_payload(custom_data, with_data, with_static_data)
	if(!GLOB.tgui_census_debug)
		return ..()
	tgui_census_start_flush_loop()
	var/started = TICK_USAGE_REAL
	. = ..()
	var/elapsed = TICK_USAGE_TO_MS(started)
	if(elapsed < 0)
		elapsed = 0
	var/list/record = tgui_census_record(interface)
	record["payloads"] += 1
	record["payload_ms"] += elapsed
	if(elapsed > record["payload_ms_max"])
		record["payload_ms_max"] = elapsed
	if(with_static_data)
		record["full_payloads"] += 1
		record["full_payload_ms"] += elapsed
	var/list/client_record = tgui_census_touch_client(user?.client, "payloads")

	var/bytes = 0
	if(GLOB.tgui_census_payload_bytes && islist(.))
		var/list/payload = .
		bytes = length(json_encode(payload))
		record["bytes"] += bytes
		if(bytes > record["bytes_max"])
			record["bytes_max"] = bytes
		if(client_record)
			client_record["bytes"] += bytes
		if(with_static_data && payload["static_data"])
			var/static_text = json_encode(payload["static_data"])
			record["static_bytes"] += length(static_text)
			var/hash = md5(static_text)
			if(hash == tgui_census_static_hash)
				record["static_repeats"] += 1
			tgui_census_static_hash = hash

	if(GLOB.tgui_census_slow_call_ms && elapsed >= GLOB.tgui_census_slow_call_ms)
		record["slow"] += 1
		if(client_record)
			client_record["slow"] += 1
		tgui_census_note_slow(interface, user?.client, with_static_data ? "full-payload" : "payload", elapsed, "bytes=[bytes]")

/datum/tgui/open()
	. = ..()
	if(!GLOB.tgui_census_debug)
		return
	tgui_census_start_flush_loop()
	tgui_census_opened_at = world.time
	var/list/record = tgui_census_record(interface)
	record["opens"] += 1

/datum/tgui/close(can_be_suspended = TRUE)
	if(GLOB.tgui_census_debug)
		var/list/record = tgui_census_record(interface)
		record["closes"] += 1
		if(tgui_census_opened_at && world.time - tgui_census_opened_at < 2 SECONDS)
			tgui_census_write("[world.timeofday]ds *** SHORT-LIVED [interface] [user?.ckey] alive=[world.time - tgui_census_opened_at]ds suspended=[can_be_suspended ? 1 : 0]")
	return ..()

/datum/tgui/send_full_update(custom_data, force)
	if(GLOB.tgui_census_debug)
		var/list/record = tgui_census_record(interface)
		record["full"] += 1
	return ..()

/datum/tgui/send_update(custom_data, force)
	if(GLOB.tgui_census_debug)
		var/list/record = tgui_census_record(interface)
		record["partial"] += 1
	return ..()

/datum/tgui/process(delta_time, force)
	if(!GLOB.tgui_census_debug)
		return ..()
	var/started = TICK_USAGE_REAL
	. = ..()
	var/elapsed = TICK_USAGE_TO_MS(started)
	if(elapsed < 0)
		elapsed = 0
	var/list/record = tgui_census_record(interface)
	record["process"] += 1
	record["process_ms"] += elapsed

/datum/tgui/on_act_message(act_type, payload, state)
	if(!GLOB.tgui_census_debug)
		return ..()
	var/started = TICK_USAGE_REAL
	. = ..()
	var/elapsed = TICK_USAGE_TO_MS(started)
	if(elapsed < 0)
		elapsed = 0
	var/list/record = tgui_census_record(interface)
	record["acts"] += 1
	record["act_ms"] += elapsed
	if(elapsed > record["act_ms_max"])
		record["act_ms_max"] = elapsed
	var/list/actions = record["actions"]
	var/action_name = copytext(act_type, 5) || "?"
	actions[action_name] = (actions[action_name] || 0) + 1
	tgui_census_touch_client(user?.client, "acts")
	if(GLOB.tgui_census_slow_call_ms && elapsed >= GLOB.tgui_census_slow_call_ms)
		record["slow"] += 1
		tgui_census_note_slow(interface, user?.client, "act/[action_name]", elapsed)

/client/verb/tgui_census_report()
	set name = "TGUI Census Report"
	set category = "Debug.Telemetry"
	set desc = "Dump the current tgui telemetry window to chat and to tgui_census.log."
	if(!check_rights(R_DEBUG))
		return
	if(!length(GLOB.tgui_census_interfaces))
		to_chat(src, span_notice("tgui census: nothing recorded yet (GLOB.tgui_census_debug = [GLOB.tgui_census_debug])."))
		return
	to_chat(src, span_notice("tgui census — open_uis=[length(SStgui.all_uis)]"))
	for(var/interface in GLOB.tgui_census_interfaces)
		to_chat(src, span_info(tgui_census_format(interface, GLOB.tgui_census_interfaces[interface])))
	tgui_census_flush()
