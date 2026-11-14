local activity_9001571_Read = include("activity_9001571_Read")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001571_Ctrl = class("activity_9001571_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001571_Ctrl:ctor(properties)
	activity_9001571_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001571
	self:resetData()
end
function activity_9001571_Ctrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.reqActivityInitDataRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_HERO_ORDER_RECEIVE, handler(self, self.reqHeroOrderReceiveRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_HERO_ORDER_CHANGE_REWARD_GROUP, handler(self, self.reqHeroOrderChangeRewardGroupRsp))
	self:registerNotify()
end
function activity_9001571_Ctrl:initClientData(data)
	dump(data, "==activity_9001571_Ctrl:initClientData==", 10)
	if not data then
		return
	end
	self.initData = data
end
function activity_9001571_Ctrl:Logout()
	activity_9001571_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001571_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function activity_9001571_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function activity_9001571_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001571_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.activityID == self.activityID and v.notifyType == "updateData" then
			self:initClientData(v.notifyData)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001571_UPDATE"
			self.subMsg = "updateData"
			SoraDSendMessage(self)
		end
	end
end
function activity_9001571_Ctrl:sendReqInitDataMsg()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function activity_9001571_Ctrl:reqActivityInitDataRsp(target, data)
	dump(data, "reqActivityInitDataRsp")
	if data.activityID == self.activityID then
		self:initClientData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001571_UPDATE"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function activity_9001571_Ctrl:reqHeroOrderReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_HERO_ORDER_RECEIVE, nil)
end
function activity_9001571_Ctrl:reqHeroOrderReceiveRsp(content)
	dump(content, "activity_9001571_Ctrl:reqHeroOrderReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.initData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001571_UPDATE"
		content.rspdata.reward.subMsg = "getAward"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function activity_9001571_Ctrl:reqHeroOrderChangeRewardGroup(groupID)
	serverproxy = nil
	;(nil).groupID = groupID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_HERO_ORDER_CHANGE_REWARD_GROUP, nil)
end
function activity_9001571_Ctrl:reqHeroOrderChangeRewardGroupRsp(content)
	dump(content, "activity_9001571_Ctrl:reqHeroOrderChangeRewardGroupRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001571_UPDATE"
		self.subMsg = "changeGroup"
		SoraDSendMessage(self)
	end
end
function activity_9001571_Ctrl:getExp()
	return self.initData.curExp or 0
end
function activity_9001571_Ctrl:getLevel()
	return self.initData.curLv or 0
end
function activity_9001571_Ctrl:getGroupID()
	return self.initData.groupID or 0
end
function activity_9001571_Ctrl:isRewardUnlock()
	if self.initData.unlockTime and self.initData.unlockTime > 0 then
		return true
	end
	return false
end
function activity_9001571_Ctrl:getRewardLevel(type)
	return self.initData.lv and self.initData.lv[type] or 0
end
function activity_9001571_Ctrl:getRewardState(type, lv)
	if lv <= self:getRewardLevel(type) then
		return gBtnTargetStatusDef.GOT
	elseif lv <= self:getLevel() then
		if type == 2 and self:isRewardUnlock() or type == 1 then
			return gBtnTargetStatusDef.GET
		else
			return gBtnTargetStatusDef.GO
		end
	end
	return gBtnTargetStatusDef.GO
end
function activity_9001571_Ctrl:getTaskList()
	if not self.initData.questList then
		local _ENV, taskList = self.initData.questList, self.initData.questList
	end
	table.sort(taskList, function(l, r)
		local lState = self:getTaskState(l)
		local rState = self:getTaskState(r)
		if lState == rState then
			return l < r
		else
			return lState < rState
		end
	end)
	return taskList
end
function activity_9001571_Ctrl:getTaskState(taskID)
	return self:isTaskClaimed(taskID) and gBtnTargetStatusDef.GOT or self:isTaskFinished(taskID) and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO
end
function activity_9001571_Ctrl:isTaskClaimed(taskID)
	local questComponent = self:getQuestComponent()
	if questComponent then
		return questComponent:isTaskClaimed(taskID)
	end
	return false
end
function activity_9001571_Ctrl:isTaskFinished(taskID)
	local questComponent = self:getQuestComponent()
	if questComponent then
		return questComponent:isTaskFinished(taskID)
	end
	return false
end
function activity_9001571_Ctrl:getTaskProgress(taskID)
	local questComponent = self:getQuestComponent()
	if questComponent then
		return questComponent:getTaskProgress(taskID)
	end
	return 0
end
function activity_9001571_Ctrl:getQuestComponent(...)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local questComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	return questComponent
end
function activity_9001571_Ctrl:getTaskStatusAndNum()
	local questComponent = self:getQuestComponent()
	local redNum = 0
	if questComponent then
		local _
		_, redNum = questComponent:getReceiveStatusAndNumByQuestList(self.initData.questList)
	end
	return redNum
end
function activity_9001571_Ctrl:getClassType()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
function activity_9001571_Ctrl:getLvRewardStatusAndNum()
	local num = 0
	local group = self:getGroupID()
	if 0 < group then
		for i, lvInfo in ipairs(activity_9001571_Read.getLvAwardList(self:getClassType(), group)) do
			local lv = lvInfo.Lv
			if lv then
				print("self:getRewardState(1,lv)", self:getRewardState(1, lv), self:getRewardState(2, lv), lv)
				if self:getRewardState(1, lv) == gBtnTargetStatusDef.GET then
					num = num + 1
				end
				if self:getRewardState(2, lv) == gBtnTargetStatusDef.GET then
					num = num + 1
				end
			end
		end
	end
	return num
end
function activity_9001571_Ctrl:getReceiveStatusAndNum(activityID)
	local redNum = self:getTaskStatusAndNum() or 0
	redNum = redNum + self:getLvRewardStatusAndNum()
	return 0 < redNum, redNum
end
function activity_9001571_Ctrl:getCanChangeReward(...)
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("BACKBATTLE_OPTIONAL_TOGGLED", 1)
	return value == 0
end
return activity_9001571_Ctrl
