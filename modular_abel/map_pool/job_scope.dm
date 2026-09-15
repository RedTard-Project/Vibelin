/datum/map_adjustment/var/list/exclusive_jobs

/datum/controller/subsystem/job/SetupOccupations()
	. = ..()
	if(!.)
		return
	map_pool_apply_job_scope()

/datum/controller/subsystem/job/proc/map_pool_apply_job_scope()
	var/datum/map_adjustment/active = SSmapping?.map_adjustment
	var/list/allowed = list()
	if(active)
		for(var/job_type in active.exclusive_jobs)
			allowed |= job_type

	var/list/foreign = list()
	for(var/datum/map_adjustment/adjust as anything in subtypesof(/datum/map_adjustment))
		if(active && adjust == active.type)
			continue
		for(var/job_type in adjust.exclusive_jobs)
			if(job_type in allowed)
				continue
			foreign |= job_type

	if(!length(foreign))
		return

	var/list/stripped = list()
	for(var/job_type in foreign)
		var/datum/job/job = type_occupations[job_type]
		if(!job)
			continue
		job.spawn_positions = 0
		job.total_positions = 0
		job.job_flags &= ~JOB_NEW_PLAYER_JOINABLE
		joinable_occupations -= job
		stripped += job.title

	if(length(stripped))
		log_mapping("map_pool: withheld [length(stripped)] map-exclusive job(s) from [SSmapping?.config?.map_name || "an unknown map"]: [stripped.Join(", ")]")
