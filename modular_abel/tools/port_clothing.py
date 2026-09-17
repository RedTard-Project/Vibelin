import argparse
import io
import json
import os
import re
import sys

TYPE_RE = re.compile(r"^(/[\w/]+)\s*$")
ASSIGN_RE = re.compile(r"^\s+([\w/]+)\s*=\s*(.+?)\s*$")
SKIP_DIRS = {".git", "node_modules", "__pycache__", "tgui", "tools", ".github", ".claude"}

CARRIED = (
    "name",
    "desc",
    "icon",
    "icon_state",
    "mob_overlay_icon",
    "sleeved",
    "sleevetype",
    "slot_flags",
    "body_parts_covered",
    "allowed_race",
    "allowed_sex",
    "alternate_worn_layer",
    "armor_type",
    "blocksound",
    "boobed",
    "color",
    "detail_color",
    "detail_tag",
    "dropshrink",
    "hoodtype",
    "inhand_mod",
    "item_state",
    "nodismemsleeves",
    "salvage_result",
    "sellprice",
    "smeltresult",
    "toggle_icon_state",
)


def index_types(root):
    """type path -> {'file', 'line', 'vars': {...}} for every DM type block in a repo."""
    types = {}
    root = os.path.abspath(root)
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for filename in filenames:
            if not filename.endswith(".dm"):
                continue
            full = os.path.join(dirpath, filename)
            rel = os.path.relpath(full, root).replace("\\", "/")
            current = None
            try:
                lines = io.open(full, encoding="utf-8", errors="replace").readlines()
            except OSError:
                continue
            for number, line in enumerate(lines, 1):
                stripped = line.rstrip("\n")
                if stripped[:1] == "/" and not stripped.startswith("//"):
                    match = TYPE_RE.match(stripped)
                    if match:
                        current = match.group(1)
                        entry = types.setdefault(
                            current, {"file": rel, "line": number, "vars": {}}
                        )
                        entry.setdefault("file", rel)
                    else:
                        current = None
                    continue
                if not current:
                    continue
                assign = ASSIGN_RE.match(stripped)
                if assign and assign.group(1) in CARRIED:
                    types[current]["vars"].setdefault(assign.group(1), assign.group(2))
    return types


def inherited(types, path, key):
    """Walk the donor type chain upwards until someone sets `key`."""
    parts = path.strip("/").split("/")
    while parts:
        candidate = "/" + "/".join(parts)
        entry = types.get(candidate)
        if entry and key in entry["vars"]:
            return entry["vars"][key], candidate
        parts.pop()
    return None, None


def vibelin_parent(our_types, donor_path, table):
    """Best guess at where this donor type's parent lives here."""
    parent = "/" + "/".join(donor_path.strip("/").split("/")[:-1])
    tried = []
    for candidate in (
        table.get(parent),
        parent,
        parent.replace("/roguetown", ""),
        parent.replace("/suit/roguetown", "").replace("/suit", ""),
        parent.replace("/roguetown", "").replace("/suit/", "/"),
    ):
        if not candidate or candidate in tried:
            continue
        tried.append(candidate)
        if candidate in our_types:
            return candidate, True
    return parent.replace("/roguetown", ""), False


