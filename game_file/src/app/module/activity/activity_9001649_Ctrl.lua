local magicFlipRead = include("magicFlipRead")
local constantRead = include("constantRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001649_Ctrl = class("activity_9001649_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001649_Ctrl:ctor(properties)
	activity_9001649_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
	self:resetData()
end
function activity_9001649_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GEOCENTRIC_EXPLORATION_MODULE, gCmd.REQ_GEOCENTRIC_EXPLORATION_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_GEOCENTRIC_EXPLORATION_MODULE, gCmd.REQ_GEOCENTRIC_EXPLORATION_GRAB, handler(self, self.reqLotteryRsp))
	msgCtrl.register(gCmd.CMD_GEOCENTRIC_EXPLORATION_MODULE, gCmd.REQ_GEOCENTRIC_EXPLORATION_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_GEOCENTRIC_EXPLORATION_MODULE, gCmd.REQ_GEOCENTRIC_EXPLORATION_GRAP_ALL, handler(self, self.reqLotteryAllRsp))
	self:registerNotify()
end
function activity_9001649_Ctrl:Logout()
	activity_9001649_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001649_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function activity_9001649_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GEOCENTRIC_EXPLORATION, handler(self, self.notifyHandler))
end
function activity_9001649_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001649_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData = v
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001649_UPDATE"
		;(nil).subMsg = "init"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
	end
end
function activity_9001649_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GEOCENTRIC_EXPLORATION_MODULE, gCmd.REQ_GEOCENTRIC_EXPLORATION_INIT, nil)
end
function activity_9001649_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001649_Ctrl:reqInitRsp(content)", 10)
	self.initData = content.rspdata
	dump(self.initData, "activity_9001649_Ctrl:reqInitRsp(self.initData)", 10)
	_ENV = self.initData
	self.initData.msg = "MESSAGE_ACTIVITY_9001649_UPDATE"
	self.initData.subMsg = "init"
	SoraDSendMessage(self.initData)
	_ENV = self.initData
	self.initData.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.initData.eventID = self.activityID
	SoraDSendMessage(self.initData)
end
function activity_9001649_Ctrl:reqLottery(mineId, isAuto)
	serverproxy = nil
	;(nil).mineId = mineId
	;(nil).isAuto = isAuto
	serverproxy:Request(gCmd.CMD_GEOCENTRIC_EXPLORATION_MODULE, gCmd.REQ_GEOCENTRIC_EXPLORATION_GRAB, nil)
end
function activity_9001649_Ctrl:reqLotteryRsp(content)
	dump(content, "activity_9001649_Ctrl:reqLotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001649_UPDATE"
		_ENV, gErrDef.Err_None.subMsg = "activity_9001649_Ctrl:reqLotteryRsp(content)", "one"
		;("activity_9001649_Ctrl:reqLotteryRsp(content)").rewards = content.rspdata.rewards
		;("activity_9001649_Ctrl:reqLotteryRsp(content)").mineType = content.rspdata.mineType
		gErrDef.Err_None.reward, ("activity_9001649_Ctrl:reqLotteryRsp(content)").itemorder = "activity_9001649_Ctrl:reqLotteryRsp(content)", content.rspdata.itemorder
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001649_UPDATE"
		gErrDef.Err_None.subMsg = "error"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001649_Ctrl:reqLotteryAll()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GEOCENTRIC_EXPLORATION_MODULE, gCmd.REQ_GEOCENTRIC_EXPLORATION_GRAP_ALL, nil)
end
function activity_9001649_Ctrl:reqLotteryAllRsp(content)
	dump(content, "activity_9001649_Ctrl:reqLotteryAllRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001649_UPDATE"
		_ENV, gErrDef.Err_None.subMsg = "activity_9001649_Ctrl:reqLotteryAllRsp(content)", "all"
		gErrDef.Err_None.reward, ("activity_9001649_Ctrl:reqLotteryAllRsp(content)").rewardsList = "activity_9001649_Ctrl:reqLotteryAllRsp(content)", content.rspdata.rewardsList
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001649_UPDATE"
		gErrDef.Err_None.subMsg = "error"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001649_Ctrl:reqStageReward(times)
	serverproxy = nil
	;(nil).times = times
	serverproxy:Request(gCmd.CMD_GEOCENTRIC_EXPLORATION_MODULE, gCmd.REQ_GEOCENTRIC_EXPLORATION_STAGE_REWARD, nil)
end
function activity_9001649_Ctrl:reqStageRewardRsp(content)
	dump(content, "activity_9001649_Ctrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001649_UPDATE"
		content.rspdata.rewards.subMsg = "stage"
		SoraDSendMessage(content.rspdata.rewards)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewards.eventID = self.activityID
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001649_Ctrl:getScore()
	return self.initData.times or 0
end
function activity_9001649_Ctrl:getLuckyNum()
	return self.initData.luckyNum or 0
end
function activity_9001649_Ctrl:getStageStatues(index, num)
	local ret = 0
	if self.initData.stageReward then
		ret = self.initData.stageReward[tostring(num)] or 0
	end
	return ret
end
function activity_9001649_Ctrl:getReceiveStatusAndNum()
	local ret = 0
	local activity_9001649_Read = include("activity_9001649_Read")
	local itemCfg = activity_9001649_Read.getItemCfg().expend
	local itemID = itemCfg[1]
	local num = SoraDGetCtrl("backpackCtrl"):getItemCount(itemID)
	if num > itemCfg[2] then
		return true, -1
	end
	local boxInfos = activity_9001649_Read.getStageConfig()
	for i, v in ipairs(boxInfos) do
		if self:getBoxRewardDataStatus(v.index, v.point) == gBtnTargetStatusDef.GET then
			return true, -1
		end
	end
	return false
end
function activity_9001649_Ctrl:getBoxRewardDataStatus(index, num)
	if self.initData.stageReward and self.initData.stageReward[tostring(num)] then
		return gBtnTargetStatusDef.GOT
	end
	local nowNum = self:getScore()
	if num <= nowNum then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function activity_9001649_Ctrl:getMineData()
	if not self.initData or not self.initData.grapedMines then
		_UPVALUE0_ = self.initData.grapedMines
	end
	return self.initData.grapedMines
end
function activity_9001649_Ctrl:getRandomMine()
	return self.initData and self.initData.randomMine or 1
end
function activity_9001649_Ctrl:getGroupID()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID) or 1
end
function activity_9001649_Ctrl:setAutoRewards(autoRewards)
	self.autoRewards = autoRewards
end
function activity_9001649_Ctrl:getAutoRewards()
	return self.autoRewards
end
return activity_9001649_Ctrl
