import sys
import re
import json

# Beetoo2 pets:
# 1254: rank 2, level 48
# 1251: rank 2, level 30
# 1259: rank 1, level 1
# 1255: rank 1, level 2

# We need:
# attrType for MARCH_VALUE_LIMIT_BOOST (96) and MARCH_LIMIT_BOOST (18)
# Look at petCtrl.lua:
# ;("petltCtrl")[gPetAttributeType.MARCH_VALUE_LIMIT_BOOST] = gBuffEffect.MARCH_VALUE_LIMIT_BOOST (96)
# ;("petltCtrl")[gPetAttributeType.MARCH_LIMIT_BOOST] = gBuffEffect.MARCH_LIMIT_BOOST (18)?
# Let's check gPetAttributeType in petDef.lua!

def check_pet_def():
    with open(r"e:\intqam-sultan\game_file\src\app\constdef\petDef.lua", "r", encoding="utf-8") as f:
        print(f.read())

if __name__ == '__main__':
    check_pet_def()