def main():
    parser = argparse.ArgumentParser(
        description="Pull a donor fork's clothing types apart for a modular port: "
        "resolves each type's inherited sheets, guesses the local parent, and "
        "prints a dmi_merge spec plus a DM draft. Read-only; writes nothing."
    )
    parser.add_argument("--donor", required=True)
    parser.add_argument("--ours", default=".")
    parser.add_argument(
        "--types",
        required=True,
        help="file with one donor type path per line, blank lines and # ignored",
    )
    parser.add_argument("--module", default="ported", help="module name for icon paths")
    parser.add_argument("--json", default=None, help="also dump the resolved data here")
    args = parser.parse_args()

    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8", errors="replace")

    wanted = []
    for line in io.open(args.types, encoding="utf-8"):
        line = line.split("#")[0].strip()
        if line:
            wanted.append(line)

    donor = index_types(args.donor)
    ours = index_types(args.ours)

    table = {}
    config = os.path.join(args.ours, "modular_abel/dun_world/config/map.json")
    if os.path.isfile(config):
        table = json.load(io.open(config, encoding="utf-8")).get("replacements", {})

    resolved = []
    for path in wanted:
        entry = donor.get(path)
        if not entry:
            print("MISSING in donor: %s" % path, file=sys.stderr)
            continue
        item = {"donor_path": path, "file": entry["file"], "vars": dict(entry["vars"])}
        for key in ("icon", "icon_state", "mob_overlay_icon", "sleeved", "name", "desc"):
            if key not in item["vars"]:
                value, source = inherited(donor, path, key)
                if value is not None:
                    item["vars"][key] = value
                    item.setdefault("inherited", {})[key] = source
        parent, exists = vibelin_parent(ours, path, table)
        item["local_parent"] = parent
        item["local_parent_exists"] = exists
        item["local_path"] = parent + "/" + path.strip("/").split("/")[-1]
        item["already_here"] = item["local_path"] in ours
        resolved.append(item)

    def unquote(value):
        return (value or "").strip().strip("'").strip('"')

    print("# dmi_merge spec (item sheet)")
    sheets = {}
    for item in resolved:
        sheet = unquote(item["vars"].get("icon"))
        state = unquote(item["vars"].get("icon_state"))
        if sheet and state:
            sheets.setdefault(sheet, []).append(state)
    for sheet, states in sheets.items():
        print(os.path.join(args.donor, sheet).replace("\\", "/"))
        for state in sorted(set(states)):
            print("\t%s" % state)

    print("\n# dmi_merge spec (worn sheet)")
    worn = {}
    for item in resolved:
        sheet = unquote(item["vars"].get("mob_overlay_icon"))
        state = unquote(item["vars"].get("icon_state"))
        if sheet and state:
            worn.setdefault(sheet, []).append(state)
    for sheet, states in worn.items():
        print(os.path.join(args.donor, sheet).replace("\\", "/"))
        for state in sorted(set(states)):
            print("\t%s -> %s" % (state, state))

    print("\n# DM draft")
    for item in resolved:
        flag = "" if item["local_parent_exists"] else "   # PARENT NOT FOUND"
        if item["already_here"]:
            flag = "   # ALREADY EXISTS HERE"
        print("%s%s" % (item["local_path"], flag))
        print("\tname = %s" % item["vars"].get("name", '"?"'))
        print("\tdesc = %s" % item["vars"].get("desc", '"?"'))
        print("\ticon = 'modular_abel/%s/icons/%s_world.dmi'" % (args.module, args.module))
        if item["vars"].get("mob_overlay_icon"):
            print(
                "\tmob_overlay_icon = 'modular_abel/%s/icons/%s_onmob.dmi'"
                % (args.module, args.module)
            )
        if item["vars"].get("sleeved"):
            print(
                "\tsleeved = 'modular_abel/%s/icons/%s_sleeves.dmi'"
                % (args.module, args.module)
            )
        print("\ticon_state = %s" % item["vars"].get("icon_state", '"?"'))
        for key in ("slot_flags", "body_parts_covered", "allowed_race", "allowed_sex",
                    "alternate_worn_layer", "boobed", "sleevetype", "nodismemsleeves",
                    "detail_tag", "toggle_icon_state", "dropshrink"):
            if key in item["vars"] and key not in ("icon", "icon_state"):
                print("\t%s = %s   # from donor" % (key, item["vars"][key]))
        print()

    if args.json:
        io.open(args.json, "w", encoding="utf-8", newline="\n").write(
            json.dumps(resolved, indent=2, ensure_ascii=False) + "\n"
        )
        print("resolved %d types -> %s" % (len(resolved), args.json), file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
