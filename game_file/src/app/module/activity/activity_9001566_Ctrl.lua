local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001566_Ctrl = class("activity_9001566_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local worldMapWarDef = include("worldMapWarDef")
function activity_9001566_Ctrl:ctor(properties)
	activity_9001566_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityIDMap = worldMapWarDef.getItemRebateActivityIDMap()
end
function activity_9001566_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ITEM_REBATE_MODULE, gCmd.CMD_ITEM_REBATE_INIT, handler(self, self.reqItemRebateInitRsp))
	msgCtrl.register(gCmd.CMD_ITEM_REBATE_MODULE, gCmd.CMD_ITEM_REBATE_REWARD, handler(self, self.reqItemRebateRewardRsp))
	self:registerNotify()
	print("==activity_9001566_Ctrl:EnterGame==")
end
function activity_9001566_Ctrl:Logout()
	activity_9001566_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001566_Ctrl:resetData()
	self.activityInfo, _UPVALUE0_ = nil, nil
end
function activity_9001566_Ctrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==activity_9001566_Ctrl:initClientData==", 10)
	self.initData = data
end
function activity_9001566_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ITEM_REBATE, handler(self, self.notifyHandler))
end
function activity_9001566_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001566_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "refreshData" then
			self:setActivityInfo(v.data.activityInfo)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001566_UPDATE"
			SoraDSendMessage(self)
		end
	end
end
function activity_9001566_Ctrl:sendReqInitDataMsg(...)
	for activityID, __ in pairs(self.activityIDMap) do
		if clientEventMgr.judgeIsOpen(activityID) then
			self:reqItemRebateInit()
			break
		end
	end
end
function activity_9001566_Ctrl:reqItemRebateInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ITEM_REBATE_MODULE, gCmd.CMD_ITEM_REBATE_INIT, nil)
end
function activity_9001566_Ctrl:reqItemRebateInitRsp(content)
	dump(content, "activity_9001566_Ctrl:reqItemRebateInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setActivityInfo(content.rspdata.activityInfo)
	end
end
function activity_9001566_Ctrl:reqItemRebateReward(activityId, eventType, idx)
	serverproxy = nil
	;(nil).activityId = activityId
	;(nil).eventType = eventType
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_ITEM_REBATE_MODULE, gCmd.CMD_ITEM_REBATE_REWARD, nil)
end
function activity_9001566_Ctrl:reqItemRebateRewardRsp(content)
	dump(content, "activity_9001566_Ctrl:reqItemRebateRewardRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:setActivityInfo(content.rspdata.data.activityInfo)
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001566_UPDATE"
		content.rspdata.rewards.eventType = content.data.eventType
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001566_Ctrl:setActivityInfo(activityInfo)
	self.activityInfo = activityInfo
	self:updateRedPointNum()
end
function activity_9001566_Ctrl:getActivityInfo(activityId)
	if activityId then
		return self.activityInfo[tostring(activityId)]
	else
		return self.activityInfo
	end
end
function activity_9001566_Ctrl:checkRewardInfo(param)
	if not self:getActivityInfo(param.activityId) then
		local _ENV, activityInfo = self:getActivityInfo(param.activityId), self:getActivityInfo(param.activityId)
	end
	if not activityInfo.rewardInfo then
		local _ENV, rewardInfo = activityInfo.rewardInfo, activityInfo.rewardInfo
	end
	local info = rewardInfo[tostring(param.eventType)]
	if info and info[tostring(param.idx)] then
		return true
	end
end
function activity_9001566_Ctrl:getEventProgress(activityId, eventType)
	if not self:getActivityInfo(activityId) then
		local _ENV, activityInfo = self:getActivityInfo(activityId), self:getActivityInfo(activityId)
	end
	if not activityInfo.eventProgress then
		local _ENV, eventProgress = activityInfo.eventProgress, activityInfo.eventProgress
	end
	local progress = eventProgress[tostring(eventType)]
	return progress or 0
end
function activity_9001566_Ctrl:checkEventProgress(param)
	local progress = self:getEventProgress(param.activityId, param.eventType)
	if 0 < progress then
		local activity_9001566_Read = include("activity_9001566_Read")
		local target = activity_9001566_Read.getTaskTarget(param)
		return progress >= target
	end
end
function activity_9001566_Ctrl:getRewardState(param)
	if self:checkRewardInfo(param) then
		return gBtnTargetStatusDef.GOT
	end
	if self:checkEventProgress(param) then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activity_9001566_Ctrl:getCurEventStage(activityId, eventType)
	if not self:getActivityInfo(activityId) then
		local _ENV, activityInfo = self:getActivityInfo(activityId), self:getActivityInfo(activityId)
	end
	local progress = self:getEventProgress(activityId, eventType)
	local activity_9001566_Read = include("activity_9001566_Read")
	local stageList = activity_9001566_Read.getTaskStageList(activityId, eventType)
	local curStage = 0
	for i, stage in ipairs(stageList) do
		if stage <= progress then
			curStage = i
		end
	end
	return curStage, curStage >= #stageList
end
function activity_9001566_Ctrl:isItemRebateActivityID(activityId)
	if self.activityIDMap[activityId] then
		return true
	else
		return false
	end
end
function activity_9001566_Ctrl:getActivityIDInWar(...)
	return worldMapWarDef.getItemRebateActivityIDInWar()
end
function activity_9001566_Ctrl:getRedPointNum(activityId)
	if self.activityRedMap and self.activityRedMap[activityId] then
		return 1
	else
		return 0
	end
end
function activity_9001566_Ctrl:updateRedPointNum(...)
	self.activityRedMap, _ENV = nil, nil
	for k, v in pairs(self.activityInfo) do
		local activityId = tonumber(k)
		if self:checkActivityRedPointNum(activityId) then
			self.activityRedMap[activityId] = true
		end
	end
end
function activity_9001566_Ctrl:checkActivityRedPointNum(activityId)
	local activity_9001566_Read = include("activity_9001566_Read")
	_ENV = nil
	;(nil).activityId = activityId
	local cfg = activity_9001566_Read.getTaskConfig(nil)
	for eventType, v in pairs(cfg) do
		for idx, __ in ipairs(v) do
			_ENV = nil
			;(nil).activityId = activityId
			;(nil).eventType = eventType
			;(nil).idx = idx
			local state = self:getRewardState(nil)
			if state == gBtnTargetStatusDef.GET then
				return true
			end
		end
	end
end
return activity_9001566_Ctrl
