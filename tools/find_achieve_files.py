import os
import re

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

# Find achievement config files
for f in os.listdir(CONFIG_DIR):
    if "achieve" in f.lower() or "medal" in f.lower():
        print("Found file:", f)
