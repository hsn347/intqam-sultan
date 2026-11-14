local GameModule = include("GameModule")
local trainPowerCtrl = class("trainPowerCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local newFeedbackWeekRead = include("newFeedbackWeekRead")
_ENV = "newFeedbackWeekRead"
;("newFeedbackWeekRead").noClaim = 1
;("newFeedbackWeekRead").noReach = 2
local ("newFeedbackWeekRead").claimed, giftStatus = 3, "newFeedbackWeekRead"
function trainPowerCtrl:ctor(properties)
	trainPowerCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.TRAIN_POWER_ACTIVITY
	self:resetData()
end
function trainPowerCtrl:Logout()
	trainPowerCtrl.super.Logout(self)
end
function trainPowerCtrl:resetData()
	self.taskList, _UPVALUE0_, self.questComponentMap, _UPVALUE0_ = nil, nil, nil, nil
	self.canGetNum = 0
end
function trainPowerCtrl:EnterGame()
	print("newFeedbackWeekCtrl进入游戏")
	self:initLocalData()
	msgCtrl.register(gCmd.CMD_TRAIN_POWER_MODULE, gCmd.TRAIN_POWER_INIT, handler(self, self.getInitData))
	msgCtrl.register(gCmd.CMD_TRAIN_POWER_MODULE, gCmd.TRAIN_POWER_REWARD, handler(self, self.getClaimReward))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.showViewChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_END", function(...)
		_ENV = nil
		;(nil).byUID = true
		local flag = SoraDConfigGet("Game:trainPowerView:first~bool", nil)
		local isGuide = SoraDIsGameGuide()
		print("新手引导结束,是否可以弹窗", clientEventMgr.judgeIsOpen(self.activityID), flag, isGuide)
		if clientEventMgr.judgeIsOpen(self.activityID) and flag then
			_ENV = flag
			flag.byUID = true
			SoraDConfigSet("Game:trainPowerView:first~bool", false, flag)
			SoraDAddPopupWindow(function()
				SoraDCreatePanel("trainPowerView"):show()
			end, uiDequeTypeTab.BUILDUNLOCK)
		end
	end)
end
function trainPowerCtrl:showViewChange(target, data)
	if data.viewType == VIEW_TYPE_CITY then
		_ENV = nil
		;(nil).byUID = true
		local flag = SoraDConfigGet("Game:trainPowerView:first~bool", nil)
		local isGuide = SoraDIsGameGuide()
		local isFromLogin = data.isFromLogin or false
		print("切回主城判断是否首次弹窗", clientEventMgr.judgeIsOpen(self.activityID), flag, isGuide, isFromLogin)
		if clientEventMgr.judgeIsOpen(self.activityID) and flag and isGuide == nil and isFromLogin == false then
			_ENV = flag
			flag.byUID = true
			SoraDConfigSet("Game:trainPowerView:first~bool", false, flag)
			SoraDAddPopupWindow(function()
				SoraDCreatePanel("trainPowerView"):show()
			end, uiDequeTypeTab.BUILDUNLOCK)
		end
	end
end
function trainPowerCtrl:initLocalData()
end
function trainPowerCtrl:getQuestData()
	return self:getSortList(self.activityID)
end
function trainPowerCtrl:getTaskList()
	return self.taskList
end
function trainPowerCtrl:getTaskData()
	return self.localTaskConfig
end
function trainPowerCtrl:getNextResetTime()
	return self.nextResetTime
end
function trainPowerCtrl:getReceiveStatusAndNum()
	local bAward = false
	self:getSortList(self.activityID)
	bAward = self.canGetNum > 0 and true or false
	print("trainPowerCtrl:getReceiveStatusAndNum()", self.canGetNum)
	return bAward, self.canGetNum
end
function trainPowerCtrl:initClientData(data)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:reqInitData()
		self:registerNotify()
	end
end
function trainPowerCtrl:reqInitData()
	print("trainPowerCtrl请求")
	serverproxy:Request(gCmd.CMD_TRAIN_POWER_MODULE, gCmd.TRAIN_POWER_INIT)
