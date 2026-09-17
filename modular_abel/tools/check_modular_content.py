"""Pre-flight for modular content: the unit tests' rules, without a compile.

Every check here exists because a real CI failure got through review first. Run it
after any port and before pushing; it takes seconds and the DM tests take a build.

    python modular_abel/tools/check_modular_content.py
    python modular_abel/tools/check_modular_content.py --module azure_wardrobe -v

What it mirrors, and which test would otherwise catch it:

  sprites      missing_clothing_sprites - the state a type actually inherits has to
               resolve, INCLUDING on abstract parents, which that test does not skip
  details      item_detail_sanity - detail_tag needs detail_color and a `<state><tag>` cell
  obtainable   craftable_clothes - craftable, looted, sold, shop-granted or elixir-made
  loadout      modular_loadout_panel - names unique repo-wide, item_path declared
  elixirs      modular_morphing_elixir - a morph result is a direct subtype of its
               target and changes no armour var

The point is to be *faithful*, not strict: each test's own escape hatches are
reproduced here - the four exclusion lists, CRAFTING_TEST_EXCLUDE, the by-text list,
loot tables, supply packs, and the world-icon short circuit in the sprite test - so a
finding means a red CI run rather than a judgement call. A check that cries wolf stops
being read, which is worse than not having one.

It reads DM as text. It cannot know what the compiler knows, so a clean run means
"none of the traps we have already fallen into", not "this compiles".
"""

import argparse
import collections
import io
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from dmi_extract import parse_description  # noqa: E402

MODULAR = "modular_abel"
SKIP_DIRS = {".git", "node_modules", "__pycache__", "tgui", ".claude"}

TYPE_RE = re.compile(r"^(/[\w/]+)\s*$")
ASSIGN_RE = re.compile(r"^\t([\w/]+)\s*=\s*(.+?)\s*$")
OBJ_RE = re.compile(r"/obj/item/[\w/]+")
CARRIED = ("icon", "icon_state", "mob_overlay_icon", "sleeved", "detail_tag",
           "detail_color", "abstract_type", "item_path", "name", "misc_flags",
           "item_flags", "id", "custom_clothes")
RECIPE_VARS = ("output", "output_item", "created_item", "result_type")
# the five kinds the sprite test demands female and per-species worn cells for
GENDERED_ROOTS = ("/obj/item/clothing/cloak", "/obj/item/clothing/shoes",
                  "/obj/item/clothing/gloves", "/obj/item/clothing/pants",
                  "/obj/item/clothing/shirt")


def walk_dm(root):
    for dirpath, dirnames, files in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for fn in files:
            if fn.endswith(".dm"):
                full = os.path.join(dirpath, fn).replace("\\", "/")
                yield full[2:] if full.startswith("./") else full


def index(root):
    """type path -> {'file', 'vars': {...}}; every type declared under root."""
    types = {}
    for path in walk_dm(root):
        current = None
        try:
            lines = io.open(path, encoding="utf-8", errors="replace").readlines()
        except OSError:
            continue
        for line in lines:
            stripped = line.rstrip("\r\n")
            if stripped[:1] == "/" and not stripped.startswith("//"):
                m = TYPE_RE.match(stripped)
                current = m.group(1) if m else None
                if current:
                    types.setdefault(current, {"file": path, "vars": {}})
                continue
            if not current:
                continue
            a = ASSIGN_RE.match(stripped)
            if a and a.group(1) in CARRIED:
                types[current]["vars"].setdefault(a.group(1), a.group(2))
    return types


def inherited(types, path, key):
    parts = path.strip("/").split("/")
    while parts:
        cand = "/" + "/".join(parts)
        entry = types.get(cand)
        if entry and key in entry["vars"]:
            return entry["vars"][key]
        parts.pop()
    return None


def sheet_states(cache, relpath):
    if relpath not in cache:
        try:
            cache[relpath] = {s["name"] for s in parse_description(relpath)[2]}
        except Exception:
            cache[relpath] = None
    return cache[relpath]


