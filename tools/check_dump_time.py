import os
import time

mtime = os.path.getmtime(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json")
print("beetoo2_full_init_data.json modified:", time.ctime(mtime))
