local magicFlipRead = include("magicFlipRead")
local constantRead = include("constantRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001630_Ctrl = class("activity_9001630_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001630_Ctrl:ctor(properties)
	activity_9001630_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_DISNEYLADN
	self.itemID = constantRead.getConstValue("NEBULA_PARADISE_DRAW_ITEM", 868901)
	self:resetData()
end
function activity_9001630_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_LOTTERY, handler(self, self.reqLotteryRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_RECORD, handler(self, self.reqRecordRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_DAILY, handler(self, self.reqDailyRsp))
	self:registerNotify()
end
function activity_9001630_Ctrl:Logout()
	activity_9001630_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001630_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function activity_9001630_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MAGIC_FLIP, handler(self, self.notifyHandler))
end
function activity_9001630_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001630_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData = v
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001630_UPDATE"
		;(nil).subMsg = "init"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
	end
end
function activity_9001630_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_INIT, nil)
end
function activity_9001630_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001630_Ctrl:reqInitRsp(content)", 10)
	self.initData = content.rspdata
	dump(self.initData, "activity_9001630_Ctrl:reqInitRsp(self.initData)", 10)
	_ENV = self.initData
	self.initData.msg = "MESSAGE_ACTIVITY_9001630_UPDATE"
	self.initData.subMsg = "init"
	SoraDSendMessage(self.initData)
	_ENV = self.initData
	self.initData.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.initData.eventID = self.activityID
	SoraDSendMessage(self.initData)
end
function activity_9001630_Ctrl:reqLottery(times)
	serverproxy = nil
	;(nil).times = times
	serverproxy:Request(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_LOTTERY, nil)
end
function activity_9001630_Ctrl:reqLotteryRsp(content)
	dump(content, "activity_9001630_Ctrl:reqLotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		if content.data.times == 1 then
			_ENV = gErrDef.Err_None
			gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001630_UPDATE"
			gErrDef.Err_None.subMsg = "one"
			gErrDef.Err_None.reward = content.rspdata.rewards
			SoraDSendMessage(gErrDef.Err_None)
		elseif content.data.times == 10 then
			_ENV = 10
			;(10).itemType = 4
			;(10).rewards = content.rspdata.rewardIds
			;(10).width = 640
			uiManager:show("CommonCongratulations", 10)
			_ENV = uiManager
			uiManager.msg = "MESSAGE_ACTIVITY_9001630_UPDATE"
			uiManager.subMsg = "ten"
			SoraDSendMessage(uiManager)
		end
		_ENV = uiManager
		uiManager.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		uiManager.eventID = self.activityID
		SoraDSendMessage(uiManager)
	end
end
function activity_9001630_Ctrl:reqRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_RECORD, nil)
end
function activity_9001630_Ctrl:reqRecordRsp(content)
	dump(content, "activity_9001630_Ctrl:reqRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001630_UPDATE"
		gErrDef.Err_None.subMsg = "log"
		gErrDef.Err_None.logData = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001630_Ctrl:reqDaily()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_DAILY, nil)
end
function activity_9001630_Ctrl:reqDailyRsp(content)
	dump(content, "activity_9001630_Ctrl:reqRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001630_UPDATE"
		content.rspdata.rewards.subMsg = "init"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001630_Ctrl:reqStageReward(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_NEBULA_DISNEYLAND_MODULE, gCmd.REQ_NEBULA_DISNEYLAND_REWARD, nil)
end
function activity_9001630_Ctrl:reqStageRewardRsp(content)
	dump(content, "activity_9001630_Ctrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.stageRewards = content.rspdata.stageRewards
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001630_UPDATE"
		content.rspdata.rewards.subMsg = "stage"
		SoraDSendMessage(content.rspdata.rewards)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewards.eventID = self.activityID
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001630_Ctrl:getScore()
	return self.initData.score or 0
end
function activity_9001630_Ctrl:getFlipLog()
	if not self.initData.flipRecord then
		_UPVALUE0_ = self.initData.flipRecord
	end
	return self.initData.flipRecord
end
function activity_9001630_Ctrl:getNewCardRecord()
	if self.initData.record and next(self.initData.record) then
		return self.initData.record[#self.initData.record].id
	end
end
function activity_9001630_Ctrl:getFlipCount()
	return self.initData.count or 0
end
function activity_9001630_Ctrl:getIsDouble()
	return self.initData.double or false
end
function activity_9001630_Ctrl:getStageStatues(index, num)
	local ret = 0
	if self.initData.stageRewards then
		ret = self.initData.stageRewards[tostring(index)] or 0
	end
	return ret
end
function activity_9001630_Ctrl:getReceiveStatusAndNum()
	local ret = 0
	local num = SoraDGetCtrl("backpackCtrl"):getItemCount(self.itemID)
	ret = ret + num
	local activity_9001630_Read = include("activity_9001630_Read")
	local boxInfos = activity_9001630_Read.getStageConfig()
	for i, v in ipairs(boxInfos) do
		if self:getBoxRewardDataStatus(v.index, v.point) == gBtnTargetStatusDef.GET then
			ret = ret + 1
		end
	end
	if self:getIsHaveDaily() then
		ret = ret + 1
	end
	return 0 < ret, -1
end
function activity_9001630_Ctrl:getStageRedNum()
	local ret = 0
	if self.initData.stageRewards then
		for i, v in pairs(self.initData.stageRewards) do
			if v == gMmagicFlipStatus.CAN_RECEIVE then
				ret = ret + 1
			end
		end
	end
	return ret
end
function activity_9001630_Ctrl:getBoxRewardDataStatus(index, num)
	dump(self.initData, "self.initData.stageRewards")
	if self.initData.stageRewards and self.initData.stageRewards[tostring(index)] then
		return gBtnTargetStatusDef.GOT
	end
	local nowNum = self:getScore()
	_UPVALUE2_ = index
	index[1] = num
	index[2] = nowNum
	dump(index, "num <= nowNum")
	if num <= nowNum then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function activity_9001630_Ctrl:getGroupID()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID) or 1
end
function activity_9001630_Ctrl:getIsHaveDaily()
	if self.initData.lastRewardTime == nil then
		return true
	end
	return not serviceFunctions.isSameDay(self.initData.lastRewardTime)
end
return activity_9001630_Ctrl
