# -*- coding: utf-8 -*-
"""
tools/test_research_preflight.py — اختبار خوارزمية الفحص المسبق لأبحاث المعهد 0-Network
"""

import json
import sqlite3
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RULES_FILE = os.path.join(ROOT, "core", "technology_rules.json")
DB_FILE = os.path.join(ROOT, "database", "castles.db")

def main():
    with open(RULES_FILE, "r", encoding="utf-8") as f:
        tech_rules = json.load(f)

    conn = sqlite3.connect(DB_FILE)
    c = conn.cursor()
    c.execute("SELECT castle_info, resources FROM castle_states WHERE email='beetoo1@hotmail.com'")
    row = c.fetchone()
    if not row:
        print("Castle not found!")
        return

    castle_info = json.loads(row[0]) if row[0] else {}
    resources = json.loads(row[1]) if row[1] else {}

    print("Castle Info keys:", list(castle_info.keys()))
    print("Resources:", resources)

if __name__ == "__main__":
    main()
