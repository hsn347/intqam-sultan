local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = class("activity_9001738_Ctrl", gamemodulec)
_ENV = "activity_9001738_Ctrl"
;("activity_9001738_Ctrl").MATCHING = 1
;("activity_9001738_Ctrl").TURN_OVER = 2
local _ENV, ("activity_9001738_Ctrl").LOCKED, gGreenGrassFlipState = gamemodulec, 3, "activity_9001738_Ctrl"
gamemodulec.BOMB1 = 1
gamemodulec.BOMB2 = 2
gamemodulec.LOCK = 3
local gamemodulec.FATE, gGreenGrassFlipItemEffect = 4, gamemodulec
local getRspData = function(content)
	if not content then
		_UPVALUE0_ = nil
		return nil
	end
	if not content.rspdata and (not content.data or not content.data.retdata) then
		_UPVALUE0_ = content.data.retdata
	end
	return content.data.retdata
end
local extractInitData = function(data)
	if type(data) ~= "table" then
		return nil
	end
	if data.initData then
		return data.initData
	end
	if data.activityData then
		return data.activityData
	end
	if data.round ~= nil or data.classType ~= nil or data.levelId ~= nil or data.signRewardLv ~= nil then
		return data
	end
end
function activity_9001738_Ctrl:ctor(properties)
	activity_9001738_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
	self:resetData()
end
function activity_9001738_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_FLIP_MODULE, gCmd.REQ_GREEN_GRASS_FLIP_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_FLIP_MODULE, gCmd.REQ_GREEN_GRASS_FLIP_SIGN, handler(self, self.reqSignRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_FLIP_MODULE, gCmd.REQ_GREEN_GRASS_FLIP_ENTER, handler(self, self.reqEnterRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_FLIP_MODULE, gCmd.REQ_GREEN_GRASS_FLIP_CARD, handler(self, self.reqCardRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_FLIP_MODULE, gCmd.REQ_GREEN_GRASS_FLIP_USE_ITEM, handler(self, self.reqUseItemRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_FLIP_MODULE, gCmd.REQ_GREEN_GRASS_FLIP_RANKING, handler(self, self.reqRankingRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_FLIP_MODULE, gCmd.REQ_GREEN_GRASS_FLIP_EXIT, handler(self, self.reqExitRsp))
	self:registerNotify()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
end
function activity_9001738_Ctrl:Logout()
	activity_9001738_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001738_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).classType = 0
	;(nil).signRewardLv = 0
	;(nil).signRewardLvPay = 0
	;(nil).isAdvanceRewardUnlock = false
	;(nil).dailyGift, _UPVALUE0_, (nil).dailyGiftResetTime = nil, nil, 0
	;(nil).inGame = false
	;(nil).clearanceTime, _UPVALUE0_, (nil).levelId = nil, nil, 0
	;(nil).usedItem, _UPVALUE0_, (nil).itemList, _UPVALUE0_, (nil).levelFlipData, _UPVALUE0_, (nil).levelData, _UPVALUE0_, (nil).startTime = nil, nil, nil, nil, nil, nil, nil, nil, 0
	;(nil).maxLevleId = 0
	self.rankData, _UPVALUE0_, self.activityData, (nil).itemUsing = nil, nil, nil, 0
end
local getMaxClearedLevelFromClearanceTime = function(clearanceTime)
