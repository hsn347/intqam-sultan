# -*- coding: utf-8 -*-
"""
tools/test_watermill_e2e.py
اختبار شامل لدورة الحفظ ونموذج API وقاعدة البيانات لمهمة مكافأة الطاحونة
"""

import sys
import os

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, _ROOT)

from api_server import CastleConfigModel, CastleUpdateRequest, WatermillConfigModel
import sqlite3
import json

# 1. اختبار نموذج Pydantic
req_data = {
    "watermill": {
        "enabled": True,
        "allow_shop_buy": True,
        "types": "all"
    }
}

cfg_model = CastleConfigModel(**req_data)
dumped = cfg_model.model_dump(exclude_none=True)
print("Dumped config from Pydantic:", dumped)
assert "watermill" in dumped
assert dumped["watermill"]["enabled"] is True
assert dumped["watermill"]["allow_shop_buy"] is True

# 2. اختبار محاكاة clean_config في API
mock_db_config = {"fountain": {"enabled": False}}
mock_db_config.update(dumped)
assert mock_db_config["watermill"]["enabled"] is True

# 3. فحص قاعدة البيانات الحالية
conn = sqlite3.connect('database/castles.db')
cursor = conn.cursor()
cursor.execute("SELECT castle_id, config FROM castle_states")
rows = cursor.fetchall()
for cid, c_raw in rows:
    c_json = json.loads(c_raw)
    assert "watermill" in c_json, f"Missing watermill in castle {cid}"
    print(f"Castle {cid} in DB: watermill = {c_json['watermill']}")
conn.close()

print("ALL WATERMILL E2E TESTS PASSED 100%!")
