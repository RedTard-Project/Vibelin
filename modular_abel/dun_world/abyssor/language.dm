// The tongue of Abyssor's dreamworld.
// Ported from Azure-Peak code/modules/language/roguetown/abyssal.dm.
//
// Azure styles this with its own SPAN_ABYSS chat class. Vanderlin has no such class and
// the chat CSS lives in upstream tgui, so it borrows SPAN_DEEPSPEAK instead - already
// styled, and thematically the Deepfather's own register.

/datum/language/abyssal
	name = "Abyssal"
	desc = "An ancient and mysterious language spoken by those who have a link to Abyssor's Dreamworld."
	speech_verb = "chants"
	ask_verb = "inquires"
	exclaim_verb = "intones"
	key = "q"
	space_chance = 66
	default_priority = 80
	icon_state = "abyssal"
	spans = list(SPAN_DEEPSPEAK)
	syllables = list(
		"shugg", "ph'", "mg", "ftaghu", "nafl", "syha'h", "k'yarnak", "hai", "agl'", "agr'", "rron", "wgah'n", "wgah", "agn", "athg", "ch'",
		"et'af", "enbu", "grah'n", "ng'lgu", "rl'yah", "rl'", "chtu'", "vlah'", "tron", "zluh", "tilgh", "nfah'", "phle'", "gthu'", "ghro", "nyghu",
		"s'uhn", "syh'anr", "ghftu'h", "n'gha-ghaa", "nglw'", "gluh'", "n'gagh'",
	)
