local gametop = gModuleMgr.getObject("gametop")
local vipLocalData = include("vipLocalData")
local resDesRead = include("resDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local findMonsterCtrl = gametop.playertop_:getModule("findMonsterCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local constantRead = include("constantRead")
local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
local funUnlockRead = include("funUnlockRead")
local WorldMapMonsterSearch = class("worldMapMonsterSearch", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end)
_ENV, _ENV = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, "worldMapMonsterSearch"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 1
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "jsmny_sw_ws_01.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.6
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "common_text_4500"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMonsterNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showAutoKill = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newResSearch = true
_ENV, ("worldMapMonsterSearch")[1], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.SEARCH_MONSTER
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 2
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_escort.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.3
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 49)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "common_text_2465"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMarket = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).marketLang = "complete_text_04"
_ENV, ("worldMapMonsterSearch")[2], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.ESCORT
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 3
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_food.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "res_name_nongtian"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).resDef = gIDDef.FOOD
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showResNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newMSearch = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).maxLv = 8
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).searchType = 2
_ENV, ("worldMapMonsterSearch")[3], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.COLLECT_FOOD
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 4
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_wood.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 40)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "res_name_famuchang"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).resDef = gIDDef.WOOD
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showResNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newMSearch = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).maxLv = 8
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).searchType = 3
_ENV, ("worldMapMonsterSearch")[4], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.COLLECT_WOOD
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 5
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_iron.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 40)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "res_name_tiekuangchang"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).resDef = gIDDef.IRON
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showResNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newMSearch = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).maxLv = 8
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).lvLimit = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).searchType = 4
_ENV, ("worldMapMonsterSearch")[5], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.COLLECT_IRON
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 6
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_silver.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "res_name_miyinkuangchang"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).resDef = gIDDef.MITHRIL
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showResNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newMSearch = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).maxLv = 8
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).lvLimit = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).searchType = 5
_ENV, ("worldMapMonsterSearch")[6], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.COLLECT_SILVER
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 7
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_gold.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 40)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "res_name_jinkuang"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).resDef = gIDDef.GOLD
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showResNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newMSearch = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).maxLv = 7
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).searchType = 1
_ENV, ("worldMapMonsterSearch")[7], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.COLLECT_GOLD
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 8
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_crystal.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 40)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "common_text_3969"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).resDef = gIDDef.CRYSTAL
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showResNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newMSearch = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).maxLv = 8
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).lvLimit = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).searchType = 6
_ENV, ("worldMapMonsterSearch")[8], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.COLLECT_CRYSTAL
_UPVALUE2_, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = gFunBuildKey.COLLECT_CRYSTAL, 9
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png, gFunBuildKey.COLLECT_CRYSTAL[1] = gFunBuildKey.COLLECT_CRYSTAL, "pjys_gj_ws.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png, gFunBuildKey.COLLECT_CRYSTAL[2] = gFunBuildKey.COLLECT_CRYSTAL, "panjun_gj_ws.png"
_UPVALUE2_, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = gFunBuildKey.COLLECT_CRYSTAL, 0.7
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).bossName, gFunBuildKey.COLLECT_CRYSTAL[1] = gFunBuildKey.COLLECT_CRYSTAL, "npc_name_011"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).bossName, gFunBuildKey.COLLECT_CRYSTAL[2] = gFunBuildKey.COLLECT_CRYSTAL, "npc_name_012"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "activityname_20"
_ENV, ("worldMapMonsterSearch")[9], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gActivityTimeActivityID.HERO_BATTLE_BOSS
_UPVALUE2_, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = gActivityTimeActivityID.HERO_BATTLE_BOSS, 11
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png, gActivityTimeActivityID.HERO_BATTLE_BOSS[1] = gActivityTimeActivityID.HERO_BATTLE_BOSS, "drqsc_gj_ws.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png, gActivityTimeActivityID.HERO_BATTLE_BOSS[2] = gActivityTimeActivityID.HERO_BATTLE_BOSS, "drq_gj_ws.png"
_UPVALUE2_, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = gActivityTimeActivityID.HERO_BATTLE_BOSS, 0.7
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).bossName, gActivityTimeActivityID.HERO_BATTLE_BOSS[1] = gActivityTimeActivityID.HERO_BATTLE_BOSS, "npc_name_23"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).bossName, gActivityTimeActivityID.HERO_BATTLE_BOSS[2] = gActivityTimeActivityID.HERO_BATTLE_BOSS, "npc_name_24"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "activity_name_9001168"
_ENV, ("worldMapMonsterSearch")[10], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gActivityTimeActivityID.WRATH_BEAST_ACTIVITY
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 12
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "xueguai_gj_ws.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.6
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 50)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "activity_name_9001197"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMarket = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).marketLang = "common_text_4501"
_ENV, ("worldMapMonsterSearch")[11], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 13
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "langren_gj_ws.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.6
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 40)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "activity_name_9001201"
_ENV, ("worldMapMonsterSearch")[12], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 15
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_lostRuin.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.4
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(50, 36)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "activity_name_9001301"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = gActivityTimeActivityID.LOST_RUINS_ACTIVITY
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMarket = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).marketLang = "lost_ruins_text_33"
_ENV, ("worldMapMonsterSearch")[13], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newResSearch = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 19
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).realSort = 1
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "shmcclr_gj_ws.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.5
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(50, 50)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "wasteland_text_009"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = gActivityTimeActivityID.WASTELAND
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMonsterNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newMSearch = true
_ENV, ("worldMapMonsterSearch")[14], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).highestLv = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, SoraDGetCtrl("wastelandCtrl"):getMaxBossLv()
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 20
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_snowwolf.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.6
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(50, 50)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "npc_name_042"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMarket = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).marketLang = "snowWolfLost_016"
_ENV, ("worldMapMonsterSearch")[15], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newResSearch = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 0
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "falake_dj_ws_01.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.5
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(50, 40)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "StarryNight_text_04"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMonsterNode = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showAutoKill = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newResSearch = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).towerLv = 1
_ENV, ("worldMapMonsterSearch")[16], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).unlockKey = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, gFunBuildKey.SEARCH_MONSTER
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 23
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_pegasus.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.4
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 45)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "Legends_of_Pegasus_text_05"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMarket = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).marketLang = "Legends_of_Pegasus_text_10"
_ENV, ("worldMapMonsterSearch")[17], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newResSearch = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 24
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_iceDragonLost.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.4
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 45)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "firedragon_of_anger_text5"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001602
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMarket = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).marketLang = "firedragon_of_anger_text10"
_ENV, ("worldMapMonsterSearch")[18], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newResSearch = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 25
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "Map_build_iceDragonLost.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.4
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(45, 45)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "firedragon_of_anger_text5"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001696
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMarket = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).marketLang = "firedragon_of_anger_text10"
_ENV, ("worldMapMonsterSearch")[19], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newResSearch = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).sortIndex = 26
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).realSort = 1
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).png = "icon_smlk_9001737.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngScale = 0.8
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).pngPos = cc.p(50, 50)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).name = "activity_name_9001737"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).activityID = gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).showMarket = true
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).newResSearch = true
_ENV, _ENV, ("worldMapMonsterSearch")[20], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end).highestLv = gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end, 1
local searchCfg_normal = "worldMapMonsterSearch"
gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY.sortIndex = 100
gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY.png = "shuangtougou_dj_ws_01.png"
gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY.pngScale = 0.5
gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY.pngPos = cc.p(50, 40)
gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY.name = "nebula_war_text_0556"
_ENV, _ENV, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end)[1], gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY.unlockKey = gFunBuildKey.SEARCH_MONSTER, gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY, gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY, gFunBuildKey.SEARCH_MONSTER
local function searchCfg_nebula(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapMonsterSearch")
	end
	return target
end
gFunBuildKey.SEARCH_MONSTER.sortIndex = 200
gFunBuildKey.SEARCH_MONSTER.png = "jsmny_sw_ws_01.png"
gFunBuildKey.SEARCH_MONSTER.pngScale = 0.6
gFunBuildKey.SEARCH_MONSTER.name = "flames_dunes_text269"
gFunBuildKey.SEARCH_MONSTER.unlockKey = gFunBuildKey.SEARCH_MONSTER
_ENV, gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY[1], gFunBuildKey.SEARCH_MONSTER.showMonsterNode = gFunBuildKey.SEARCH_MONSTER, gFunBuildKey.SEARCH_MONSTER, true
gFunBuildKey.SEARCH_MONSTER.sortIndex = 201
gFunBuildKey.SEARCH_MONSTER.png = "flames_dunes_build_medium_5.png"
gFunBuildKey.SEARCH_MONSTER.pngScale = 0.8
gFunBuildKey.SEARCH_MONSTER.pngPos = cc.p(36, 48)
gFunBuildKey.SEARCH_MONSTER.name = "flames_dunes_text270"
gFunBuildKey.SEARCH_MONSTER.subType = gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix
gFunBuildKey.SEARCH_MONSTER.showMarket = true
_ENV, gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY[2], gFunBuildKey.SEARCH_MONSTER.marketLang = gFunBuildKey.SEARCH_MONSTER, gFunBuildKey.SEARCH_MONSTER, "flames_dunes_text271"
gFunBuildKey.SEARCH_MONSTER.sortIndex = 202
gFunBuildKey.SEARCH_MONSTER.png = "Map_build_gold.png"
gFunBuildKey.SEARCH_MONSTER.pngScale = 0.5
gFunBuildKey.SEARCH_MONSTER.pngPos = cc.p(50, 40)
gFunBuildKey.SEARCH_MONSTER.name = "res_name_jinkuang"
gFunBuildKey.SEARCH_MONSTER.subType = gWorldTypeServerDef.subTypeRoaringFlameWarGoldMine
_ENV, gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY[3], gFunBuildKey.SEARCH_MONSTER.showMarket = gFunBuildKey.SEARCH_MONSTER, gFunBuildKey.SEARCH_MONSTER, true
gFunBuildKey.SEARCH_MONSTER.sortIndex = 203
gFunBuildKey.SEARCH_MONSTER.png = "Map_build_silver.png"
gFunBuildKey.SEARCH_MONSTER.pngScale = 0.5
gFunBuildKey.SEARCH_MONSTER.pngPos = cc.p(50, 40)
gFunBuildKey.SEARCH_MONSTER.name = "res_name_miyinkuangchang"
gFunBuildKey.SEARCH_MONSTER.subType = gWorldTypeServerDef.subTypeRoaringFlameWarMithrilMine
_ENV, gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY[4], gFunBuildKey.SEARCH_MONSTER.showMarket = gFunBuildKey.SEARCH_MONSTER, gFunBuildKey.SEARCH_MONSTER, true
local searchCfg_roaringFlame = gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY
gFunBuildKey.SEARCH_MONSTER[0] = "Game:worldMapView:monsterXYLVRange~string"
gFunBuildKey.SEARCH_MONSTER[1] = "Game:worldMapView:monsterLVRange~string"
gFunBuildKey.SEARCH_MONSTER[16] = "Game:worldMapView:iceHuntingLVRange~string"
gFunBuildKey.SEARCH_MONSTER[19] = "Game:worldMapView:WastelandRange~string"
local gFunBuildKey.SEARCH_MONSTER[200], sortIndex2configKey = "Game:worldMapView:roaringFlameNpcLVRange~string", gFunBuildKey.SEARCH_MONSTER
local _ENV, _ENV, searchCfg = 50, gWorldTypeServerDef.subTypeRoaringFlameWarMithrilMine, gWorldTypeServerDef.subTypeRoaringFlameWarMithrilMine
;(50)[1] = gIDDef.GOLD
;(50)[2] = gIDDef.FOOD
;(50)[3] = gIDDef.WOOD
;(50)[4] = gIDDef.IRON
;(50)[5] = gIDDef.MITHRIL
local (50)[6], tableResID = gIDDef.CRYSTAL, 50
function WorldMapMonsterSearch:ctor()
	self:setBackGround(0)
	self.levelTouchEnable = true
	self.isNewMonsterSearch = false
	self.isNewResourceSearch = false
	self.singleIsMoved = false
	self.imgSelectArray, _ENV, self.itemArray, _ENV, self.menuTable, _ENV, self.chooseIndex = self.setBackGround, self.setBackGround, self.setBackGround, self.setBackGround, self.setBackGround, self.setBackGround, 1
	self.selectIndex = SoraDConfigGet("Game:worldMapView:SelectType~integer") or 1
	if worldMapDefine.isInNebula() then
	elseif worldMapDefine.isInRoaringFlame() then
	else
	end
	if self.selectIndex > #searchCfg then
		self.selectIndex = 1
	end
	local resType = SoraDConfigGet("Game:worldMapView:ResourceType~integer")
	local resLevel = SoraDConfigGet("Game:worldMapView:ResourceLV~integer")
	self.resLv = 1
	if resType ~= 0 then
		self.chooseIndex = self:getChooseIndexByType(resType)
	end
	if resLevel ~= 0 then
		self.resLv = resLevel
	end
	self.Text_showName = SoraDGetChildByName(self, "Text_showName")
	self.textFieldDown = SoraDGetChildByName(self, "TextField_downNum")
	self.textFieldUp = SoraDGetChildByName(self, "TextField_upNum")
	self.txtDown = SoraDGetChildByName(self, "Text_downNum")
	self.txtUp = SoraDGetChildByName(self, "Text_upNum")
	self.nodeHaveRight = SoraDGetChildByName(self, "Node_haveRight")
	self.txtWarnVip = SoraDGetChildByName(self, "Text_warnVip")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtVipDes = SoraDGetChildByName(self, "Text_vipTip")
	self.scroll = SoraDGetChildByName(self, "scrollView_choose")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "eventLimitGiftScrollView")
	self.scroll:setSingleSelectedListener(handler(self, self.scrollMenuCallBack))
	self.nodeMonster = SoraDGetChildByName(self, "node_monster")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.nodeRes = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.btnLeft = SoraDGetChildByName(self, "btn_left")
	self.btnRight = SoraDGetChildByName(self, "btn_right")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.panel = SoraDGetChildByName(self, "Tile_Bottom_Image_frameBg")
	self.panel:setTouchEnabled(true)
	self.panel:addTouchEventListener(handler(self, self.onPanelClick))
	self.btnLeft:addTouchEventListener(handler(self, self.turnLeftClick))
	self.btnRight:addTouchEventListener(handler(self, self.turnRightClick))
	self.Bottom_Node:runAction(cca.moveTo(0.1, cc.p(320, 0)))
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self.btnAutoKill = SoraDGetChildByName(self, "Button_autokill")
	self.btnAutoKill:addTouchEventListener(handler(self, self.btnAutoKillClick))
	local txtAutoKill = SoraDGetChildByName(self, "Text_autokill")
	txtAutoKill:setString(i18n("automatic_btn_01"))
	SoraDGetChildByName(self, "Text_lvRange"):setString(i18n("common_text_2178"))
	self.Text_lvRange = SoraDGetChildByName(self, "Text_lvRange")
	SoraDGetChildByName(self, "Text_~"):setString("~")
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.txtMarket = SoraDGetChildByName(self, "Text_market")
	self.txtMarket:setVisible(false)
	self.Node_choose = SoraDGetChildByName(self, "Node_choose")
	self.Node_choose:setVisible(false)
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:isGuideNotCompleted(gGuideModule.WORLD_SERCH) then
		self.guideChooseIdx = 1
		guideCtrl:updateGuideModule(gGuideModule.WORLD_SERCH)
	end
	self:initMenuData()
	self:changeToEditBox()
	self:initData()
	self:initScrollMenu()
	self:resetDisplayStatus()
	self:setCloseCallBack(function()
		if self.keyBoardUp then
			self.keyBoardUp = false
			self.enableTouchCloseSelf = true
		else
			self.enableTouchCloseSelf = false
		end
	end)
	if worldMapDefine.isInNebula() then
		self.btnLeft:setVisible(false)
		self.btnRight:setVisible(false)
	end
