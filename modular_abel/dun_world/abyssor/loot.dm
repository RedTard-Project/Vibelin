/datum/loot_table/dream_material
	name = "dream materials"
	base_min = 1
	base_max = 1
	loot_table = list(
		list(
			/obj/item/dream_material/parchment_raw = 50,
			/obj/item/dream_material/parchment_silver = 25,
		)
	)

/datum/loot_table/dream_material/tier1
	name = "tier 1 dream materials"
	loot_table = list(
		list(
			/obj/item/dream_material/dream_spike = 40,
			/obj/item/dream_material/parchment_raw = 30,
			/obj/item/dream_material/dream_ring = 30,
		)
	)

/datum/loot_table/dream_material/tier2
	name = "tier 2 dream materials"
	loot_table = list(
		list(
			/obj/item/dream_material/dream_effigy = 40,
			/obj/item/dream_material/dream_fishes = 30,
			/obj/item/dream_material/dream_blade = 30,
		)
	)

/datum/loot_table/dream_material/tier3
	name = "tier 3 dream materials"
	loot_table = list(
		list(
			/obj/item/dream_material/dream_shards = 50,
			/obj/item/dream_material/dream_star = 50,
		)
	)

/datum/loot_table/dream_material/seeds
	name = "dream seeds"
	loot_table = list(
		list(
			/obj/item/dream_material/dream_seed = 20,
			/obj/item/dream_material/dream_seed/perception = 20,
			/obj/item/dream_material/dream_seed/fortune = 20,
			/obj/item/dream_material/dream_seed/strength = 15,
			/obj/item/dream_material/dream_seed/speed = 15,
			/obj/item/dream_material/dream_seed/sneaky = 10,
		)
	)

/datum/loot_table/dream_material/parchment
	name = "dream parchments"
	loot_table = list(
		list(
			/obj/item/dream_material/parchment_silver = 60,
			/obj/item/dream_material/parchment_gold = 30,
			/obj/item/dream_material/parchment_dream = 10,
		)
	)

/obj/effect/spawner/map_spawner/loot/dream_material
	name = "dream material spawner"
	loot_table_type = /datum/loot_table/dream_material

/obj/effect/spawner/map_spawner/loot/dream_material/tier1
	name = "tier 1 dream material spawner"
	loot_table_type = /datum/loot_table/dream_material/tier1

/obj/effect/spawner/map_spawner/loot/dream_material/tier2
	name = "tier 2 dream material spawner"
	loot_table_type = /datum/loot_table/dream_material/tier2

/obj/effect/spawner/map_spawner/loot/dream_material/tier3
	name = "tier 3 dream material spawner"
	loot_table_type = /datum/loot_table/dream_material/tier3

/obj/effect/spawner/map_spawner/loot/dream_material/seeds
	name = "dream seed spawner"
	loot_table_type = /datum/loot_table/dream_material/seeds

/obj/effect/spawner/map_spawner/loot/dream_material/parchment
	name = "dream parchment spawner"
	loot_table_type = /datum/loot_table/dream_material/parchment
