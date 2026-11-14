local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001558_Ctrl = class("activity_9001558_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001558_Ctrl:ctor(properties)
	activity_9001558_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.STELLAR_ODYSSEY_ACTIVITY
	self:resetData()
end
function activity_9001558_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_STELLAR_ODYSSEY_RECEIVE, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_STELLAR_ODYSSEY_EXCHANGE, handler(self, self.reqExchangeRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_STELLAR_ODYSSEY_REMIND, handler(self, self.reqRemindRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
end
function activity_9001558_Ctrl:Logout()
	activity_9001558_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001558_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function activity_9001558_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(self.activityID)]
	if activityData and next(activityData) then
		self.initData = activityData
		dump(self.initData, "==activity_9001558_Ctrl:initClientData==", 10)
	end
end
function activity_9001558_Ctrl:activityInitRsp(target, event)
	if event.activityID == self.activityID then
		dump(event, "==activity_9001558_Ctrl:activityInitRsp==", 10)
		self.initData = event.initData
	end
end
function activity_9001558_Ctrl:sendReqInitDataMsg()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function activity_9001558_Ctrl:reqReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_STELLAR_ODYSSEY_RECEIVE, nil)
end
function activity_9001558_Ctrl:reqReceiveRsp(content)
	dump(content, "activity_9001558_Ctrl:reqReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV, self.initData = content.rspdata, content.rspdata
		local content.rspdata[gIDDef.STELLAR_ODYSSEY_POINT], rewards = self:getExchangePoint(), content.rspdata
		SoraDMailGainItems(rewards)
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001558_RECEIVE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001558_Ctrl:reqExchange(shopID, count)
	serverproxy = nil
	;(nil).shopID = shopID
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_STELLAR_ODYSSEY_EXCHANGE, nil)
end
function activity_9001558_Ctrl:reqExchangeRsp(content)
	dump(content, "activity_9001558_Ctrl:reqExchangeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		local rewards = content.rspdata.rewards
		SoraDMailGainItems(rewards, true)
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001558_EXCHANGE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001558_Ctrl:reqRemind(shopID, status)
	serverproxy = nil
	;(nil).shopID = shopID
	;(nil).status = status
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_STELLAR_ODYSSEY_REMIND, nil)
end
function activity_9001558_Ctrl:reqRemindRsp(content)
	dump(content, "activity_9001558_Ctrl:reqRemindRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
	end
end
function activity_9001558_Ctrl:getQuestComponent(...)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local questComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	return questComponent
end
function activity_9001558_Ctrl:getQuestProgress(questID)
	local questComponent = self:getQuestComponent()
	return questComponent:getTaskProgress(questID)
end
function activity_9001558_Ctrl:getQuestStatus(questID)
	local questComponent = self:getQuestComponent()
	if questComponent:isTaskClaimed(questID) then
		return gBtnTargetStatusDef.GOT
	elseif questComponent:isTaskFinished(questID) then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activity_9001558_Ctrl:getCurOpenDay()
	local day = 1
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	if beginTime and 0 < beginTime then
		local diffTime = serviceFunctions.getTodayZeroHourUTC() - serviceFunctions.getTodayZeroHourUTC(beginTime)
		day = math.floor(diffTime / 86400) + 1
	end
	return math.max(1, day)
end
function activity_9001558_Ctrl:getFinishedQuestNum()
	local questComponent = self:getQuestComponent()
	return questComponent:getFinishedQuestNum()
end
function activity_9001558_Ctrl:getReceiveStageRemainTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local beginUTC0Time = serviceFunctions.getTodayZeroHourUTC(beginTime)
	local remainTime = beginUTC0Time + 518400 - serviceFunctions.systemTime()
	return math.max(0, remainTime)
end
function activity_9001558_Ctrl:getBoxStatus()
	if self:isBoxGot() then
		return gBtnTargetStatusDef.GOT
	elseif self:isBoxCanGet() then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activity_9001558_Ctrl:isBoxGot()
	return self.initData.isReceivePoint == 1
end
function activity_9001558_Ctrl:isBoxCanGet()
	return self:getReceiveStageRemainTime() <= 0
end
function activity_9001558_Ctrl:getExchangePoint(...)
	return self.initData.point or 0
end
function activity_9001558_Ctrl:getExchangeNum(shopID)
	if not self.initData.exchangeRecord then
		local _ENV, exchangeRecord = self.initData.exchangeRecord, self.initData.exchangeRecord
	end
	return exchangeRecord[tostring(shopID)] or 0
end
function activity_9001558_Ctrl:getIsRemind(shopID)
	if not self.initData.remind then
		local _ENV, remind = self.initData.remind, self.initData.remind
	end
	return not remind[tostring(shopID)]
end
function activity_9001558_Ctrl:getReceiveStatusAndNum()
	local questComponent = self:getQuestComponent()
	local ret = questComponent:getReceiveStatusAndNum()
	if ret then
		return true, -1
	end
	if self:getBoxStatus() == gBtnTargetStatusDef.GET then
		return true, -1
	end
	local ret = self:getExchangeStatusAndNum()
	if ret then
		return true, -1
	end
	return false
end
function activity_9001558_Ctrl:getExchangeStatusAndNum()
	local ownCount = self:getExchangePoint()
	if ownCount <= 0 then
		return false
	end
	local activity_9001558_Read = include("activity_9001558_Read")
	local exchangeList = activity_9001558_Read.getExchangeList()
	for i, v in ipairs(exchangeList) do
		if self:getIsRemind(v.shopItemID) then
			local curExchangeNum = self:getExchangeNum(v.shopItemID)
			if 0 < v.limit - curExchangeNum and ownCount >= v.exchangeItem then
				return true, -1
			end
		end
	end
	return false
end
function activity_9001558_Ctrl:getDayRewardNum(day)
	local activity_9001558_Read = include("activity_9001558_Read")
	local questComponent = self:getQuestComponent()
	local num = 0
	local cfgs = activity_9001558_Read.getTaskConfig(day)
	for __, cfg in pairs(cfgs) do
		local questList = cfg.taskID
		local ret, retNum = questComponent:getReceiveStatusAndNumByQuestList(questList)
		num = num + retNum
	end
	return num
end
function activity_9001558_Ctrl:getDayGroupRewardNum(day, groupID)
	local activity_9001558_Read = include("activity_9001558_Read")
	local questComponent = self:getQuestComponent()
	local questList = activity_9001558_Read.getTaskIDList(day, groupID)
	local ret, retNum = questComponent:getReceiveStatusAndNumByQuestList(questList)
	return retNum
end
return activity_9001558_Ctrl