def collect_exclusions():
    """Every way craftable_clothes is told to skip a path, read off the source.

    Four lists live in the upstream test and two GLOBs feed them from the modular
    override. Ignoring them is how the first run of this tool produced 62 findings
    of which 59 were things somebody had already signed off.
    """
    exact, subtree, by_text, subtypes_only = set(), set(), [], set()
    buckets = (
        ("excluded_paths_with_their_subtypes", subtree),
        ("subtree_exclusions", subtree),
        ("excluded_paths_subtypes_only", subtypes_only),
        ("excluded_paths_by_text", by_text),
        ("excluded_paths", exact),
        ("craftable_clothes_exclusions", exact),
    )
    for src in ("code/modules/unit_tests/craftable_clothes.dm",
                MODULAR + "/upstream_fixes.dm"):
        try:
            lines = io.open(src, encoding="utf-8", errors="replace").readlines()
        except OSError:
            continue
        bucket = None
        for line in lines:
            text = line.strip()
            for key, target in buckets:
                if key in text:
                    bucket = target
                    break
            if bucket is None:
                continue
            if text.startswith("/obj/"):
                bucket.add(text.split(",")[0].split("//")[0].strip())
            elif text.startswith('"'):
                bucket.append(text.split(",")[0].strip('", '))
            elif text.startswith(")"):
                bucket = None
    return exact, subtree, by_text, subtypes_only