end
function trainPowerCtrl:reqClaimReward(taskID)
	print("请求领取奖励" .. taskID)
	_ENV = print
	local print.questID, data = taskID, print
	serverproxy:Request(gCmd.CMD_TRAIN_POWER_MODULE, gCmd.TRAIN_POWER_REWARD, data)
end
function trainPowerCtrl:registerNotify()
	print("注册服务器主动通知registerNotify")
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.TRAIN_POWER, handler(self, self.notifyHandler))
	self.notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyDone))
end
function trainPowerCtrl:notifyHandler(event)
	dump(event, "养精蓄锐数据变化")
	dump(event, "")
	if self.questComponentMap[self.activityID] then
		self.questComponentMap[self.activityID]:setQuestData(event.data[1].questData)
	else
		self:addQuestComponent(event.data[1].questData)
	end
	self.taskList = event.data[1].taskList
	dump(self.taskList)
	_ENV = self.taskList
	self.taskList.msg = "MESSAGE_TRAIN_POWER_NOTIFY"
	SoraDSendMessage(self.taskList)
	_ENV = self.taskList
	self.taskList.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.taskList.eventID = self.activityID
	SoraDSendMessage(self.taskList)
end
function trainPowerCtrl:notifyDone(content)
	dump("养精蓄锐done", content)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		local activityID = notifyMsg.activityID
		if tonumber(activityID) == self.activityID then
			dump(notifyMsg, "蓄锐done")
			self:reqInitData()
		end
	end
end
function trainPowerCtrl:getInitData(content)
	dump(content, "养精蓄锐初始化数据")
	print(content.err)
	if content.err == gErrDef.Err_None then
		self:addQuestComponent(content.rspdata.questData)
		self.taskList = content.rspdata.taskList
		_ENV = self
		self.msg = "MESSAGE_TRAIN_POWER_INIT"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
	else
		_ENV = self
		self.msg = "MESSAGE_TRAIN_POWER_ERR"
		SoraDSendMessage(self)
	end
end
function trainPowerCtrl:getClaimReward(data)
	dump(data, "养精蓄锐领取奖励")
	print(data.err)
	if data.err == gErrDef.Err_None then
		local rewarddata = data.rspdata.reward
		_ENV = "养精蓄锐领取奖励"
		;("养精蓄锐领取奖励").msg = "MESSAGE_TRAIN_POWER_CLAIM_REWARD"
		;("养精蓄锐领取奖励").reward = rewarddata
		SoraDSendMessage("养精蓄锐领取奖励")
	end
end
function trainPowerCtrl:addQuestComponent(questData)
	local activityTaskComponent = include("activityTaskComponent")
	local questComponent = activityTaskComponent.new()
	questComponent:setActivityID(self.activityID)
	questComponent:setQuestData(questData)
	self.questComponentMap[self.activityID] = questComponent
	return questComponent
end
function trainPowerCtrl:getSortList(activityID)
	local _ENV, ret
	local GetCount = 0
	local eventQuestRead = include("eventQuestRead")
	local serverData = self.questComponentMap[activityID] and self.questComponentMap[activityID]:getQuestData()
	if not self.taskList then
		local _ENV, queueList = self.taskList, self.taskList
	end
	for _, questID in ipairs(queueList) do
		local cfgItem = eventQuestRead.questconfig[tonumber(questID)]
		local count = 0
		local taskStatus = gBtnTargetStatusDef.GO
		if serverData and cfgItem then
			if serverData.questProgress then
				count = serverData.questProgress[tostring(questID)] or 0
			end
			if serverData.claimedQuest and serverData.claimedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.claimedQuest and serverData.finishedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GET
				GetCount = GetCount + 1
			end
		end
		_ENV = questID
		questID.activityID = activityID
		questID.taskID = questID
		questID.count = count
		questID.award = cfgItem.reward
		questID.total = cfgItem.aim
		questID.taskStatus = taskStatus
		questID.taskDes = cfgItem.taskDes
		questID.guideId = cfgItem.guideId
		table.insert(ret, questID)
	end
	self.canGetNum = GetCount
	return ret
end
return trainPowerCtrl
