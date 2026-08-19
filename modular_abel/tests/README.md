# tests — unit tests for the modular content

`_tests.dm` is wrapped in `#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)` and included from
`modular_abel/_module.dm`, so it compiles only in a test build and never touches upstream's
`code/modules/unit_tests/_unit_tests.dm`. The `ticked_file_enforcement` CI stage only scans
`code/modules/unit_tests/`, so nothing there needs updating when a test is added here.

These deliberately do **not** duplicate upstream coverage. `missing_clothing_sprites` already
checks every clothing icon_state and `craftable_clothes` already checks every garment has a
recipe. What follows is what upstream's suite cannot see.

| Test | Guards |
| --- | --- |
| `modular_loadout_roundtrip` | The panel's key contract: every `"path"` it sends must resolve back through `GLOB.loadout_items`, and the advertised `iconClass` must be derived from the same key the spritesheet files the icon under. This is the test that caught the panel never working at all. |
| `modular_loadout_panel` | Abstract `item_path`, duplicate loadout names, spritesheet id collisions, a missing `ui_category`, missing or broken `ui_icon_state` on our own entries, and a non-empty Azure Content tab. Upstream entries only raise a `::notice` so their pre-existing debt cannot turn CI red. |
| `modular_loadout_slots` | The tier table the panel advertises matches the defines, and slots increase per tier. |
| `modular_stash_naming` | Three copies of one pick produce three distinct stash entries rather than overwriting each other. |
| `modular_morphing_elixir` | Every kit maps onto a type the result inherits from, the result is concrete and not the target itself, keys are ordered specific-first so none is unreachable, and the swap changes no armour value. This is what keeps reskins cosmetic. |
| `modular_test_exclusions` | The modular additions to upstream's unit-test exclusion lists are non-empty and have no duplicates — a refactor emptied one of them once and nothing noticed. |
| `modular_telemetry` | Every counter `tgui_census_format()` prints exists in the record, a flush resets the window, and `topic_census_classify()` still classifies tgui/act/legacy/empty hrefs. |
| `modular_abyssor_gating` | No `/datum/map_config` turns `abyssor_cult` on in code; it is a per-map json switch. |

## Gotchas when adding a test here

- **The `TEST_ASSERT` macros are gone.** `code/modules/unit_tests/_unit_tests.dm` `#undef`s
  `TEST_ASSERT`, `TEST_ASSERT_EQUAL` and `TEST_ASSERT_NOTEQUAL` at the end of the file, and this
  module is included after it in the DME. `TEST_FAIL`, `TEST_ASSERT_NOTNULL`, `TEST_ASSERT_NULL`
  and `TEST_NOTICE` survive — use those.
- **`initial()` on a `/list` var returns nothing useful.** List vars are built per instance, so
  `initial(some_type.target_items)` is empty. Use `allocate(some_type)` and read the instance.
- **Protected vars need the `:` operator.** `armor_type` is `VAR_PROTECTED` on `/atom`
  (`code/game/atom/atoms.dm:147`) and SpacemanDMM runs with `protected_var = "error"`, so
  `initial(thing.armor_type)` fails the DreamChecker CI stage from outside the atom tree.
  Read it as `initial(thing:armor_type)`, the same way `/proc/build_armor_item_usage_cache` in
  `code/datums/armor/_armor_compare.dm` does.
- **Do not create `/datum/mind` casually.** Minds hard-delete unless `soulOwner` is cleared;
  `modular_abel/upstream_fixes.dm` patches that, but a leaked mind fails `create_and_destroy`.

## Running them

CI defines `UNIT_TESTS` automatically when `CIBUILDING` is set. Locally, uncomment
`#define UNIT_TESTS` in `code/_compile_options.dm`, compile, then run the server headless and
check for `clean_run.lk`:

```
dreamdaemon vanderlin.dmb -close -trusted -verbose -params "log-directory=unittest"
```

Results land in `data/logs/unittest/tests.log`; `::notice` annotations go to `runtime.log`.
Remember to put `_compile_options.dm` back — that file belongs to the maintainer.