def collect_handouts():
    """Clothing paths that loot tables and supply packs already put in the world."""
    found = set()
    for path in walk_dm("."):
        try:
            lines = io.open(path, encoding="utf-8", errors="replace").readlines()
        except OSError:
            continue
        inside = False
        for line in lines:
            stripped = line.rstrip("\r\n")
            if stripped[:1] == "/" and not stripped.startswith("//"):
                inside = bool(TYPE_RE.match(stripped)) and (
                    stripped.startswith("/datum/loot_table")
                    or stripped.startswith("/datum/supply_pack"))
            elif inside:
                found.update(OBJ_RE.findall(stripped))
    return found


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--module", action="append", default=[],
                    help="only this modular_abel module (repeatable); default: all of them")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8", errors="replace")

    everything = index(".")
    cache = {}
    problems = collections.defaultdict(list)

    wanted_files = None
    if args.module:
        wanted_files = tuple("%s/%s/" % (MODULAR, m) for m in args.module)

    def ours(entry):
        f = entry["file"]
        if not f.startswith(MODULAR + "/"):
            return False
        return wanted_files is None or f.startswith(wanted_files)

    excluded, excluded_subtrees, excluded_text, excluded_sub_only = collect_exclusions()

    def is_excluded(path):
        if path in excluded:
            return True
        if "CRAFTING_TEST_EXCLUDE" in (inherited(everything, path, "misc_flags") or ""):
            return True
        if any(("/" + word) in path for word in excluded_text):
            return True
        if any(path == sub or path.startswith(sub + "/") for sub in excluded_subtrees):
            return True
        return any(path.startswith(sub + "/") for sub in excluded_sub_only)

    # species whose worn cells the sprite test demands a `<state>_<id>` variant for
    species_ids = []
    for path in sorted(everything):
        if not path.startswith("/datum/species/"):
            continue
        if (inherited(everything, path, "custom_clothes") or "").strip() != "TRUE":
            continue
        sid = (inherited(everything, path, "id") or "").strip('"')
        if sid and sid not in species_ids:
            species_ids.append(sid)

    # everything the shop hands out, and everything an elixir can produce
    granted = set()
    morph_results = set()
    morph_targets = {}
    for path, entry in everything.items():
        if path.startswith("/datum/loadout_item") and "item_path" in entry["vars"]:
            granted.add(entry["vars"]["item_path"])
        if path.startswith("/obj/item/enchantingkit"):
            body = io.open(entry["file"], encoding="utf-8", errors="replace").read()
            block = re.search(r"^%s$\n((?:\t.*\n)*)" % re.escape(path), body, re.M)
            if block:
                for target, result in re.findall(r"^\t\t(\S+) = (\S+),$", block.group(1), re.M):
                    morph_results.add(result)
                    morph_targets.setdefault(path, []).append((target, result))

    # anything any recipe datum produces, plus loot tables and supply packs
    craftable = collect_handouts()
    for path in walk_dm("."):
        try:
            text = io.open(path, encoding="utf-8", errors="replace").read()
        except OSError:
            continue
        for var in RECIPE_VARS:
            craftable.update(re.findall(r"^\t%s = (/obj/\S+)$" % var, text, re.M))

    checked = 0
    for path, entry in sorted(everything.items()):
        # item_detail_sanity walks every /obj/item, not just clothing - the weapon
        # reskins went unchecked once already because a verifier stopped at clothing.
        if not path.startswith("/obj/item") or not ours(entry):
            continue
        clothing = path.startswith("/obj/item/clothing")
        checked += 1
        v = entry["vars"]
        abstract = v.get("abstract_type") == path
        flagged_abstract = "ABSTRACT" in (inherited(everything, path, "item_flags") or "")
        state = (inherited(everything, path, "icon_state") or "").strip('"')

        # --- sprites, abstract parents included -----------------------------
        # The real test skips a null state and stops the moment the world sheet
        # answers, so a finding here is a finding there. `abstract_type` is NOT a
        # skip for it - that is exactly how the helmkleinod parent reached CI.
        if clothing and state and not flagged_abstract:
            world = (inherited(everything, path, "icon") or "").strip("'")
            world_states = sheet_states(cache, world) if world else None
            if world and world_states is None:
                problems["sprites"].append("%s: %s is not a readable .dmi" % (path, world))
            elif world_states is not None and state not in world_states:
                worn = (inherited(everything, path, "mob_overlay_icon") or "").strip("'")
                worn_states = sheet_states(cache, worn) if worn else None
                if worn_states is None:
                    problems["sprites"].append(
                        "%s: %s has no %r%s" % (path, world.split("/")[-1], state,
                                                " (abstract parent - it inherits this state)"
                                                if abstract else ""))
                else:
                    wanted = [state]
                    if path.startswith(GENDERED_ROOTS):
                        wanted += ["%s_f" % state, "%s_f_boob" % state]
                        for sid in species_ids:
                            wanted += ["%s_%s" % (state, sid), "%s_%s_f" % (state, sid),
                                       "%s_%s_f_boob" % (state, sid)]
                    for want in wanted:
                        if want not in worn_states:
                            problems["sprites"].append(
                                "%s: %s has no %r" % (path, worn.split("/")[-1], want))

        # --- detail tag pairing --------------------------------------------
        tag = (v.get("detail_tag") or "").strip('"')
        if tag == "null":
            tag = ""
        if tag:
            if not inherited(everything, path, "detail_color"):
                problems["details"].append("%s: detail_tag %r with no detail_color" % (path, tag))
            sheet = (inherited(everything, path, "icon") or "").strip("'")
            states = sheet_states(cache, sheet) if sheet.startswith(MODULAR + "/") else None
            if states is not None and state + tag not in states:
                problems["details"].append("%s: sheet has no %r cell" % (path, state + tag))

        # --- obtainable at all ---------------------------------------------
        if clothing and not abstract and path not in granted and path not in morph_results \
                and path not in craftable and not is_excluded(path):
            problems["obtainable"].append(
                "%s: no recipe, no loot, not sold, no elixir makes it" % path)

    # --- loadout hygiene, repo-wide ----------------------------------------
    names = collections.Counter()
    for path, entry in everything.items():
        if not path.startswith("/datum/loadout_item"):
            continue
        name = entry["vars"].get("name")
        if name:
            names[name] += 1
        item = entry["vars"].get("item_path")
        if item and item not in everything and ours(entry):
            problems["loadout"].append("%s: item_path %s is not declared anywhere" % (path, item))
    for name, count in names.items():
        if count > 1:
            problems["loadout"].append("loadout name %s used %d times" % (name, count))

    # --- elixir contract ---------------------------------------------------
    for kit, pairs in morph_targets.items():
        if not ours(everything[kit]):
            continue
        for target, result in pairs:
            if target not in everything:
                problems["elixirs"].append("%s: target %s not declared" % (kit, target))
            if not result.startswith(target + "/"):
                problems["elixirs"].append(
                    "%s: %s is not a direct subtype of %s, so the morph can change its stats"
                    % (kit, result, target))
            entry = everything.get(result)
            if entry and any(k.startswith("armor") for k in entry["vars"]):
                problems["elixirs"].append("%s: reskin %s sets an armour var" % (kit, result))

    total = sum(len(v) for v in problems.values())
    print("checked %d modular item types in %s"
          % (checked, ", ".join(args.module) if args.module else "every module"))
    for kind in ("sprites", "details", "obtainable", "loadout", "elixirs"):
        found = problems[kind]
        print("  %-11s %s" % (kind, "clean" if not found else "%d problem(s)" % len(found)))
        for line in found if args.verbose or len(found) <= 12 else found[:12]:
            print("      - %s" % line)
        if not args.verbose and len(found) > 12:
            print("      ... %d more (-v for all)" % (len(found) - 12))
    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main())
