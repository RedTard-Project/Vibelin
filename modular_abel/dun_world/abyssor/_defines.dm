// Abyssor dream-cult content pack, ported from Azure-Peak for the Twilight Axis map.
//
// Everything under modular_abel/dun_world/abyssor/ is gated behind the per-map
// `abyssor_cult` switch declared in map_config.dm, so the types compile on every
// map but only ever become reachable on maps that opt in via their _maps/*.json.
// Twilight Axis (dun_world) is the only map that opts in today.

/// TRUE when the running map opted into the Abyssor dream cult in its map json.
#define ABYSSOR_CULT_ENABLED (SSmapping?.config?.abyssor_cult)

/// Advclass category tag for the Painter's subclasses.
#define CTAG_PAINTER "CAT_PAINTER"

/// Job display order - the Painter sits between the Acolyte and the Gravetender.
#define JDO_PAINTER 14.5

/// Trait source used by pylon infusions.
#define TRAIT_INFUSION "dream_pylon_infusion"
