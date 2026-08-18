# sundries — odds and ends from the Azure-Peak port

Items added upstream after Vibelin PR #5 that did not belong to any of the clothing batches.

## What is ported

- **Traditional Psydonian tabard.** Azure hangs it off `cloak/tabard/psydontabard`, which does
  not exist here, so per the "variation on what is in stock" rule it is declared straight off
  our own `/obj/item/clothing/cloak/tabard` as `psydon_traditional`. Sewn from cloth.
- **Apple and mentha-apple zigs.**

## Adaptations

- **Zig reagents.** Azure loads these with `/datum/reagent/drug/westleach`, `/apple` and
  `/mentha`; Vanderlin has none of the three. Importing a reagent line for two cigarettes is
  out of proportion, so both are built on our own nicotine at the same total potency. They are
  flavour items — the taste lives in the name and description, not in a bespoke reagent.
  If the westleach line is ever ported, these should be repointed at it.

## Not ported

- **The bared traditional tabard** (`psydontabard/white/alt`). It declares
  `icon_state = "whitepsydontabard_alt"` and no such state exists in Azure's own `cloaks.dmi`
  or onmob sheet — the same defect as its bared toga and its banneret sallet.

## Assets

`icons/sundries_world.dmi` / `sundries_onmob.dmi` — the `whitepsydontabard` state extracted
from Azure's `cloaks.dmi` and `onmob/cloaks.dmi`.
