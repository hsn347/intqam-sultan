local gamemodulec = include("GameModule")
local activity_9001736_Ctrl = class("activity_9001736_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001736_Read = include("activity_9001736_Read")
function activity_9001736_Ctrl:ctor(properties)
	activity_9001736_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
	self:resetData()
end
function activity_9001736_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_SIGN, handler(self, self.reqSignRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_QUEST_REWARD, handler(self, self.reqQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_DRAW_CARD, handler(self, self.reqDrawCardRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_UP_LEVEL, handler(self, self.reqUpLevelRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_SELECT_SEED, handler(self, self.reqSelectSeedRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_BATTLE_LIST, handler(self, self.reqBattleListRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_BATTLE, handler(self, self.reqBattleRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_RESET, handler(self, self.reqResetRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_TASK_REWARD, handler(self, self.reqTaskRewardRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_RECORD, handler(self, self.reqRecordRsp))
	msgCtrl.register(gCmd.CMD_BALL_FIELD_MATCH_MODULE, gCmd.REQ_BALL_FIELD_MATCH_ENTER, handler(self, self.reqEnterGameRsp))
	self:registerNotify()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	_UPVALUE2_ = "backpackCtrl"
	self.itemIdList, ("backpackCtrl")[1] = "backpackCtrl", 881801
	self.itemIdList, ("backpackCtrl")[2] = "backpackCtrl", 881701
	for _, itemId in ipairs(self.itemIdList) do
		backpackCtrl:addItemChangeEvent(itemId, handler(self, self.notifyItemCount))
	end
end
function activity_9001736_Ctrl:getItemIdList()
	return self.itemIdList
end
function activity_9001736_Ctrl:notifyItemCount(...)
	print("==activity_9001736_Ctrl:notifyItemCount==", ...)
	_ENV = "==activity_9001736_Ctrl:notifyItemCount=="
	;("==activity_9001736_Ctrl:notifyItemCount==").msg = "MESSAGE_ACTIVITY_9001736_ITEM_COUNT"
	SoraDSendMessage("==activity_9001736_Ctrl:notifyItemCount==")
end
function activity_9001736_Ctrl:Logout()
	activity_9001736_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001736_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).classType = 0
	;(nil).isEnterGame = false
	;(nil).score = 0
	;(nil).power = 0
	;(nil).battleSeedList, _UPVALUE0_, (nil).seedMap, _UPVALUE0_, (nil).exp = nil, nil, nil, nil, 0
	;(nil).challengeTimes = 0
	;(nil).changeRecord, _UPVALUE0_, (nil).battleListRefreshTimes = nil, nil, 0
	;(nil).dailyResetTime = 0
	;(nil).signRewardLv = 0
	;(nil).signRewardLvPay = 0
	;(nil).questData, _UPVALUE0_, (nil).dailyGift, _UPVALUE0_, (nil).isAdvanceRewardUnlock = nil, nil, nil, nil, false
	;(nil).maxScore = 0
	;(nil).battleTimes = 0
	;(nil).seedRTypeNum = 0
	;(nil).seedSRTypeNum = 0
	;(nil).seedSSRTypeNum = 0
	self.initData, (nil).taskRewardInfo, _UPVALUE0_, (nil).seedURTypeNum = nil, nil, nil, 0
end
function activity_9001736_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.BALL_FIELD_MATCH, handler(self, self.notifyHandler))
end
function activity_9001736_Ctrl:notifyHandler(event)
