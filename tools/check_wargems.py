import os
import re

for gem_id in [12030201, 12020206, 12060408]:
    cmd = f'Select-String -Path "e:\\intqam-sultan\\game_file\\src\\app\\localtb\\config_server\\*" -Pattern "{gem_id}"'
    print(f"Checking gem {gem_id}...")
