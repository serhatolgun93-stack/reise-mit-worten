#!/usr/bin/env python3
from __future__ import annotations
import json
from pathlib import Path
import re
import sys
ROOT = Path(__file__).resolve().parents[1]
QA = ROOT / 'qa'
required = ['golden_journey_matrix.json','current_release_gate.json','release_gate_template.json','build_execution_status.json']
errors=[]
for name in required:
    if not (QA/name).exists(): errors.append(f'missing qa/{name}')
matrix_path=QA/'golden_journey_matrix.json'
if matrix_path.exists():
    matrix=json.loads(matrix_path.read_text(encoding='utf-8'))
    if matrix.get('mandatory_count') != 46: errors.append('qa/golden_journey_matrix.json mandatory_count must equal 46')
    required_real={'GJ-23','GJ-28','GJ-33','GJ-34','GJ-35','GJ-36','GJ-37'}
    declared_real=set(matrix.get('real_device_required',[]))
    if declared_real != required_real: errors.append('real_device_required set differs from the VS1 release-gate contract')
catalog_path=ROOT/'lib'/'application'/'release'/'golden_journey_catalog.dart'
if not catalog_path.exists():
    errors.append('missing Dart GoldenJourneyCatalog')
else:
    text=catalog_path.read_text(encoding='utf-8')
    ids=re.findall(r"id:\s*'((?:GJ)-\d{2})'",text)
    expected=[f'GJ-{i:02d}' for i in range(1,47)]
    if ids != expected:
        missing=[x for x in expected if x not in ids]
        duplicates=sorted({x for x in ids if ids.count(x)>1})
        if missing: errors.append('missing golden journeys in Dart catalog: '+', '.join(missing))
        if duplicates: errors.append('duplicate golden journeys in Dart catalog: '+', '.join(duplicates))
        if not missing and not duplicates: errors.append('Golden Journey Dart catalog is not ordered exactly GJ-01..GJ-46')
workflow=ROOT/'.github'/'workflows'/'vs1-build-gate.yml'
if not workflow.exists():
    errors.append('missing .github/workflows/vs1-build-gate.yml')
else:
    w=workflow.read_text(encoding='utf-8')
    for required_snippet in ['flutter analyze','flutter test --reporter expanded','flutter build apk --debug','flutter build ios --debug --no-codesign','FLUTTER_VERSION: 3.44.7']:
        if required_snippet not in w: errors.append(f'CI workflow missing: {required_snippet}')
if errors:
    print('CI_RELEASE_GATE_PREFLIGHT: FAIL')
    for e in errors: print(f' - {e}')
    sys.exit(1)
print('CI_RELEASE_GATE_PREFLIGHT: PASS')
print('Golden Journeys GJ-01..GJ-46 are catalogued in exact order.')
print('The seven mandatory real-device journeys are declared correctly.')
print('Real-device and unexecuted checks remain NOT_RUN until executed.')
