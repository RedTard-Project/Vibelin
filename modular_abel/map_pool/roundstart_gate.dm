/datum/config_entry/number/map_pool_min_ready_players
	config_entry_value = 1
	integer = TRUE
	min_val = 0

/datum/config_entry/number/map_pool_min_connected_players
	config_entry_value = 1
	integer = TRUE
	min_val = 0

/datum/controller/subsystem/ticker/var/map_pool_hold_announced = FALSE

/datum/controller/subsystem/ticker/checkreqroles()
	if(start_immediately)
		map_pool_hold_announced = FALSE
		job_change_locked = TRUE
		return TRUE

	var/connected = 0
	for(var/client/checked as anything in GLOB.clients)
		if(checked)
			connected++

	var/ready = 0
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player?.client && player.ready == PLAYER_READY_TO_PLAY)
			ready++

	var/min_connected = CONFIG_GET(number/map_pool_min_connected_players)
	var/min_ready = CONFIG_GET(number/map_pool_min_ready_players)

	if(connected < min_connected || ready < min_ready)
		if(!map_pool_hold_announced)
			map_pool_hold_announced = TRUE
			log_game("ROUNDSTART HOLD: connected=[connected]/[min_connected] ready=[ready]/[min_ready]")
			if(connected)
				to_chat(world, span_purple("The gods wait for willing hands. [ready]/[min_ready] souls stand ready."))
		return FALSE

	map_pool_hold_announced = FALSE
	job_change_locked = TRUE
	return TRUE
