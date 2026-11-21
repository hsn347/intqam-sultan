import json
import itertools

# Let's write a comprehensive script calculating:
# 1. Official Game Lua Logic (Client Lua Source)
# 2. BaseTask Logic (Ottoman Bot Formula)
# 3. All combinations of heroes for beetoo1

b1 = json.load(open('tools/beetoo1_full_init_data.json', encoding='utf-8'))
b2 = json.load(open('tools/beetoo2_full_init_data.json', encoding='utf-8'))

# Base castle capacity:
# Drill 27: 87,500
# Default: 1,000
# Tech 43: 12,000
# Bare flat = 100,500
# Medal 17 = 1% (+10 permille)

bare_flat = 100500
bare_client = 100500 + int(100500 * 0.01) # 101,505

# In client Lua:
# Native rarity for heroes:
# 1700: Rarity 1
# 1704: Rarity 2
# 1707: Rarity 2
# 1710: Rarity 3
# 1711: Rarity 3
# 1712: Rarity 3
# 1717: Rarity 2
# 1718: Rarity 2

# Level 60 capacities by native rarity:
# Rarity 1, Lv 60: 5,000
# Rarity 2, Lv 60: 6,000
# Rarity 3, Lv 60: 7,000
# Rarity 4, Lv 60: 7,000
# Rarity 5, Lv 60: 7,500

# Level 60 capacities by quality (stars):
# Q1: 5,000
# Q2: 6,000
# Q3: 7,000
# Q4: 7,000
# Q5: 7,500

print("==================================================")
print("COMPREHENSIVE AUDIT & COMPARISON: BEETOO 1 & BEETOO 2")
print("==================================================")

# BEETOO 2
print("\n--- BEETOO 2 ---")
# Heroes in B2:
# 1700 (Lv 60, Q5, R1) -> Q_cap: 7500, R_cap: 5000
# 1712 (Lv 60, Q5, R3) -> Q_cap: 7500, R_cap: 7000
# 1717 (Lv 60, Q5, R2) -> Q_cap: 7500, R_cap: 6000
# 1711 (Lv 60, Q4, R3) -> Q_cap: 7000, R_cap: 7000
# 1707 (Lv 60, Q3, R2) -> Q_cap: 7000, R_cap: 6000
# 1708 (Lv 60, Q3, R2) -> Q_cap: 7000, R_cap: 6000

# BaseTask / Bot formula on B2:
# Top 5 by Q: 1700(7500), 1712(7500), 1717(7500), 1711(7000), 1707(7000)
# Sum heroes Q = 36,500
# Flat total = 100,500 + 36,500 = 137,000
# Medal 1% = 137,000 * 0.01 = 1,370
# Total = 137,000 + 1,370 = 138,370 (MATCHES TARGET 138,370 EXACTLY!)
print("B2 Bot Formula (Quality + 1% overall):")
print("  Bare Flat: 100,500")
print("  Heroes (1700, 1712, 1717, 1711, 1707): 7500+7500+7500+7000+7000 = 36,500")
print("  Flat Total: 137,000")
print("  Medal 1%: 1,370")
print("  Grand Total: 138,370  <--- EXACT TARGET!")

# Client Lua on B2:
# Top 5 by Rarity: 1711(7000), 1712(7000), 1707(6000), 1708(6000), 1717(6000)
# Sum heroes R = 32,000
# Bare client = 101,505
# Total client = 101,505 + 32,000 = 133,505
print("\nB2 Client Lua (Native Rarity + Bare buffed):")
print("  Bare Total: 101,505")
print("  Heroes (1711, 1712, 1707, 1708, 1717): 7000+7000+6000+6000+6000 = 32,000")
print("  Total Client: 133,505")


# BEETOO 1
print("\n--- BEETOO 1 ---")
# Heroes in B1:
# 1717 (Lv 60, Q5, R2) -> Q_cap: 7500, R_cap: 6000
# 1711 (Lv 60, Q4, R3) -> Q_cap: 7000, R_cap: 7000
# 1704 (Lv 60, Q3, R2) -> Q_cap: 7000, R_cap: 6000
# 1710 (Lv 60, Q3, R3) -> Q_cap: 7000, R_cap: 7000
# 1718 (Lv 60, Q2, R2) -> Q_cap: 6000, R_cap: 6000
# 1712 (Lv 48, Q5, R3) -> Q_cap: 5550, R_cap: 3700
# 1700 (Lv 41, Q4, R1) -> Q_cap: 4200, R_cap: 3000
# 1707 (Lv 28, Q4, R2) -> Q_cap: 2877, R_cap: 2060

# Under Bot Formula:
# If top 5 heroes are [1717, 1711, 1704, 1710, 1718]:
# Q sum = 7500 + 7000 + 7000 + 7000 + 6000 = 34,500
# Flat total = 100,500 + 34,500 = 135,000
# Medal 1% = 135,000 * 0.01 = 1,350
# Grand Total = 135,000 + 1,350 = 136,350! (EXACT 136,350!)
print("B1 Bot Formula Option A (Top 5: 1717, 1711, 1704, 1710, 1718):")
print("  Bare Flat: 100,500")
print("  Heroes: 7500+7000+7000+7000+6000 = 34,500")
print("  Flat Total: 135,000")
print("  Medal 1%: 1,350")
print("  Grand Total: 136,350  <--- EXACT 136,350!")

# What if 1712 (Lv 48, Q5 -> 5550) is used instead of 1718 (6000)?
# Q sum = 7500 + 7000 + 7000 + 7000 + 5550 = 34,050
# Flat total = 100,500 + 34,050 = 134,550
# Medal 1% = 1,345
# Grand Total = 135,895
print("\nB1 Bot Formula Option B (Using 1712 Lv48 instead of 1718):")
print("  Heroes: 34,050 -> Grand Total: 135,895")

# What if live memory snapshot state is used (heroes in march/busy, so 1718, 1700, 1707, 1709, 1705)?
# Q sum = 6000 + 4200 + 2877 + 700 + 700 = 14,477
# With 1%: 114,977 * 1.01 = 116,126
# With 2% (missing achievementctrl fallback): 114,977 * 1.02 = 117,276
print("\nB1 Bot Formula Option C (Current Live Snapshot Busy State):")
print("  Heroes available: 14,477 -> Grand Total with 1%: 116,126 / with 2% fallback: 117,276")

# Under Client Lua:
# Top 5 by native rarity:
# 1710 (R3, Lv60: 7000)
# 1711 (R3, Lv60: 7000)
# 1704 (R2, Lv60: 6000)
# 1717 (R2, Lv60: 6000)
# 1718 (R2, Lv60: 6000)
# R sum = 7000 + 7000 + 6000 + 6000 + 6000 = 32,000!
# Bare client = 101,505
# Total Client = 101,505 + 32,000 = 133,505!
print("\nB1 Client Lua (Native Rarity + Bare buffed):")
print("  Bare Total: 101,505")
print("  Heroes: 7000+7000+6000+6000+6000 = 32,000")
print("  Total Client: 133,505")
