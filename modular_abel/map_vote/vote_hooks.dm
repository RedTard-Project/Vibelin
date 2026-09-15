/datum/controller/subsystem/vote/initiate_vote(vote_type, initiator_key)
	. = ..()
	if(. && vote_type == "map")
		GLOB.map_vote_panel?.broadcast()

/datum/controller/subsystem/vote/reset()
	. = ..()
	GLOB.map_vote_panel?.close_all()

/datum/controller/subsystem/vote/interface(client/C)
	if(mode != "map" || !C)
		return ..()
	voting -= C
	C << browse(null, "window=vote")
	if(C.mob)
		GLOB.map_vote_panel?.ui_interact(C.mob)
	return "<h2>Map Vote</h2><p>Map voting has its own panel now.</p><p>Use <b>OOC &rarr; Map Vote</b> if it did not open.</p>"
