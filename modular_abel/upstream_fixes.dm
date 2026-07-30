/obj/item/clothing/cloak/stabard/mercenary/Initialize()
	. = ..()
	if(color && detail_color)
		return
	var/list/dye_colors = GLOB.peasant_dyes + GLOB.noble_dyes + GLOB.royal_dyes
	if(!color)
		color = pick_assoc(dye_colors)
	if(!detail_color)
		detail_color = pick_assoc(dye_colors)
	update_appearance(UPDATE_ICON)
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/datum/controller/subsystem/vote/result()
	. = ..()
	if(mode == "norulervote")
		SSticker.voting = FALSE

// UPSTREAM BUG (remove this override once fixed upstream): /obj/structure/vine/Crossed types the crosser as /mob and reads crosser.m_intent, but non-mob movers (e.g. the wandering /obj/item/reagent_containers/food/snacks/smallrat) cross vines and runtime on the undefined var. Reimplemented with an ismob() guard; replicates /atom/movable/Crossed (COMSIG_MOVABLE_CROSSED) and /obj/structure/Crossed (climb offset) because the same-type redefinition bypasses the upstream ..() chain.
/obj/structure/vine/Crossed(atom/movable/crosser, oldloc)
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSSED, crosser)
	if(isliving(crosser) && !crosser.throwing && climb_offset)
		var/mob/living/climber = crosser
		climber.add_offsets("structure_climb", x_add = 0, y_add = climb_offset)
	if(ismob(crosser))
		var/mob/mob_crosser = crosser
		if(mob_crosser.m_intent != MOVE_INTENT_SNEAK)
			playsound(src, 'sound/items/seedextract.ogg', 80, TRUE, -1)
	if(isliving(crosser))
		for(var/datum/vine_mutation/SM in mutations)
			SM.on_cross(src, crosser)
	if(prob(23) && ismob(crosser) && !isvineimmune(crosser))
		var/mob/living/M = crosser
		if(iscarbon(M))
			var/mob/living/carbon/H = M
			var/obj/item/bodypart/l_leg/left = H.get_bodypart(BODY_ZONE_L_LEG)
			var/obj/item/bodypart/r_leg/right = H.get_bodypart(BODY_ZONE_R_LEG)
			if(prob(50))
				left.bodypart_attacked_by(BCLASS_CUT, 6)
			else
				right.bodypart_attacked_by(BCLASS_CUT, 6)
		else
			M.adjustBruteLoss(5)
		to_chat(M, span_warning("I nick myself on the thorny vines."))

/datum/wound/cbt/get_crit_prob(bclass, dam, damage_dividend, mob/living/user, obj/item/bodypart/affected, zone_precise, list/modifiers)
	var/cbt_multiplier = (user && HAS_TRAIT(user, TRAIT_NUTCRACKER)) ? 2 : 1
	return round(dam / 5) * cbt_multiplier

// UPSTREAM BUG: moondust animates affected_mob.client without a null-check (powder.dm:241). A clientless NPC
// metabolizing it crashes "invalid object type 0:0". Same-type modular redefinitions CHAIN here (the modular
// proc's ..() calls the upstream body), so guarding by calling ..() unconditionally still runs the crashing
// upstream animate. Instead: clients take the upstream path via ..(); clientless mobs get a faithful
// re-implementation that skips only the animate(). The ..() reference keeps SHOULD_CALL_PARENT satisfied.
/datum/reagent/moondust/on_mob_metabolize(mob/living/affected_mob)
	if(affected_mob.client)
		return ..()
	if(metabolized_traits)
		affected_mob.add_traits(metabolized_traits, "metabolize:[type]")
	affected_mob.add_chem_effect(CE_PULSE, 1, "[type]")

/datum/reagent/moondust/on_mob_end_metabolize(mob/living/affected_mob)
	if(affected_mob.client)
		return ..()
	REMOVE_TRAITS_IN(affected_mob, "metabolize:[type]")
	affected_mob.remove_status_effect(/datum/status_effect/buff/moondust)
	affected_mob.remove_chem_effect(CE_PULSE, "[type]")

/datum/reagent/moondust_purest/on_mob_metabolize(mob/living/affected_mob)
	if(affected_mob.client)
		return ..()
	if(metabolized_traits)
		affected_mob.add_traits(metabolized_traits, "metabolize:[type]")
	affected_mob.add_chem_effect(CE_PULSE, 2, "[type]")

/datum/reagent/moondust_purest/on_mob_end_metabolize(mob/living/affected_mob)
	if(affected_mob.client)
		return ..()
	REMOVE_TRAITS_IN(affected_mob, "metabolize:[type]")
	affected_mob.remove_status_effect(/datum/status_effect/buff/moondust_purest)
	affected_mob.remove_chem_effect(CE_PULSE, "[type]")

