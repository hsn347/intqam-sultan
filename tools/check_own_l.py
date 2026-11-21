import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

# function heroCtrl:isOwnLieutenantByHeroID(heroID)
#   local curDress = heroltCtrl:getHeroDress(heroID)
#   return curDress > 0 and curDress % 100 > 1

# Let's check getHeroDress from hero_view_info.lua
# In hero_view_info.lua, dressUpId = {171701}, {171201}, etc.
# But does the user OWN a lieutenant dress?
# In heroCtrl:
# function heroCtrl:isOwnLieutenantByHeroID(heroID)
# let's find the exact Lua implementation of isOwnLieutenantByHeroID!
