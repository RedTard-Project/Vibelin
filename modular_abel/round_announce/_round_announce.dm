GLOBAL_VAR(round_announce_ping_role)

/datum/config_entry/flag/round_announce_disabled

/datum/config_entry/string/channel_announce_new_game_message/ValidateAndSet(str_val)
	var/static/regex/role_mention = regex(@"<@&[0-9]+>")
	var/static/regex/user_mention = regex(@"<@[0-9]+>")
	GLOB.round_announce_ping_role = null
	if(role_mention.Find(str_val))
		GLOB.round_announce_ping_role = role_mention.match
		str_val = trim(replacetext(str_val, role_mention.match, ""))
	else if(user_mention.Find(str_val))
		log_config("CHANNEL_ANNOUNCE_NEW_GAME_MESSAGE holds [user_mention.match], which mentions a user; a role needs the ampersand form <@&id> and nothing will be pinged")
	return ..(str_val)

#define ROUND_ANNOUNCE_LOBBY "#e0a526"
#define ROUND_ANNOUNCE_STARTED "#4fae52"
#define ROUND_ANNOUNCE_VOTE "#4a8fd4"
#define ROUND_ANNOUNCE_ENDING "#8a5fc4"
#define ROUND_ANNOUNCE_ENDED "#c14444"

/proc/round_announce_field(name, value, inline = TRUE)
	var/datum/tgs_chat_embed/field/field = new("[name]", "[value]")
	field.is_inline = inline
	return field

/proc/round_announce_state()
	if(!SSticker || !SSticker.HasRoundStarted())
		return "Лобби"
	if(SSgamemode && SSgamemode.roundvoteend)
		return "Завершается"
	return SSticker.IsRoundInProgress() ? "Идёт" : "Завершается"

/proc/round_announce_status_fields()
	var/list/admins = get_admin_counts()
	var/list/present = admins["present"]
	. = list(
		round_announce_field("Игроки", length(GLOB.clients)),
		round_announce_field("Гейммастеры", length(present)),
		round_announce_field("Карта", SSmapping?.config?.map_name || "неизвестна")
	)
	if(SSticker?.HasRoundStarted())
		. += round_announce_field("Время истории", ROUND_TIME())
	. += round_announce_field("Состояние", round_announce_state())

/proc/round_announce(title, description, colour, list/fields, ping = FALSE)
	if(CONFIG_GET(flag/round_announce_disabled) || !world.TgsAvailable())
		return

	var/datum/tgs_chat_embed/structure/embed = new
	embed.title = title
	embed.description = description
	embed.colour = colour
	embed.timestamp = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	embed.fields = fields
	if(GLOB.rogue_round_id)
		embed.footer = new /datum/tgs_chat_embed/footer("[GLOB.rogue_round_id]")

	var/text = ""
	if(ping)
		text = GLOB.round_announce_ping_role || ""

	var/datum/tgs_message_content/message = new(text)
	message.embed = embed
	send2chat(message, CONFIG_GET(string/chat_announce_new_game))

/proc/round_announce_lobby_message()
	var/map = SSmapping?.config?.map_name
	round_announce(
		"Сервер запущен!",
		map ? "История вот-вот начнётся на **[map]**." : "История вот-вот начнётся.",
		ROUND_ANNOUNCE_LOBBY
	)

/proc/round_announce_start_message()
	var/map = SSmapping?.config?.map_name
	round_announce(
		"История началась!",
		map ? "Карта: **[map]**" : null,
		ROUND_ANNOUNCE_STARTED
	)

/proc/round_announce_end_message()
	var/list/fields = list(
		round_announce_field("Карта", SSmapping?.config?.map_name || "неизвестна")
	)
	if(SSticker?.round_start_time)
		fields += round_announce_field("История длилась", ROUND_TIME())
	fields += round_announce_field("Грузим карту", SSmapping?.next_map_config?.map_name || "не выбрана")
	round_announce("Конец!", null, ROUND_ANNOUNCE_ENDED, fields)

/datum/controller/subsystem/ticker/Initialize(timeofday)
	. = ..()
	RegisterSignal(src, COMSIG_TICKER_ENTER_PREGAME, PROC_REF(round_announce_lobby))
	RegisterSignal(src, COMSIG_TICKER_ROUND_STARTING, PROC_REF(round_announce_start))

/datum/controller/subsystem/ticker/proc/round_announce_lobby(datum/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(round_announce_lobby_message))

/datum/controller/subsystem/ticker/proc/round_announce_start(datum/source, start_time)
	SIGNAL_HANDLER
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(round_announce_start_message))

/datum/controller/subsystem/vote/initiate_vote(vote_type, initiator_key)
	. = ..()
	if(!.)
		return
	if(vote_type != "restart" && vote_type != "endround")
		return
	round_announce(
		vote_type == "restart" ? "Голосование за рестарт" : "Голосование за конец истории",
		"Игроки решают, продолжать ли историю. На голосование: [DisplayTimeText(CONFIG_GET(number/vote_period))].",
		ROUND_ANNOUNCE_VOTE,
		round_announce_status_fields()
	)

/datum/controller/subsystem/vote/result()
	var/voted_mode = mode
	var/already_ending = SSgamemode?.roundvoteend
	. = ..()
	if(already_ending)
		return
	switch(voted_mode)
		if("endround")
			if(. != "End Round")
				return
			round_announce(
				"Приближается конец истории!",
				"Игроки проголосовали за конец истории. До конца: **[ROUND_END_TIME / (1 MINUTES)] минут**.",
				ROUND_ANNOUNCE_ENDING,
				round_announce_status_fields(),
				TRUE
			)
		if("restart")
			if(. != "Restart Round")
				return
			round_announce(
				"Игроки проголосовали за рестарт!",
				"Сервер вот-вот перезапустится.",
				ROUND_ANNOUNCE_ENDING,
				round_announce_status_fields(),
				TRUE
			)

/world/Reboot(reason = 0, fast_track = FALSE)
	round_announce_end_message()
	return ..()

#undef ROUND_ANNOUNCE_LOBBY
#undef ROUND_ANNOUNCE_STARTED
#undef ROUND_ANNOUNCE_VOTE
#undef ROUND_ANNOUNCE_ENDING
#undef ROUND_ANNOUNCE_ENDED
