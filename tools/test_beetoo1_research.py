# -*- coding: utf-8 -*-
"""
tools/test_beetoo1_research.py — اختبار الفحص المسبق لأبحاث المعهد لقلعة beetoo1 الحقيقية
"""

import sys
import os
import json
import sqlite3

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from tasks.research import ResearchTask

def main():
    conn_db = sqlite3.connect("database/castles.db")
    c = conn_db.cursor()
    c.execute("SELECT config, resources FROM castle_states WHERE email='beetoo1@hotmail.com'")
    row = c.fetchone()
    if not row:
        print("beetoo1 not found")
        return

    cfg = json.loads(row[0]) if row[0] else {}
    res = json.loads(row[1]) if row[1] else {}

    print("Resources in DB:", res)

    # Note: In live memory, init_data has cityCtrl, technologyCtrl, queueCtrl
    # Let's inspect session_cache.json if available
    cache_file = "session_cache.json"
    if os.path.exists(cache_file):
        with open(cache_file, "r", encoding="utf-8") as f:
            cache_data = json.load(f)
            print("Session cache keys:", list(cache_data.keys()))

if __name__ == "__main__":
    main()
