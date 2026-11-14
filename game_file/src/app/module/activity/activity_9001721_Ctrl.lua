local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001721_Ctrl = class("activity_9001721_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001721_Read = include("activity_9001721_Read")
function activity_9001721_Ctrl:ctor(properties)
	activity_9001721_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY
	self:resetData()
end
function activity_9001721_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CAPTURE_MONKEY_CREATE, handler(self, self.reqCaptureMonkeyCreateRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.onMsgUpdateModuleData))
	self:registerNotify()
end
function activity_9001721_Ctrl:Logout()
	activity_9001721_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001721_Ctrl:resetData()
	;(nil).army, _UPVALUE0_, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil
	;(nil).endTime = 0
	_UPVALUE0_, (nil).leftAttackNum = nil, 0
	;(nil).x = 0
	;(nil).bossInfo, (nil).pos, (nil).y = nil, nil, 0
	self.initData, (nil).questData, (nil).questProgress, _UPVALUE0_, (nil).payReward, _UPVALUE0_, (nil).finishedQuest, _UPVALUE0_, (nil).claimedQuest, _UPVALUE0_, _UPVALUE0_, (nil).point = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
end
function activity_9001721_Ctrl:updateInitData(data)
	if data.bossInfo then
		self.initData.bossInfo = data.bossInfo
	end
	if data.point then
		self.initData.point = data.point
	end
	if data.questData then
		self.initData.questData = data.questData
	end
end
function activity_9001721_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(self.activityID)]
	dump(activityData, "==activity_9001721_Ctrl:initClientData==", 10)
	if not activityData then
		return
	end
	self:updateInitData(activityData)
	self:createQuestComponent(activityData.questData)
end
function activity_9001721_Ctrl:onMsgUpdateModuleData(target, event)
	if event.activityID == self.activityID then
		dump(event, "activity_9001721_Ctrl:onMsgUpdateModuleData")
		self:updateInitData(event.initData)
		self:createQuestComponent(event.initData.questData)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001721_UPDATE"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function activity_9001721_Ctrl:createQuestComponent(questData)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
		self.questComponent:setQuestData(questData)
	end
end
function activity_9001721_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function activity_9001721_Ctrl:notifyHandler(event)
	dump(event, "activity_9001721_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.activityID == self.activityID then
			if v.notifyType == "updateData" then
				self:updateInitData(v.notifyData)
			elseif v.notifyType == "progressUpdate" and self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001721_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001721_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local num1, num2 = self:getTaskReceiveNum()
	local numTask = num1 + num2
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local ret = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	if ret then
		num = num + 1
	end
	num = num + numTask
	return 0 < num, 0 < numTask and num or -1
end
function activity_9001721_Ctrl:reqCaptureMonkeyCreate()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CAPTURE_MONKEY_CREATE, nil)
end
function activity_9001721_Ctrl:reqCaptureMonkeyCreateRsp(content)
	dump(content, "activity_9001721_Ctrl:reqCaptureMonkeyCreateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateInitData(content.rspdata)
		SoraDGotoWorldMapPoint(cc.p(self:getBossPos()), true)
		_ENV = cc.p(self:getBossPos())
		cc.p(self:getBossPos()).msg = "MESSAGE_ACTIVITY_9001721_UPDATE"
		SoraDSendMessage((cc.p(self:getBossPos())))
		SoraDRemoveAllPanelFromManager()
	end
end
function activity_9001721_Ctrl:getPoint()
	return self.initData.point
end
function activity_9001721_Ctrl:isBossAlive()
	return self.initData.bossInfo.leftAttackNum > 0 and 0 < self:getBossResetTime()
end
function activity_9001721_Ctrl:getBossPos()
	return self.initData.bossInfo.pos
end
function activity_9001721_Ctrl:getBossLeftLife()
	return self.initData.bossInfo.leftLife
end
function activity_9001721_Ctrl:getBossLeftAttackNum()
	return self.initData.bossInfo.leftAttackNum
end
function activity_9001721_Ctrl:getBossResetTime()
	return self.initData.bossInfo.endTime - serviceFunctions.systemTime()
end
function activity_9001721_Ctrl:getTaskProgress(taskID)
	if self.questComponent then
		return self.questComponent:getTaskProgress(taskID)
	end
	return 0
end
function activity_9001721_Ctrl:getIsTaskClaimed(taskID)
	if self.questComponent then
		return self.questComponent:isTaskClaimed(taskID)
	end
	return false
end
function activity_9001721_Ctrl:getIsTaskFinished(taskID)
	if self.questComponent then
		return self.questComponent:isTaskFinished(taskID)
	end
	return false
end
function activity_9001721_Ctrl:getTaskStatus(taskID)
	local status = gBtnTargetStatusDef.NONE
	if self:getIsTaskClaimed(taskID) then
		status = gBtnTargetStatusDef.GOT
	elseif self:getIsTaskFinished(taskID) then
		status = gBtnTargetStatusDef.GET
	else
		status = gBtnTargetStatusDef.GO
	end
	return status
end
function activity_9001721_Ctrl:getTaskReceiveNum()
	local taskList1 = activity_9001721_Read.getTaskCfg(1)
	local taskList2 = activity_9001721_Read.getTaskCfg(2)
	local num1 = 0
	for _, v in ipairs(taskList1) do
		if self:getTaskStatus(v) == gBtnTargetStatusDef.GET then
			num1 = num1 + 1
		end
	end
	local num2 = 0
	for _, v in ipairs(taskList2) do
		if self:getTaskStatus(v) == gBtnTargetStatusDef.GET then
			num2 = num2 + 1
		end
	end
	return num1, num2
end
return activity_9001721_Ctrl
