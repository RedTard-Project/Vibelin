import os
import re
import sys

ROOTS = ['code', 'modular_abel']
declared = set()
abstract = set()

DECLARATION = re.compile(r'^(/[\w/]+)\s*$')
ABSTRACT_VAR = re.compile(r'^\s+abstract_type\s*=\s*(/[\w/]+)\s*$')

for root_dir in ROOTS:
    for root, dirs, files in os.walk(root_dir):
        for fn in files:
            if not fn.endswith('.dm'):
                continue
            with open(os.path.join(root, fn), encoding='utf-8', errors='replace') as f:
                current = None
                for line in f:
                    if not line.startswith('/'):
                        m = ABSTRACT_VAR.match(line.rstrip('\r\n'))
                        if m and m.group(1) == current:
                            abstract.add(current)
                        continue
                    if line.startswith('//'):
                        continue
                    m = re.match(r'^(/[\w/]+)', line)
                    if not m:
                        continue
                    path = m.group(1)
                    declaration = DECLARATION.match(line.rstrip('\r\n'))
                    current = declaration.group(1) if declaration else None
                    parts = path.split('/')
                    for i in range(2, len(parts) + 1):
                        declared.add('/'.join(parts[:i]))

print(f"declared (with ancestors): {len(declared)}, abstract: {len(abstract)}")

bad = {}
placed_abstract = {}
for map_path in sys.argv[1:]:
    with open(map_path, encoding='utf-8', errors='replace') as f:
        for line_no, line in enumerate(f, 1):
            if line.startswith('('):
                break
            m = re.match(r'^(/[\w/]+)[,{)]', line)
            if not m:
                continue
            p = m.group(1)
            if p not in declared:
                bad.setdefault(p, (map_path, line_no))
            elif p in abstract:
                placed_abstract.setdefault(p, (map_path, line_no))

failed = False

if bad:
    failed = True
    print(f"MISSING TYPES: {len(bad)}")
    for p, (mp, ln) in sorted(bad.items()):
        print(f"  {p}  (first: {mp}:{ln})")

if placed_abstract:
    failed = True
    print(f"ABSTRACT TYPES: {len(placed_abstract)}")
    for p, (mp, ln) in sorted(placed_abstract.items()):
        print(f"  {p}  (first: {mp}:{ln})")

if failed:
    sys.exit(1)
print("all map paths resolve and are concrete")
