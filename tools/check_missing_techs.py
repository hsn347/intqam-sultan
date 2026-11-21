import json
import sys
sys.path.insert(0, '.')
from tasks.base_task import _load_march_data_tables

tables = _load_march_data_tables()
tech_tables = tables.get('techs', {})

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

tctrl = d1.get('technologyCtrl', {})
missing = []
for tid_str in tctrl:
    if str(tid_str) not in tech_tables:
        missing.append(tid_str)
print("Missing techs from tech_tables:", missing)
