#!/usr/bin/env python3
from pathlib import Path
import json, re, sys
root=Path(__file__).resolve().parents[1]
issues=[]
warnings=[]
required=['pubspec.yaml','lib/main.dart','analysis_options.yaml','qa/golden_journey_matrix.json','qa/current_release_gate.json']
for rel in required:
    if not (root/rel).exists(): issues.append(f'missing required file: {rel}')
pub=(root/'pubspec.yaml').read_text(encoding='utf-8')
for rel in re.findall(r'^\s*-\s+(assets/[^\n]+/?)\s*$', pub, re.M):
    if not (root/rel).exists(): issues.append(f'missing asset path: {rel}')
def project_dart_files():
    for p in root.rglob('*.dart'):
        try: rel=p.relative_to(root)
        except ValueError: continue
        if rel.parts and rel.parts[0] in {'.flutter-sdk','.dart_tool','build','android','ios'}: continue
        yield p
for p in project_dart_files():
    txt=p.read_text(encoding='utf-8')
    for imp in re.findall(r"(?:import|export|part)\s+'([^']+)'", txt):
        if imp.startswith(('dart:','package:')): continue
        target=(p.parent/imp).resolve()
        if not target.exists(): warnings.append(f'{p.relative_to(root)} -> missing {imp}')
for p in (root/'qa').glob('*.json'):
    try: json.loads(p.read_text(encoding='utf-8'))
    except Exception as e: issues.append(f'invalid json {p.name}: {e}')
project_files=list(project_dart_files())
print(f'Dart files: {len(project_files)}')
print(f'Test files: {sum(1 for p in project_files if p.relative_to(root).parts[0] == "test")}')
print(f'Android runner: {"YES" if (root/"android").is_dir() else "NO"}')
print(f'iOS runner: {"YES" if (root/"ios").is_dir() else "NO"}')
if warnings:
    print('STATIC_PREFLIGHT WARNINGS:')
    for w in warnings: print(' -', w)
if issues:
    print('STATIC_PREFLIGHT: FAIL')
    for i in issues: print(' -',i)
    sys.exit(1)
print('STATIC_PREFLIGHT: PASS')