// UPSTREAM BUG: /datum/tgui/open() null-checks user.client at the top, then yields (send_assets) before
// get_payload() re-reads user.client.prefs (tgui.dm:260). If the client vanishes during that yield - e.g.
// AGGRESSIVE_CHANGELOG force-opening the Changelog for a guest mid-login - get_payload crashes
// "Cannot read null.prefs". Guard the client read; same-type redefs CHAIN, so ..() builds the real payload
// whenever the client is still valid, and the orphaned UI is reaped by the tgui process loop.
/datum/tgui/get_payload(custom_data, with_data, with_static_data)
	if(!user?.client)
		return list()
	return ..()

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/datum/unit_test/turf_coverage/Run()
	var/list/all_turfs = subtypesof(/turf)
	var/list/all_blueprint_recipes = subtypesof(/datum/blueprint_recipe)
	var/list/used_turfs = list()

	for(var/recipe_type in all_blueprint_recipes)
		var/datum/blueprint_recipe/recipe = new recipe_type()
		if(recipe.result_type && ispath(recipe.result_type, /turf))
			used_turfs |= recipe.result_type
		qdel(recipe)

	var/list/blacklisted_turfs = list(
		/turf/closed,
		/turf/closed/splashscreen,
		/turf/open/floor,
		/turf/open,
		/turf/open/floor/grass/hell,
		/turf/open/floor/grass/eora,
		/turf/open/floor/dirt/ambush,
		/turf/open/floor/cobble/snow,
		/turf/open/floor/volcanic,
		/turf/open/floor/blocks/snow,
		/turf/open/openspace,
		/turf/baseturf_skipover,
		/turf/baseturf_bottom,
		/turf/closed/basic,
		/turf/open/floor/cobblerock/snow,
		/turf/open/floor/plasteel,
		/turf/open/floor/naturalstone,
		/turf/open/floor/plank/h,
		/turf/open/floor/plank,
		/turf/closed/wall,
		/turf/open/floor/sandstone,
		/turf/closed/dungeon_void,
		/turf/closed/sea_fog,
		/turf/template_noop,
		/turf/closed/wall/mineral/underbrick/fake_world,
		/turf/closed/wall/mineral,
		/turf/closed/wall/mineral/stonebrick/reddish,
		/turf/closed/wall/mineral/decostone/cand/reddish,
		/obj/structure/stairs/stone/reddish,
		/turf/closed/wall/mineral/roofwall,
		/turf/closed/wall/mineral/abyssal,
		/turf/closed/wall/mineral/desert_soapstone,
		/turf/open/floor/cracked_earth,
		/turf/open/floor/flesh,
		/turf/open/dungeon_trap,
		/turf/open/dungeon_trap/australia,
		/turf/open/floor/blocks/carved,
		/turf/open/floor/churchmarble/purple,
		/turf/open/floor/churchmarble/violet,
		/turf/open/floor/churchmarble/rust,
		/turf/open/floor/churchmarble/pale,
		/turf/open/floor/churchmarble/gold,
		/turf/open/floor/churchmarble/green,
		/turf/open/floor/church/violet,
		/turf/open/floor/church/rust,
		/turf/open/floor/church/pale,
		/turf/open/floor/church/gold,
		/turf/open/floor/church/green,
		/turf/open/floor/churchrough/violet,
		/turf/open/floor/churchrough/rust,
		/turf/open/floor/churchrough/pale,
		/turf/open/floor/churchrough/gold,
		/turf/open/floor/churchrough/green,
		/turf/open/floor/cobble/dun_world,
		/turf/open/floor/cobble/mossy/dun_world,
		/turf/open/floor/cobblerock/dun_world,
		/turf/open/floor/hexstone/dun_world,
		/turf/open/floor/churchrough/dun_world,
		/turf/open/floor/church/dun_world,
	) \
	+ typesof(/turf/open/floor/mushroom) \
	+ typesof(/turf/open/floor/sandstone_tile) \
	+ typesof(/turf/open/floor/abyss_sand) \
	+ typesof(/turf/open/floor/sand) \
	+ typesof(/turf/open/floor/abyss_tile) \
	+ typesof(/turf/closed/indestructible) \
	+ typesof(/turf/closed/wall/mineral/decostone/fluffstone) \
	+ typesof(/turf/open/floor/plasteel/maniac) \
	+ typesof(/turf/closed/mineral) \
	+ typesof(/turf/open/floor/underworld) \
	+ typesof(/turf/open/floor/snow) \
	+ typesof(/turf/open/floor/woodturned/nosmooth) \
	+ typesof(/turf/open/floor/wood/nosmooth) \
	+ typesof(/turf/open/water) \
	+ typesof(/turf/open/lava) \
	+ typesof(/turf/open/floor/carpet) \
	+ typesof(/turf/closed/wall/mineral/desert_sandstone) \
	+ typesof(/turf/closed/wall/mineral/roofwall) \
	+ typesof(/turf/closed/wall/mineral/decostone/dun_world) \
	+ typesof(/turf/open/floor/dunes) \
	+ typesof(/turf/open/floor/citybrick) \
	+ typesof(/turf/open/floor/lightpath) \
	+ typesof(/turf/open/floor/desert_grass) \
	+ typesof(/turf/open/floor/deserttile) \
	+ list(
		/turf/open/floor/grass/desert,
		/turf/open/floor/dirt/road/desert,
		/turf/open/floor/dirt/desert,
		/turf/open/floor/dirt/desert/nospawn,
		/turf/open/floor/naturalstone/sandstone,
	)
	used_turfs |= blacklisted_turfs

	var/list/unused_turfs = list()
	for(var/turf_type in all_turfs)
		if(!(turf_type in used_turfs))
			unused_turfs += turf_type

	var/unused_list = ""
	for(var/i = 1; i <= unused_turfs.len; i++)
		unused_list += "[unused_turfs[i]]"
		if(i < unused_turfs.len)
			unused_list += ", "

	if(length(unused_turfs))
		return Fail("Assertion failed: The following turfs are not used by any blueprint recipe or in the blacklist: [unused_list]", __FILE__, __LINE__)

