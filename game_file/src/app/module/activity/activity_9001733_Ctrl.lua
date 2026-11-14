local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local activity_9001733_Read = include("activity_9001733_Read")
local eventQuestRead = include("eventQuestRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local activity_9001733_Ctrl = class("activity_9001733_Ctrl", gamemodulec)
_ENV = "activity_9001733_Ctrl"
;("activity_9001733_Ctrl").REWARD = 1
;("activity_9001733_Ctrl").BOMB = 2
;("activity_9001733_Ctrl").BOX = 3
;("activity_9001733_Ctrl").PORTAL = 4
local _ENV, ("activity_9001733_Ctrl").NULL, CardType = gamemodulec, 5, "activity_9001733_Ctrl"
gamemodulec.HIDE = 0
local _ENV, gamemodulec.SHOW, CardState = nil, 1, gamemodulec
;(nil).NORMAL = 1
local (nil).ADVANCE, BattlePassTrack = 2, nil
local TASK_REFRESH_INTERVAL = 604800
_ENV = nil
;(nil).classType = true
;(nil).battlePass = true
;(nil).cardPool = true
;(nil).factory = true
local (nil).questData, ACTIVITY_DATA_KEYS = true, nil
local getShootCostInfo = function()
	local cost = activity_9001733_Read.getShootCost()
	local itemID = tonumber(cost and cost.id) or 0
	local itemCount = tonumber(cost and cost.count) or 0
	return itemID, math.max(itemCount, 1)
end
local function deepMerge(target, source)
