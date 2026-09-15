GLOBAL_LIST_EMPTY(dream_pool)

/// One dream, as an object. It carries both language versions itself, so nothing
/// ever matches Russian text against English text — the datum is the key.
/datum/dream
	abstract_type = /datum/dream
	/// Beats shown one after another; dream_sequence() wraps each in "... ...".
	var/list/en
	var/list/ru

/// Always a copy: dream_sequence() consumes the list it is given with Cut(), and
/// handing out the datum's own beats would blank that dream out for the round.
/datum/dream/proc/fragments_for(mob/sleeper)
	var/list/beats = (ui_lang_code(sleeper?.client) == UI_LANG_CODE_RU) ? ru : en
	return beats?.Copy()

/proc/get_dream_pool()
	if(length(GLOB.dream_pool))
		return GLOB.dream_pool
	for(var/datum/dream/path as anything in subtypesof(/datum/dream))
		if(IS_ABSTRACT(path))
			continue
		GLOB.dream_pool += new path
	return GLOB.dream_pool

// Upstream left the body of this commented out, so dreams never fired at all.
/mob/living/carbon/handle_dreams()
	if(prob(10) && !dreaming)
		dream()

// Replaces the upstream combinatorial generator, which stitched dreams together
// from stock /tg/ spaceman word lists (crewmember, ID card, toolbox) and could
// not survive translation: a Russian adjective has to agree with its noun's
// gender, number and case, which a word-by-word generator cannot know.
/mob/living/carbon/dream()
	set waitfor = FALSE
	var/list/pool = get_dream_pool()
	if(!length(pool))
		return

	var/datum/dream/chosen = pick(pool)
	var/list/fragments = chosen.fragments_for(src)
	if(!length(fragments))
		return

	dreaming = TRUE
	dream_sequence(fragments)
