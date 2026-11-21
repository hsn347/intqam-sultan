import json

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

print("=== KILL COUNT (fcInfo) ===")
fc1 = d1.get('lordInfoCtrl', {}).get('fcInfo', {})
fc2 = d2.get('lordInfoCtrl', {}).get('fcInfo', {})
print("beetoo1 fcInfo:", fc1)
print("beetoo2 fcInfo:", fc2)

print("\n=== ACHIEVEMENTS (achievementctrl) ===")
ach1 = d1.get('achievementctrl', {})
ach2 = d2.get('achievementctrl', {})
print("beetoo1 ach17:", ach1.get('list', {}).get('17'))
print("beetoo2 ach17:", ach2.get('list', {}).get('17'))

print("\n=== LORD SKILLS (lordSkillCtrl) ===")
ls1 = d1.get('lordSkillCtrl', {})
ls2 = d2.get('lordSkillCtrl', {})
print("beetoo1 lordSkill:", ls1)
print("beetoo2 lordSkill:", ls2)

print("\n=== DRILL GROUNDS DETAILS ===")
for b in d1.get('cityCtrl', {}).get('blist', []):
    binfo = b.get('binfo', b)
    if str(binfo.get('bid')) == '121':
        print("beetoo1 drill full:", binfo)
for b in d2.get('cityCtrl', {}).get('blist', []):
    binfo = b.get('binfo', b)
    if str(binfo.get('bid')) == '121':
        print("beetoo2 drill full:", binfo)
