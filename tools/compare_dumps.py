import json

lucifer = json.load(open('docs/lucifer_live_memory.json', encoding='utf-8'))
beetoo1 = json.load(open('docs/beetoo1_live_memory.json', encoding='utf-8'))

print("=== CONTROLLERS IN LUCIFER ===")
print(sorted(lucifer.keys()))
print("=== CONTROLLERS IN BEETOO1 ===")
print(sorted(beetoo1.keys()))

print("\nDifferences:")
print("In Lucifer only:", set(lucifer.keys()) - set(beetoo1.keys()))
print("In Beetoo1 only:", set(beetoo1.keys()) - set(lucifer.keys()))
