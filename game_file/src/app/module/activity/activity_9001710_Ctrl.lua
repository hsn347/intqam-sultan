local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001710_Ctrl = class("activity_9001710_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001710_Read = include("activity_9001710_Read")
function activity_9001710_Ctrl:ctor(properties)
	activity_9001710_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY
	self:resetData()
end
function activity_9001710_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CRESCENT_ORDER_MODULE, gCmd.REQ_CRESCENT_ORDER_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_ORDER_MODULE, gCmd.REQ_CRESCENT_QUEST_REWARD, handler(self, self.reqQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_ORDER_MODULE, gCmd.REQ_CRESCENT_GET_REWARD, handler(self, self.reqGetRewardRsp))
	self:registerNotify()
end
function activity_9001710_Ctrl:Logout()
	activity_9001710_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001710_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).exp = 0
	;(nil).normalRewardLv = 0
	;(nil).adwanceRewardLv = 0
	self.defaultData, (nil).questData, _UPVALUE0_, (nil).isAdvanceRewardUnlock = nil, nil, nil, false
end
function activity_9001710_Ctrl:initClientData(data)
	dump(data, "activity_9001710_Ctrl:initClientData===")
end
function activity_9001710_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CRESCENT_ORDER, handler(self, self.notifyHandler))
end
function activity_9001710_Ctrl:notifyHandler(event)
	dump(event, "activity_9001710_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		local notifyType = v.notifyType
		if notifyType == "refreshQuestData" then
			self.defaultData = notifyData
		elseif notifyType == "refreshData" then
			self.defaultData = notifyData
		elseif notifyType == "buyGift" then
			self.defaultData = notifyData.initData
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001710_BUYGIFT"
			SoraDSendMessage(nil)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001710_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001710_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRESCENT_ORDER_MODULE, gCmd.REQ_CRESCENT_ORDER_INIT, nil)
end
function activity_9001710_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001710_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001710_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001710_Ctrl:reqQuestReward(questId)
	serverproxy = nil
	;(nil).questId = questId
	serverproxy:Request(gCmd.CMD_CRESCENT_ORDER_MODULE, gCmd.REQ_CRESCENT_QUEST_REWARD, nil)
end
function activity_9001710_Ctrl:reqQuestRewardRsp(content)
	dump(content, "activity_9001710_Ctrl:reqQuestRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001710_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001710_Ctrl:reqGetReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRESCENT_ORDER_MODULE, gCmd.REQ_CRESCENT_GET_REWARD, nil)
end
function activity_9001710_Ctrl:reqGetRewardRsp(content)
	dump(content, "activity_9001710_Ctrl:reqGetRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001710_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001710_Ctrl:getReceiveStatusAndNum()
	local num = self:getQuestNum()
	if self:getCrescentNum() > 0 then
		num = num + 1
	end
	return 0 < num, num
end
function activity_9001710_Ctrl:getQuestNum()
	local num = 0
	if not self.defaultData.questData.finishedQuest then
		local _ENV, finishedQuest = self.defaultData.questData.finishedQuest, self.defaultData.questData.finishedQuest
	end
	for questId, v in pairs(finishedQuest) do
		if not self:isTaskClaimed(questId) then
			num = num + 1
		end
	end
	return num
end
function activity_9001710_Ctrl:isTaskClaimed(taskID)
	if not self.defaultData.questData.claimedQuest then
		local _ENV, claimedQuest = self.defaultData.questData.claimedQuest, self.defaultData.questData.claimedQuest
	end
	return claimedQuest[tostring(taskID)] and true or false
end
function activity_9001710_Ctrl:isTaskFinished(taskID)
	if not self.defaultData.questData.finishedQuest then
		local _ENV, finishedQuest = self.defaultData.questData.finishedQuest, self.defaultData.questData.finishedQuest
	end
	return finishedQuest[tostring(taskID)] and true or false
end
function activity_9001710_Ctrl:getTaskProgress(taskID)
	if not self.defaultData.questData.questProgress then
		local _ENV, questProgress = self.defaultData.questData.questProgress, self.defaultData.questData.questProgress
	end
	return questProgress[tostring(taskID)] or 0
end
function activity_9001710_Ctrl:getCrescentNum()
	local num = 0
	local cfg = activity_9001710_Read.getRewardCfg()
	local curlv = self:getLv()
	for k, v in ipairs(cfg) do
		if curlv >= v.lv and self.defaultData.normalRewardLv < v.lv then
			num = num + 1
		end
		if self:isAdvUnlock() and curlv >= v.lv and self.defaultData.adwanceRewardLv < v.lv then
			num = num + 1
		end
	end
	return num
end
function activity_9001710_Ctrl:getLv()
	return activity_9001710_Read:getLvByExp(self.defaultData.exp)
end
function activity_9001710_Ctrl:isAdvUnlock()
	return self.defaultData.isAdvanceRewardUnlock
end
function activity_9001710_Ctrl:getLvStatus(lv, isAdv)
	local status = 0
	local curlv = self:getLv()
	if isAdv then
		if lv <= self.defaultData.adwanceRewardLv then
			status = 3
		elseif self:isAdvUnlock() then
			status = lv <= curlv and 1 or 2
		else
			status = 0
		end
	elseif lv <= self.defaultData.normalRewardLv then
		status = 3
	else
		status = lv <= curlv and 1 or 2
	end
	return status
end
function activity_9001710_Ctrl:getTaskState(taskID)
	return self:isTaskClaimed(taskID) and gBtnTargetStatusDef.GOT or self:isTaskFinished(taskID) and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO
end
function activity_9001710_Ctrl:getTaskList()
	local cfg = activity_9001710_Read.getQuestCfg()
	local activity_9001710_Read, taskList
	for k, v in ipairs(cfg) do
		for i, taskID in ipairs(v.questID) do
			if not self:isTaskClaimed(taskID) then
				table.insert(taskList, taskID)
				break
			elseif i == #v.questID then
				table.insert(taskList, taskID)
				break
			end
		end
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
function activity_9001710_Ctrl:getBuffVale(effectType, bid)
	if not self:isAdvUnlock() then
		return 0
	end
	local cfg = activity_9001710_Read.getBuffCfg()
	local val = 0
	local quality, lv, starLv = SoraDGetBuildQuality()
	local castleStarLv = SoraDGetBuildStarLv(bid)
	for k, v in ipairs(cfg) do
		if v.lv[1] == 1 then
			if castleStarLv >= v.lv[2] and castleStarLv <= v.lv[3] and v.buff[1] == effectType then
				val = v.buff[2]
				break
			end
		elseif v.lv[1] == 2 and starLv >= v.lv[2] and starLv <= v.lv[3] and v.buff[1] == effectType then
			val = v.buff[2]
			break
		end
	end
	return val
end
function activity_9001710_Ctrl:isBuffEffect(buildType, bid)
	local cfg = activity_9001710_Read.getBuffCfg()
	for k, v in ipairs(cfg) do
		if v.buildType == buildType and self:getBuffVale(v.buff[1], bid) > 0 then
			return true
		end
	end
	return false
end
return activity_9001710_Ctrl
