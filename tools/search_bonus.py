with open(r'game_file\src\app\localtb\config_client\local_arab.lua', 'r', encoding='utf-8') as f:
    text = f.read()

import re
matches = re.findall(r'(\"[^\"]+\")\s*=\s*(\"[^\"]*زيادة حجم المسيرة[^\"]*\")', text)
print(f"Found {len(matches)} matches:")
for k, v in matches:
    print(k, "=>", v)
