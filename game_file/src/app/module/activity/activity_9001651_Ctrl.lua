local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001651_Ctrl = class("activity_9001651_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001651_Ctrl:ctor(properties)
	activity_9001651_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY
	self.exchangeID = gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY
	self:resetData()
end
function activity_9001651_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_FURNACE_MODULE, gCmd.REQ_NEBULA_FURNACE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_FURNACE_MODULE, gCmd.REQ_NEBULA_FURNACE_LOTTERY, handler(self, self.reqLotteryRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_FURNACE_MODULE, gCmd.REQ_NEBULA_FURNACE_QUEST_REWARD, handler(self, self.reqQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_FURNACE_MODULE, gCmd.REQ_NEBULA_FURNACE_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	self:registerNotify()
end
function activity_9001651_Ctrl:initClientData(data)
end
function activity_9001651_Ctrl:Logout()
	activity_9001651_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001651_Ctrl:resetData()
	self.stageReward, _UPVALUE0_, self.questData, _UPVALUE0_, self.lotteryTimes = nil, nil, nil, nil, 0
	self.questComponent = nil
end
function activity_9001651_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_FURNACE, handler(self, self.notifyHandler))
end
function activity_9001651_Ctrl:notifyHandler(event)
	dump(event, "activity_9001642_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "refreshData" then
			self.lotteryTimes = v.notifyData.lotteryTimes
			self.questData = v.notifyData.questData
			self:createQuestComponent(self.questData)
			self.stageReward = v.notifyData.stageReward
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001651_UPDATE"
			SoraDSendMessage(self)
		end
	end
end
function activity_9001651_Ctrl:getReceiveStatusAndNum()
	local num = self:getExchangeNum() + self:getTaskRedNum() + self:getStageRedNum()
	return 0 < num, num
end
function activity_9001651_Ctrl:getTaskRedNum()
	local num = 0
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local taskIDList = include("activity_9001651_Read").getTaslConfig(SoraDGetActivityClassType(self.activityID))
	local taskList = activityTaskComponentCtrl:getTaskList(self.activityID, taskIDList)
	for k, v in ipairs(taskList) do
		if self:isTaskFinished(v.taskID) and not self:isTaskClaimed(v.taskID) then
			num = num + 1
		end
	end
	return num
end
function activity_9001651_Ctrl:getStageRedNum()
	local num = 0
	local stageConfig = include("activity_9001651_Read").getStageConfig(SoraDGetActivityClassType(self.activityID))
	for k, v in ipairs(stageConfig) do
		local status = self:getStageBoxStatues(v.accumulate)
		if status == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001651_Ctrl:getExchangeNum()
	local num = 0
	if clientEventMgr.judgeIsOpen(self.exchangeID) then
		local shopList = SoraDGetCtrl("activityExchangeMallCtrl"):getConfigByActivityID(self.exchangeID)
		for k, v in ipairs(shopList) do
			if v.remindStatus == 1 and v.curExchangeNum < v.limitnum then
				local itemEnough1 = SoraDGetCtrl("backpackCtrl"):getItemCount(v.exchangeitem) >= v.exchangenum
				local itemEnough2 = true
				if v.exchangeitem2 and v.exchangenum2 then
					itemEnough2 = SoraDGetCtrl("backpackCtrl"):getItemCount(v.exchangeitem2) >= v.exchangenum2
				end
				if itemEnough1 and itemEnough2 then
					num = num + 1
				end
			end
		end
	end
	return num
end
function activity_9001651_Ctrl:createQuestComponent(questData)
	dump(questData, "activity_9001651_Ctrl:createQuestComponent====", 10)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
		self.questComponent:setQuestData(questData)
	end
end
function activity_9001651_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_FURNACE_MODULE, gCmd.REQ_NEBULA_FURNACE_INIT, nil)
end
function activity_9001651_Ctrl:sendLotteryMsg(times)
	serverproxy = nil
	;(nil).times = times
	serverproxy:Request(gCmd.CMD_NEBULA_FURNACE_MODULE, gCmd.REQ_NEBULA_FURNACE_LOTTERY, nil)
end
function activity_9001651_Ctrl:sendQuestRewardMsg(questId)
	serverproxy = nil
	;(nil).questId = questId
	serverproxy:Request(gCmd.CMD_NEBULA_FURNACE_MODULE, gCmd.REQ_NEBULA_FURNACE_QUEST_REWARD, nil)
end
function activity_9001651_Ctrl:sendStageRewardMsg(times)
	serverproxy = nil
	;(nil).times = times
	serverproxy:Request(gCmd.CMD_NEBULA_FURNACE_MODULE, gCmd.REQ_NEBULA_FURNACE_STAGE_REWARD, nil)
end
function activity_9001651_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001651_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lotteryTimes = content.rspdata.lotteryTimes
		self.questData = content.rspdata.questData
		self:createQuestComponent(self.questData)
		self.stageReward = content.rspdata.stageReward
	end
	_ENV = self
	self.msg = "MESSAGE_ACTIVITY_9001651_UPDATE"
	SoraDSendMessage(self)
end
function activity_9001651_Ctrl:reqLotteryRsp(content)
	dump(content, "activity_9001651_Ctrl:reqLotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lotteryTimes = content.rspdata.initData.lotteryTimes
		self.questData = content.rspdata.initData.questData
		self.stageReward = content.rspdata.initData.stageReward
		local rewards = content.rspdata.rewards
		local rewardsList = content.rspdata.rewardsList
		if content.data.times == 1 then
			SoraDMailGainItems(rewards, true)
		else
			local _ENV, rList = SoraDMailGainItems, SoraDMailGainItems
			for index, list in ipairs(rewardsList) do
				for k, v in ipairs(list) do
					table.insert(rList, v)
				end
			end
			_ENV = nil
			;(nil).rewards = rList
			uiManager:show("CommonCongratulations", nil)
		end
	end
	_ENV = content.rspdata.rewardsList
	content.rspdata.rewardsList.msg = "MESSAGE_ACTIVITY_9001651_UPDATE"
	SoraDSendMessage(content.rspdata.rewardsList)
end
function activity_9001651_Ctrl:reqQuestRewardRsp(content)
	dump(content, "activity_9001651_Ctrl:reqQuestRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.questData.claimedQuest[tostring(content.data.questId)] = 1
		self:createQuestComponent(self.questData)
		SoraDMailGainItems(content.rspdata, true)
	end
	_ENV = content.rspdata
	content.rspdata.msg = "MESSAGE_ACTIVITY_9001651_UPDATE"
	SoraDSendMessage(content.rspdata)
end
function activity_9001651_Ctrl:reqStageRewardRsp(content)
	dump(content, "activity_9001651_Ctrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lotteryTimes = content.rspdata.initData.lotteryTimes
		self.questData = content.rspdata.initData.questData
		self.stageReward = content.rspdata.initData.stageReward
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_9001651_UPDATE"
	SoraDSendMessage(SoraDMailGainItems)
end
function activity_9001651_Ctrl:getLotteryTimes()
	return self.lotteryTimes
end
function activity_9001651_Ctrl:getStageBoxStatues(num)
	local state = self.stageReward[tostring(num)] and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and num <= self:getLotteryTimes() then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function activity_9001651_Ctrl:isTaskClaimed(taskID)
	if self.questComponent then
		return self.questComponent:isTaskClaimed(taskID)
	end
	return false
end
function activity_9001651_Ctrl:isTaskFinished(taskID)
	if self.questComponent then
		return self.questComponent:isTaskFinished(taskID)
	end
	return false
end
function activity_9001651_Ctrl:getTaskProgress(taskID)
	if self.questComponent then
		return self.questComponent:getTaskProgress(taskID)
	end
	return 0
end
return activity_9001651_Ctrl
