import json

d = json.load(open('docs/beetoo1_live_memory.json', encoding='utf-8'))
print("docs/beetoo1_live_memory achievementctrl medal 17:", d.get('achievementctrl', {}).get('list', {}).get('17'))