end
function WorldMapMonsterSearch:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MONSTERSEARCH_DATAARRIVE", handler(self, self.msgBackData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MONSTER_SEARCH_LOCK", function(...)
		if not tolua.isnull(self) then
			self:removeFromParent()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_SEMLUK_BALL_REFRESH", function(target, data)
		self:resetDisplayStatus()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function WorldMapMonsterSearch:initMenuData()
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	self.menuTable, lordInfoCtrl = lordInfoCtrl, lordInfoCtrl
	for k, v in ipairs(searchCfg) do
		if not v.activityID then
			if v.towerLv then
				local towerLv = nebulaActivityCtrl:getTowerLv()
				if towerLv >= v.towerLv then
					if v.unlockKey then
						local showLv = funUnlockRead.getShowLevel(v.unlockKey)
						if showLv <= SoraDGetCastleLv() then
							table.insert(self.menuTable, v)
						end
					else
						table.insert(self.menuTable, v)
					end
				end
			elseif v.unlockKey then
				local showLv = funUnlockRead.getShowLevel(v.unlockKey)
				if showLv <= SoraDGetCastleLv() then
					table.insert(self.menuTable, v)
				end
			else
				table.insert(self.menuTable, v)
			end
		else
			local isShow = clientEventMgr.judgeIsOpen(v.activityID) and clientEventMgr.getEventInfoByeid(v.activityID) and sourceKid == 0
			if isShow then
				if v.activityID == gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY then
					local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
					local subMapType = activity_9001737_Ctrl:getMyCamp()
					if subMapType and 0 < subMapType then
						table.insert(self.menuTable, v)
					end
				elseif v.classtype then
					local param = activityShowCtrl:getParamByID(v.activityID)
					if param.classtype and param.classtype == v.classtype then
						if v.unlockKey then
							local showLv = funUnlockRead.getShowLevel(v.unlockKey)
							if showLv <= SoraDGetCastleLv() then
								table.insert(self.menuTable, v)
							end
						else
							table.insert(self.menuTable, v)
						end
					end
				elseif v.unlockKey then
					local showLv = funUnlockRead.getShowLevel(v.unlockKey)
					if showLv <= SoraDGetCastleLv() then
						table.insert(self.menuTable, v)
					end
				else
					table.insert(self.menuTable, v)
				end
			end
		end
	end
	local recordIndex = SoraDConfigGet("Game:worldMapView:SearchIndex~integer")
	if recordIndex then
		self.chooseIndex = math.min(#self.menuTable, recordIndex)
	else
		self.chooseIndex = #self.menuTable
	end
	table.sort(self.menuTable, function(a, b)
		if a.realSort and b.realSort then
			return a.realSort < b.realSort
		elseif a.realSort or b.realSort then
			return a.realSort
		end
		if a.activityID and b.activityID then
			return a.activityID < b.activityID
		elseif not a.activityID and not b.activityID then
			return a.sortIndex < b.sortIndex
		elseif not a.activityID and b.activityID then
			return false
		elseif a.activityID and not b.activityID then
			return true
		end
	end)
end
function WorldMapMonsterSearch:changeToEditBox()
	local realChangeToEditBox = function(ocx)
		local size = ocx:getContentSize()
		local pos = cc.p(ocx:getPositionX(), ocx:getPositionY())
		local ap = ocx:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setFontColor(display.COLOR_BLACK)
		if ocx:getMaxLength() > 0 then
			editBox:setMaxLength(ocx:getMaxLength())
		end
		editBox:setFontSize(ocx:getFontSize())
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:addTo(ocx:getParent())
		editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
		editBox:setInputMode(2)
		ocx:removeFromParent()
		return editBox
	end
	self.textFieldDown = realChangeToEditBox(self.textFieldDown)
	self.textFieldUp = realChangeToEditBox(self.textFieldUp)
end
function WorldMapMonsterSearch:OnEditBoxTouch(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		target:touchDownAction(target, eventType)
		self.keyBoardUp = true
	end
end
function WorldMapMonsterSearch:OnInputChangeByEditBoxEnd(event, editBox)
	local getInput = function(ocx)
		local oldInput = ocx:getText()
		local newInput = math.floor(tonumber(oldInput) or 0)
		return newInput
	end
	if event == "began" then
	elseif event == "changed" then
		local newInput = getInput(editBox)
		local highestLv = math.min(kingdomMapCtrl.kingdomMapCell.maxMapNpcLevel, kingdomMapCtrl.kingdomMapCell.maxNpcLevel + 1)
		local lowstLv = 1
		if self.menuTable[self.chooseIndex].highestLv then
			highestLv = self.menuTable[self.chooseIndex].highestLv
		end
		local sortIndex = self.menuTable[self.chooseIndex].sortIndex
		if sortIndex == 19 then
			highestLv = wastelandCtrl:getMaxAttackBossLevel()
		elseif sortIndex == 200 then
			local lvRang = self:getNormalLvRang()
			lowstLv = lvRang.min
			highestLv = lvRang.max
		end
		if self.menuTable[self.chooseIndex].towerLv then
			local towerLv = nebulaActivityCtrl:getTowerLv()
			local cfgMaxLv = nebulaTowerLvDesRead.getMonsterMaxLv(towerLv)
			highestLv = math.max(kingdomMapCtrl.kingdomMapCell.maxMapNpcLevel, kingdomMapCtrl.kingdomMapCell.maxNpcLevel + 1)
			print("highestLv=====aaa", highestLv, cfgMaxLv)
			if highestLv > gMaxNpcLevel + 1 then
				highestLv = math.min(cfgMaxLv, highestLv)
			else
				highestLv = gMaxNpcLevel + 1
			end
			print("highestLv=====bbb", highestLv, cfgMaxLv)
			lowstLv = gMaxNpcLevel + 1
		end
		if editBox == self.textFieldDown then
			print("newInput====", newInput, lowstLv, highestLv, self.newUpInput)
			if newInput < lowstLv then
				newInput = lowstLv
			elseif highestLv < newInput then
				newInput = self.newUpInput
			elseif newInput > self.newUpInput then
				newInput = self.newUpInput
			end
			self.newDownInput = newInput
		elseif editBox == self.textFieldUp then
			if highestLv < newInput then
				newInput = highestLv
			elseif newInput < self.newDownInput or lowstLv > newInput then
				newInput = self.newDownInput
			end
			self.newUpInput = newInput
		end
	elseif event == "ended" or event == "return" then
		SoraDDelayCallOnce("WorldMapMonsterSearch", function()
			if not tolua.isnull(self) then
				self.txtDown:setString(self.newDownInput)
				self.textFieldDown:setText(self.newDownInput)
				self.txtUp:setString(self.newUpInput)
				self.textFieldUp:setText(self.newUpInput)
				self:recordIn()
			end
		end)
	end
end
function WorldMapMonsterSearch:initData(target, redata)
	self.limitLv = kingdomMapCtrl:getMaxCanKillLevel()
	print("self.limitLv=", self.limitLv)
	self:initText()
end
function WorldMapMonsterSearch:judgeClose()
	self:initMenuData()
	self:initScrollMenu()
end
function WorldMapMonsterSearch:setNodeChoose()
	print("self.chooseIndex======", self.chooseIndex)
	local menuCfg = self.menuTable[self.chooseIndex]
	dump(menuCfg, "menuCfg====", 10)
	if type(menuCfg.png) == "table" then
		self.Node_choose:setVisible(true)
		self.imgSelectArray, _ENV = self.Node_choose.setVisible, self.Node_choose.setVisible
		for i = 1, 2 do
			local target = SoraDGetChildByName(self, "Node_monster" .. i)
			if target then
				local Button_select = SoraDGetChildByName(target, "Button_select")
				Button_select:setTag(i)
				Button_select:addTouchEventListener(handler(self, self.onSelectClick))
				local Image_g = SoraDGetChildByName(target, "Image_g")
				self.imgSelectArray[i] = Image_g
				local Sprite_monster = SoraDGetChildByName(target, "Sprite_monster")
				local Text_monster = SoraDGetChildByName(target, "Text_monster")
				Sprite_monster:setSpriteFrame(menuCfg.png[i])
				Text_monster:setString(i18n(menuCfg.bossName[i]))
			end
		end
		self.Text_showName:setString(i18n(menuCfg.name))
		self:setImgSelect(self.selectIndex)
	else
		self.Node_choose:setVisible(false)
	end
end
function WorldMapMonsterSearch:setImgSelect(tag)
	self.selectIndex = tag
	for k, v in ipairs(self.imgSelectArray) do
		v:setVisible(tag == k)
	end
	local menuCfg = self.menuTable[self.chooseIndex]
	self.Text_showName:setString(i18n(menuCfg.name))
end
function WorldMapMonsterSearch:onSelectClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:setImgSelect(button:getTag())
		SoraDConfigSet("Game:worldMapView:SelectType~integer", button:getTag())
	end
end
function WorldMapMonsterSearch:initText()
	local sortIndex = self.menuTable[self.chooseIndex].sortIndex
	local result = self:recordOut()
	if result and next(result) then
		if self.menuTable[self.chooseIndex].highestLv then
			result.min = math.min(self.menuTable[self.chooseIndex].highestLv, result.min)
			result.max = math.min(self.menuTable[self.chooseIndex].highestLv, result.max)
		elseif self.menuTable[self.chooseIndex].towerLv then
			local towerLv = nebulaActivityCtrl:getTowerLv()
			local maxLv = math.max(kingdomMapCtrl.kingdomMapCell.maxMapNpcLevel, kingdomMapCtrl.kingdomMapCell.maxNpcLevel + 1)
			result.min = math.max(result.min, gMaxNpcLevel + 1)
			local max = gMaxNpcLevel + 1
			if maxLv > gMaxNpcLevel + 1 then
				max = math.min(nebulaTowerLvDesRead.getMonsterMaxLv(towerLv), maxLv)
			end
			print("max======", max, result.max)
			result.max = math.min(result.max, max)
		elseif sortIndex == 200 then
			local lvRang = self:getNormalLvRang()
			result.max = math.min(lvRang.max, result.max)
		else
			local maxLv = math.min(kingdomMapCtrl.kingdomMapCell.maxMapNpcLevel, kingdomMapCtrl.kingdomMapCell.maxNpcLevel + 1)
			if sortIndex == 19 then
				maxLv = wastelandCtrl:getMaxAttackBossLevel()
			end
			result.min = math.min(maxLv, result.min)
			result.max = math.min(maxLv, result.max)
		end
	elseif sortIndex == 200 then
		local lvRang = self:getNormalLvRang()
		_ENV = self
		self.min = lvRang.min
		result, self.max = self, lvRang.max
	else
		_ENV = self:getNormalLvRang()
		self:getNormalLvRang().min = 1
		result, self:getNormalLvRang().max = self:getNormalLvRang(), 1
	end
	dump(result, "==result==")
	self.txtDown:setString(result.min)
	self.txtUp:setString(result.max)
	self.textFieldDown:setText(result.min)
	self.textFieldUp:setText(result.max)
	self.newDownInput = result.min
	self.newUpInput = result.max
	local showName = self.menuTable[self.chooseIndex].name
	if type(showName) == "string" then
		self.Text_showName:setString(i18n(showName))
	elseif type(showName) == "table" then
		self.Text_showName:setString(i18n(self.menuTable[self.chooseIndex].name))
	end
	self:recordIn()
end
function WorldMapMonsterSearch:turnLeftClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseIndex = self.chooseIndex - 1
		self.chooseIndex = math.min(table.nums(self.menuTable), math.max(1, self.chooseIndex))
		self.scroll:selectedCellIndex(self.chooseIndex, 0.1)
	end
end
function WorldMapMonsterSearch:turnRightClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseIndex = self.chooseIndex + 1
		self.chooseIndex = math.min(table.nums(self.menuTable), math.max(1, self.chooseIndex))
		self.scroll:selectedCellIndex(self.chooseIndex, 0.1)
	end
end
function WorldMapMonsterSearch:setActivityId(activityID)
	local toIndex = 0
	for k, v in ipairs(self.itemArray) do
		local cellBtn = SoraDGetChildByName(v, "btnCommon")
		local tag = cellBtn:getTag()
		if tag == activityID then
			toIndex = k
			break
		end
	end
	print("toIndex======", toIndex)
	if 0 < toIndex then
		self.chooseIndex = toIndex
		self.scroll:jumpToIndex(self.chooseIndex)
	end
end
function WorldMapMonsterSearch:resetDisplayStatus()
	print("self.chooseIndex======", self.chooseIndex)
	local chooseCfg = self.menuTable[self.chooseIndex]
	dump(chooseCfg, "chooseCfg========")
	if not chooseCfg then
		self.chooseIndex = 1
		chooseCfg = self.menuTable[self.chooseIndex]
	end
	self.nodeMonster:setVisible(chooseCfg.showMonsterNode or false)
	self.btnAutoKill:setVisible(chooseCfg.showAutoKill or false)
	self.nodeRes:setVisible(chooseCfg.showResNode or false)
	self.txtMarket:setVisible(chooseCfg.showMarket or false)
	self.txtMarket:setString(chooseCfg.marketLang and i18n(chooseCfg.marketLang) or "")
	local sortIndex = chooseCfg.sortIndex
	if sortIndex == 18 then
		local curKill = lordInfoCtrl:getKillSemlukNum()
		_ENV = nil
		;(nil).num1 = curKill
		;(nil).num2 = constantRead.getConstValue("SEMRUK_DAY_KILLMAX")
		self.txtMarket:setString(i18n("Semruk_text_03", nil))
	elseif sortIndex == 100 then
		self.txtMarket:setVisible(true)
		local nebulaWarRead = include("nebulaWarRead")
		local name = nebulaWarRead.getOneMonsterName()
		_ENV = i18n("Semruk_text_03", nil)
		i18n("Semruk_text_03", nil).name = name
		local baseStr = i18n("nebula_war_text_0557", i18n("Semruk_text_03", nil))
		local updateTime = function(...)
			local nebulaWarUtil = include("nebulaWarUtil")
			local monsterID = nebulaWarRead.getOneMonsterID()
			local remainTime = nebulaWarUtil.getMonsterRemainTime(monsterID)
			if 0 < remainTime then
				self.timerLabel:beginTime(remainTime)
			else
				self.timerLabel:setString(baseStr)
			end
		end
		if not self.timerLabel then
			self.timerLabel = SoraDCreateTimerLabel(self, self.txtMarket)
			self.timerLabel:setTimeLast(function(timeStr)
				baseStr = nil
				;(nil).time = timeStr
				return baseStr .. "(" .. i18n("HeroWeapon_40", nil) .. ")"
			end)
			self.timerLabel:setTimeEndListener(function()
				updateTime()
			end)
			SoraDSetTextWidthHeight(self.timerLabel, cc.size(620, 50))
		end
		updateTime()
	elseif sortIndex == 200 then
		SoraDSetTextWidthHeight(self.Text_lvRange, cc.size(200, 50))
		local lvRang = self:getNormalLvRang()
		_ENV = cc.size(200, 50)
		cc.size(200, 50).lv = lvRang.max
		local maxLvStr = i18n("flames_dunes_text267", cc.size(200, 50))
		self.Text_lvRange:setString(i18n("common_text_2178") .. "(" .. maxLvStr .. ")")
	elseif sortIndex == 202 or sortIndex == 203 then
		_ENV = i18n("common_text_2178") .. "(" .. maxLvStr .. ")"
		;(i18n("common_text_2178") .. "(" .. maxLvStr .. ")").val = i18n(chooseCfg.name)
		self.txtMarket:setString(i18n("flames_dunes_text264", i18n("common_text_2178") .. "(" .. maxLvStr .. ")"))
	end
	self:setNodeChoose()
	if chooseCfg.newMSearch then
		self.isNewMonsterSearch = true
		local maxLv = chooseCfg.maxLv and chooseCfg.maxLv or chooseCfg.maxLvFunc and chooseCfg.maxLvFunc() or 1
		local curLv = chooseCfg.curLvFunc and chooseCfg.curLvFunc() or self.resLv and self.resLv or 1
		_ENV = i18n("flames_dunes_text264", i18n("common_text_2178") .. "(" .. maxLvStr .. ")")
		i18n("flames_dunes_text264", i18n("common_text_2178") .. "(" .. maxLvStr .. ")").maxValue = maxLv
		i18n("flames_dunes_text264", i18n("common_text_2178") .. "(" .. maxLvStr .. ")").minValue = 1
		i18n("flames_dunes_text264", i18n("common_text_2178") .. "(" .. maxLvStr .. ")").curValue = curLv
		self.nodeRes:initData(i18n("flames_dunes_text264", i18n("common_text_2178") .. "(" .. maxLvStr .. ")"))
	elseif chooseCfg.newResSearch then
		self.isNewResourceSearch = true
	else
		self.isNewResourceSearch = true
		self.isNewMonsterSearch = true
	end
end
function WorldMapMonsterSearch:gotoTreasure()
	if worldMapFunction.GotoEscort() then
		_ENV = nil
		userSDKManager.logEvent(gSDKDef.TDonEvent.search_escort_click, nil)
	end
end
function WorldMapMonsterSearch:closeCallBack(...)
	if self.keyBoardUp then
		self.keyBoardUp = false
	else
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveTo(0.1, cc.p(320, -self.panel:getContentSize().height))
		;(nil)[2] = cca.callFunc(function()
			self:removeFromParent()
		end)
		;(nil)[3] = cca.callFunc(function()
			self:removeFromParent()
		end)
		;(nil)[4] = cca.callFunc(function()
			self:removeFromParent()
		end)
		;(nil)[5] = cca.callFunc(function()
			self:removeFromParent()
		end)
		;(nil)[6] = cca.callFunc(function()
			self:removeFromParent()
		end)
		self.Bottom_Node:runAction(cca.seq(nil))
	end
end
function WorldMapMonsterSearch:onPanelClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self.keyBoardUp = false
	end
end
function WorldMapMonsterSearch:msgBackData(target, redata)
	if redata and redata.retdate then
		if redata.retdate.x ~= -1 and redata.retdate.y ~= -1 then
			if not tolua.isnull(self) then
				self:recordIn()
			end
			if redata.retdate.mapType and redata.retdate.mapType == gMapObjTypeDef.mapTypeSemluk then
				SoraDGotoWorldMapPoint(cc.p(redata.retdate.x, redata.retdate.y), false, nil, nil, nil, nil, true)
			else
				SoraDGotoWorldMapPoint(cc.p(redata.retdate.x, redata.retdate.y), true)
			end
			if redata.retdate.isResourceSearch then
				SoraDConfigSet("Game:worldMapView:ResourceType~integer", tableResID[redata.retdate.resType])
				SoraDConfigSet("Game:worldMapView:ResourceLV~integer", redata.retdate.resLv)
				self.isNewResourceSearch = false
			end
			if redata.retdate.isMonsterSearch then
				SoraDConfigSet("Game:worldMapView:ResourceType~integer", 0)
				SoraDConfigSet("Game:worldMapView:ResourceLV~integer", 0)
				self.isNewMonsterSearch = false
			end
		elseif redata.retdate.searchType and 9 == redata.retdate.searchType then
			SoraDShowMsgTip(i18n("alibaba_text_15"))
		elseif redata.retdate.mapType and gMapObjTypeDef.mapTypeSemluk == redata.retdate.mapType then
			SoraDShowMsgTip(i18n("Semruk_text_10"))
		elseif redata.retdate.isResourceSearch then
			SoraDShowMsgTip(i18n("common_text_4551"))
		else
			SoraDShowMsgTip(i18n("common_text_2177"))
		end
		self:removeFromParent()
	elseif redata and redata.err and gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP == redata.err then
		SoraDShowMsgTip(i18n("common_text_2175"))
	end
	if not tolua.isnull(self) then
		_ENV = i18n("common_text_2175")
		i18n("common_text_2175").delay = 1.2
		i18n("common_text_2175").onComplete = function()
			self.levelTouchEnable = true
			SoraDCloseLoading(self)
		end
		transition.execute(self, nil, i18n("common_text_2175"))
	end
end
function WorldMapMonsterSearch:btnAutoKillClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		local effect = buffCtrl:getBuffEffect(gBuffEffect.AUTO_ATTACK_MONSTER) or false
		if not effect then
			local showMsg = i18n("automatic_text_01")
			SoraDShowMsgBox(showMsg, i18n("common_text_054"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					if GLOBAL_GAME_RECHARGE_MODE then
						_ENV = nil
						;(nil).toCategory = gRechargeCenterCategory.MONTH
						;(nil).toNodeTag = 0
						uiManager:show("rechargeView", nil)
					else
						local panel = SoraDCreatePanel("rechargeView")
						panel:jumpToWeeklyTakeTab()
						panel:show()
					end
				end
			end)
		else
			uiManager:show("autokillSetView")
		end
	end
end
function WorldMapMonsterSearch:btnGoClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local cfg = self.menuTable[self.chooseIndex]
		if cfg and cfg.unlockKey then
			local unlockLv = funUnlockRead.getUnlockLevel(cfg.unlockKey)
			if unlockLv > SoraDGetCastleLv() then
				_ENV = nil
				;(nil).name = i18n(cfg.name)
				;(nil).lv = unlockLv
				SoraDShowMsgTip(i18n("common_text_2122", nil))
				return
			end
		end
		local findMonsterCtrl = gametop.playertop_:getModule("findMonsterCtrl")
		local curPos = cityCtrl:getCurCityPos()
		local _max = tonumber(self.textFieldUp:getText())
		local _min = tonumber(self.textFieldDown:getText())
		print("请求搜索:", _max, _min, self.chooseIndex, self.isNewMonsterSearch, self.isNewResourceSearch)
		SoraDConfigSet("Game:worldMapView:SearchIndex~integer", self.chooseIndex)
		local menuCfg = self.menuTable[self.chooseIndex]
		local sortIndex = menuCfg.sortIndex
		if sortIndex == 2 then
			self:gotoTreasure()
			self:removeFromParent()
		elseif sortIndex == 1 then
			findMonsterCtrl:sendSearchMonstersMsg(_min, _max, curPos.x, curPos.y, self.isNewMonsterSearch)
			SoraDShowLoading(self)
		elseif sortIndex == 10 or sortIndex == 17 then
			findMonsterCtrl:sendSearchSeaMonstersMsg(_min, _max, self.isNewMonsterSearch)
			SoraDShowLoading(self)
		elseif sortIndex == 9 then
			if self.selectIndex == 1 then
				findMonsterCtrl:sendSearchMapType(gWorldTypeServerDef.mapTypeBoss, gBossType.heroBattleBoss1, nil, nil, nil, nil, nil, 50, false)
			else
				findMonsterCtrl:sendSearchMapType(gWorldTypeServerDef.mapTypeBoss, gBossType.heroBattleBoss2, nil, nil, nil, nil, nil, 50, false)
			end
			SoraDShowLoading(self)
		elseif sortIndex == 11 then
			findMonsterCtrl:sendSearchBossMsg(self.selectIndex == 1 and gBossType.wrathBeastDrqsc or gBossType.wrathBeastDrq)
			SoraDShowLoading(self)
		elseif sortIndex == 12 then
			SoraDCreatePanel("endlessTrialsBossList"):show()
		elseif sortIndex == 13 then
			findMonsterCtrl:sendSearchBossMsg(gBossType.werewolf)
			SoraDShowLoading(self)
		elseif sortIndex == 15 then
			local lostRuinsCtrl = SoraDGetCtrl("lostRuinsCtrl")
			_ENV = gBossType.heroBattleBoss2
			lostRuinsCtrl:reqLostRuinsSearch(gBossType.heroBattleBoss2)
			SoraDShowLoading(self)
		elseif sortIndex == 16 then
		elseif sortIndex == 18 then
			findMonsterCtrl:sendSearchMapType(gMapObjTypeDef.mapTypeSemluk, nil, nil, 1, menuCfg.highestLv, nil, nil, nil, self.isNewMonsterSearch)
			SoraDShowLoading(self)
		elseif sortIndex == 26 then
			local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
			local subMapType = activity_9001737_Ctrl:getMyCamp()
			findMonsterCtrl:sendSearchMapType(gMapObjTypeDef.footballMonster, subMapType, nil, 1, menuCfg.highestLv, nil, nil, nil, self.isNewMonsterSearch)
			SoraDShowLoading(self)
		elseif sortIndex == 0 then
			findMonsterCtrl:sendSearchMapType(gMapObjTypeDef.nebulaNpc, nil, nil, _min, _max, nil, nil, nil, self.isNewMonsterSearch)
			SoraDShowLoading(self)
		elseif sortIndex == 19 then
			findMonsterCtrl:sendSearchMapType(gWorldTypeServerDef.mapTypeBoss, gBossType.wastelandBoss, nil, _min, _max, nil, nil, 50, false)
			SoraDShowLoading(self)
		elseif sortIndex == 20 then
			local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
			_ENV = gBossType.wastelandBoss
			snowWolfLostCtrl:reqSnowWolfLostSearch(gBossType.wastelandBoss)
			SoraDShowLoading(self)
		elseif sortIndex == 21 then
			local bossType = self.selectIndex == 1 and gBossType.fireDragon1 or gBossType.fireDragon2
			findMonsterCtrl:sendSearchMapType(gWorldTypeServerDef.mapTypeBoss, bossType, nil, 1, 2)
			SoraDShowLoading(self)
		elseif sortIndex == 23 then
			local legendOfPegasusCtrl = SoraDGetCtrl("legendOfPegasusCtrl")
			_ENV = gWorldTypeServerDef.mapTypeBoss
			legendOfPegasusCtrl:reqLegendOfPegasusSearch(gWorldTypeServerDef.mapTypeBoss)
			SoraDShowLoading()
		elseif sortIndex == 24 then
			local activity_9001602_Ctrl = SoraDGetCtrl("activity_9001602_Ctrl")
			_ENV = gWorldTypeServerDef.mapTypeBoss
			activity_9001602_Ctrl:reqLegendOfPegasusSearch(gWorldTypeServerDef.mapTypeBoss)
			SoraDShowLoading()
		elseif sortIndex == 25 then
			local activity_9001696_Ctrl = SoraDGetCtrl("activity_9001696_Ctrl")
			_ENV = gWorldTypeServerDef.mapTypeBoss
			activity_9001696_Ctrl:reqLegendOfPegasusSearch(gWorldTypeServerDef.mapTypeBoss)
			SoraDShowLoading()
		elseif sortIndex == 100 then
			findMonsterCtrl:sendSearchMapType(gMapObjTypeDef.mapObjTypeNpc, nil, nil, 1, 100, nil, nil, nil, true)
			SoraDShowLoading(self)
		elseif sortIndex == 200 then
			findMonsterCtrl:sendSearchRoaringFlameNpc(_min, _max)
			SoraDShowLoading(self)
		elseif sortIndex == 201 or sortIndex == 202 or sortIndex == 203 then
			local roaringFlameWarUtil = include("roaringFlameWarUtil")
			local ret = roaringFlameWarUtil.searchRoaringFlameWarBuild(menuCfg.subType)
			if ret then
				self:removeFromParent()
			end
		else
			if menuCfg.resDef and menuCfg.lvLimit and not SoraDResIsLock(menuCfg.resDef) then
				local buildLogic = include("buildLogic")
				local lv = resDesRead.getUnLockLevel(menuCfg.resDef)
				local warLv = buildLogic.transformBuildLvToWarLv(lv)
				if 0 < warLv then
					_ENV = 1
					;(1).lv = warLv
					lv = i18n("common_text_1948", 1)
				end
				_ENV = 1
				;(1).Level = lv
				local limitString = i18n("common_text_497", 1)
				SoraDShowMsgTip(limitString)
				return
			end
			findMonsterCtrl:sendSearchResourcesMsg(menuCfg.searchType, self.nodeRes:getSliderCurValue(), curPos.x, curPos.y, self.isNewResourceSearch)
			SoraDShowLoading(self)
		end
	end
end
function WorldMapMonsterSearch:recordIn()
	local min, max = tonumber(self.textFieldDown:getText()), tonumber(self.textFieldUp:getText())
	local menuCfg = self.menuTable[self.chooseIndex]
	local sortIndex = menuCfg.sortIndex
	local configKey = sortIndex2configKey[sortIndex] or sortIndex2configKey[1]
	_ENV = ","
	;(",").byUID = true
	SoraDConfigSet(configKey, min .. "," .. max, ",")
end
function WorldMapMonsterSearch:recordOut()
	local chooseType = self.guideChooseIdx ~= nil and self.guideChooseIdx or gModuleMgr.sharedMgr("mildGuideManager"):getVariate(self.__cname, "chooseIndex")
	dump(chooseType, "chooseType======")
	if chooseType then
		if type(chooseType) == "number" then
			self.chooseIndex = self:getChooseIndexBySortIndex(chooseType)
		end
		self:resetDisplayStatus()
	end
	local menuCfg = self.menuTable[self.chooseIndex]
	local sortIndex = menuCfg.sortIndex
	local configKey = sortIndex2configKey[sortIndex] or sortIndex2configKey[1]
	_ENV = nil
	;(nil).byUID = true
	local result = SoraDConfigGet(configKey, nil)
	dump(result, "result======")
	if result == "none" or result == nil then
		return false
	else
		local tbl = SoraDStringsSplit(result, ",")
		_ENV = result
		result.min = tonumber(tbl[1])
		result.max = tonumber(tbl[2])
		return result
	end
end
function WorldMapMonsterSearch:getChooseIndexByType(chooseType)
	for i, v in ipairs(self.menuTable) do
		if v.resDef and v.resDef == chooseType then
			return i
		end
	end
end
function WorldMapMonsterSearch:getChooseIndexBySortIndex(chooseType)
	for i, v in ipairs(self.menuTable) do
		if v.sortIndex and v.sortIndex == chooseType then
			return i
		end
	end
end
function WorldMapMonsterSearch:initScrollMenu(...)
	self.scroll:removeAllChildren()
	self.itemArray, _ENV = self.scroll.removeAllChildren, self.scroll.removeAllChildren
	for k, v in ipairs(self.menuTable) do
		local item = self.nodeSingle:clone()
		local cellImage = SoraDGetChildByName(item, "icon_cell")
		local cellBtn = SoraDGetChildByName(item, "btnCommon")
		local icon_lock = SoraDGetChildByName(item, "icon_lock")
		local Image_rbg = SoraDGetChildByName(item, "Image_rbg")
		Image_rbg:loadTexture("frame_common_round.png", ccui.TextureResType.plistType)
		Image_rbg:ignoreContentAdaptWithSize(true)
		Image_rbg:setScale(0.9)
		cellBtn:setSwallowTouches(false)
		cellBtn:setTag(v.activityID or k)
		if type(v.png) == "string" then
			cellImage:setSpriteFrame(v.png)
		elseif type(v.png) == "table" then
			cellImage:setSpriteFrame(v.png[1])
		end
		cellImage:setScale(v.pngScale or 0.5)
		cellImage:setPosition(v.pngPos or cc.p(45, 45))
		if v.resDef then
			cellImage:setColor(SoraDResIsLock(v.resDef) and cc.c3b(115, 115, 115) or cc.c3b(255, 255, 255))
		end
		item.dh_xz = SoraDGetChildByName(item, "dh_xz")
		item.dh_xz:setVisible(false)
		item.dh_xz:runAction(cc.RepeatForever:create(cca.rotateBy(2.1666666666666665, 360)))
		function item.setContentOpacity(opacity)
			item:setColor(cc.c3b(opacity, opacity, opacity))
			cellImage:setColor(cc.c3b(opacity, opacity, opacity))
		end
		function item.setContentScale(scale)
			item:setScale(1.2 * scale)
		end
		item.needAdjustY = false
		if v.unlockKey then
			local unlockLv = funUnlockRead.getUnlockLevel(v.unlockKey)
			if unlockLv <= SoraDGetCastleLv() then
				icon_lock:setVisible(false)
				SoraDNormalSprite(cellImage)
				icon_lock:getVirtualRenderer():setState(0)
				Image_rbg:getVirtualRenderer():setState(0)
			else
				icon_lock:setVisible(true)
				SoraDCreateGraySprite(cellImage)
				icon_lock:getVirtualRenderer():setState(1)
				Image_rbg:getVirtualRenderer():setState(1)
			end
		else
			icon_lock:setVisible(false)
			SoraDNormalSprite(cellImage)
			Image_rbg:getVirtualRenderer():setState(0)
		end
		table.insert(self.itemArray, item)
	end
	local activityID = gModuleMgr.sharedMgr("mildGuideManager"):getVariate(self.__cname, "activityID")
	print("=======activityID", self.__cname, activityID)
	if activityID then
		local toIndex = 0
		for k, v in ipairs(self.itemArray) do
			local cellBtn = SoraDGetChildByName(v, "btnCommon")
			local tag = cellBtn:getTag()
			if tag == activityID then
				toIndex = k
				break
			end
		end
		if 0 < toIndex then
			self.chooseIndex = toIndex
		end
	end
	self.scroll:initData(self.chooseIndex, self.itemArray, cc.size(120, 120), 60)
end
function WorldMapMonsterSearch:scrollMenuCallBack(index)
	self.chooseIndex = index
	for i, item in ipairs(self.itemArray) do
		item.dh_xz:setVisible(i == self.chooseIndex)
	end
	self:resetDisplayStatus()
	self:initText()
end
function WorldMapMonsterSearch:getNormalLvRang(...)
	local sortIndex = self.menuTable[self.chooseIndex].sortIndex
	if sortIndex == 200 then
		local towerLv = nebulaActivityCtrl:getTowerLv()
		local maxLv = nebulaTowerLvDesRead.getMonsterMaxLv(towerLv)
		nebulaActivityCtrl = towerLv
		towerLv.min = 31
		towerLv.max = maxLv
		return towerLv
	end
	nebulaActivityCtrl = towerLv
	nebulaActivityCtrl:getTowerLv().min = 1
	nebulaActivityCtrl:getTowerLv().max = 1
	return (nebulaActivityCtrl:getTowerLv())
end
function WorldMapMonsterSearch:gameGuide_getTarget(itemName, parameters)
	return SoraDGetChildByName(self, itemName)
end
return WorldMapMonsterSearch
