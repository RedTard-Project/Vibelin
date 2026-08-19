/datum/loadout_item
	/// Shows the item under the panel's donator tab instead of its own category.
	var/panel_donator = FALSE

/// Null when the client may take this item from the loadout panel, otherwise the reason it cannot.
/datum/loadout_item/proc/panel_block_reason(client/user_client)
	if(loadout_flags & LOADOUT_FLAG_NO_EQUIP)
		return "Недоступно."
	if(loadout_flags & LOADOUT_FLAG_GIVEAWAY_ONLY)
		return "Только с розыгрышей."
	if((loadout_flags & LOADOUT_FLAG_PATREON_LOCKED) && !user_client?.patreon?.is_donator())
		return "Требуется донат-статус."
	if(required_award && !is_unlocked_for(user_client))
		return "Требуется достижение."
	return null
