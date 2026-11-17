with open('game_file/src/app/localtb/config_client/lordskilldes.lua', 'r', encoding='utf-8', errors='ignore') as f:
    for i in range(20):
        print(f.readline(), end='')

print("--- skill.lua ---")
with open('game_file/src/app/localtb/config_server/skill.lua', 'r', encoding='utf-8', errors='ignore') as f:
    for i in range(20):
        print(f.readline(), end='')
