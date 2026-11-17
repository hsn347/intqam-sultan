# -*- coding: utf-8 -*-
import os
import re

for base in ["game_file/src/app/localtb/config_client", "game_file/src/app/localtb/config_server", "game_file/localtb"]:
    fpath = os.path.join(base, "local_arab.lua")
    if os.path.exists(fpath):
        with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
        for key in ["common_text_775", "artifact_title_01", "common_text_4870", "common_text_722"]:
            m = re.search(r'\["' + key + r'"\]\s*=\s*"([^"]+)"', content)
            if m:
                print(f"{base} | {key} -> {m.group(1)}")
            else:
                # also check binary or other format
                pass
