import os
import re

def check_pets():
    # Pets in beetoo1:
    # 1254: rank 2, level 43
    # 1251: rank 2, level 30
    # 1259: rank 1, level 1
    # 1255: rank 1, level 1
    
    # Check pet tables: pet_skill, pet_talent, pet_config
    pdir = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
    for f in os.listdir(pdir):
        if "pet" in f:
            print("Pet file:", f)

if __name__ == "__main__":
    check_pets()
