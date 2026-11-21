# -*- coding: utf-8 -*-
import json

with open("tools/beetoo1_full_init_data.json", "r", encoding="utf-8") as f:
    d1 = json.load(f)

with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    d2 = json.load(f)

print("=== BUFF CTRL ===")
print("beetoo1 buffCtrl:", d1.get("buffCtrl"))
print("beetoo2 buffCtrl:", d2.get("buffCtrl"))

print("\n=== ACHIEVE INFO ===")
print("beetoo1 achieveInfo:", d1.get("lordInfoCtrl", {}).get("achieveInfo"))
print("beetoo2 achieveInfo:", d2.get("lordInfoCtrl", {}).get("achieveInfo"))

print("\n=== LORD KILL COUNT ===")
print("beetoo1 killCount:", d1.get("lordInfoCtrl", {}).get("fcInfo", {}).get("killCount"))
print("beetoo2 killCount:", d2.get("lordInfoCtrl", {}).get("fcInfo", {}).get("killCount"))