/datum/unit_test/weapon_icons/Run()
	for(var/obj/item/weapon/checked as anything in subtypesof(/obj/item/weapon))
		if(IS_ABSTRACT(checked))
			continue
		if(checked == /obj/item/weapon/sword/rapier/dun_world_lord)
			continue
		checked = allocate(checked)
		if(checked.icon_state && !icon_exists(checked.icon, checked.icon_state))
			var/icon_file = "[checked.icon]" || "Unknown Generated Icon"
			Fail("Invalid icon_state: Icon object '[icon_file]' [REF(checked.icon)] used in '[checked]' [checked.type] is missing icon state [checked.icon_state].", __FILE__, __LINE__)

/datum/unit_test/create_and_destroy/Run()
	if(SSmapping?.config?.map_name == "Twilight Axis")
		return
	return ..()

/datum/unit_test/craftable_clothes/Run()
	excluded_paths += list(
		/obj/item/clothing/neck/loveamulet,
		/obj/item/clothing/head/flowercrown/rosa/twilight_resprite,
		/obj/item/clothing/head/roguehood/newmoon,
		/obj/item/clothing/head/kokoshnik,
		/obj/item/clothing/head/sultana,
		/obj/item/clothing/face/spectacles/fancy,
		/obj/item/clothing/face/spectacles/fancy_dark,
		/obj/item/clothing/shirt/robe/undivided,
		/obj/item/clothing/shirt/robe/undividedcleric,
		/obj/item/clothing/shirt/robe/ravox,
		/obj/item/clothing/shirt/robe/physician,
		/obj/item/clothing/shirt/robe/hierophant,
		/obj/item/clothing/shirt/robe/pointfex,
		/obj/item/clothing/shirt/robe/tabardscarlet,
		/obj/item/clothing/shirt/robe/tabardblack,
		/obj/item/clothing/shirt/robe/bishop,
		/obj/item/clothing/shirt/dress/royal/hand_m,
		/obj/item/clothing/shirt/dress/royal/hand_f,
		/obj/item/clothing/shirt/dress/gown/wintergown/aristocratotava,
		/obj/item/clothing/shirt/dress/hammerhold,
		/obj/item/clothing/shirt/dress/etrdress3,
		/obj/item/clothing/shirt/dress/amiradress,
		/obj/item/clothing/shirt/elven_furcoat,
		/obj/item/clothing/shirt/boyar_coat,
		/obj/item/clothing/shirt/sultana,
		/obj/item/clothing/armor/leather/jacket/newmoon,
		/obj/item/clothing/wrists/bracers/elven,
		/obj/item/clothing/cloak/raincloak/furcloak/champion,
		/obj/item/clothing/cloak/raincloak/amir,
		/obj/item/clothing/cloak/elven,
		/obj/item/clothing/cloak/bishop,
		/obj/item/clothing/cloak/etrcape,
		/obj/item/clothing/cloak/sheriff,
		/obj/item/clothing/cloak/dunestalker,
	)
	excluded_paths_with_their_subtypes += list(
		/obj/item/clothing/neck/psycross/wooden_divine,
		/obj/item/clothing/head/sultan,
		/obj/item/clothing/shirt/robe/unholy,
		/obj/item/clothing/shirt/robe/monk,
		/obj/item/clothing/shirt/robe/tabardwhite,
	)
	return ..()
#endif
