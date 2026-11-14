local GameModule = include("GameModule")
local planThoroughCtrl = class("planThoroughCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local planThoroughRead = include("planThoroughRead")
local timerList = gModuleMgr.getObject("timerList")
_ENV = "timerList"
;("timerList").noClaim = 1
;("timerList").noReach = 2
local ("timerList").claimed, giftStatus = 3, "timerList"
function planThoroughCtrl:ctor(properties)
	planThoroughCtrl.super.ctor(self, properties)
	self.round = 1
	self.activityID = gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY
	self.activityStatu = 1
	self.activityBegintime = 0
	self.activityEndtime = 0
	self:resetData()
end
function planThoroughCtrl:Logout()
	planThoroughCtrl.super.Logout(self)
end
function planThoroughCtrl:resetData()
end
function planThoroughCtrl:initClientData(data)
	dump(data, "planThoroughCtrl:initClientData")
	self.activityStatu = data and data.state or 1
	self.activityBegintime = data and data.begintime or 0
	self.activityEndtime = data and data.endtime or 0
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:sendReqInitDataMsg()
		self:registerNotify()
	end
end
function planThoroughCtrl:getActivityStatus()
	local curtime = serviceFunctions.systemTime()
	return self.activityStatu
end
function planThoroughCtrl:getCloseTime()
	if self.activityEndtime - serviceFunctions.systemTime() > 0 then
		return self.activityEndtime - serviceFunctions.systemTime()
	end
	return 0
end
function planThoroughCtrl:getReceiveStatusAndNum()
	print("planThoroughCtrl:getReceiveStatusAndNum")
	local show, num = false, 0
	if self.questComponent then
		show, num = self.questComponent:getReceiveStatusAndNum()
	end
	return show, num
end
function planThoroughCtrl:EnterGame()
	self:initLocalData()
	msgCtrl.register(gCmd.CMD_PLAN_THOROUGH_MODULE, gCmd.REQ_PLAN_THOROUGH_INIT, handler(self, self.getInitData))
	msgCtrl.register(gCmd.CMD_PLAN_THOROUGH_MODULE, gCmd.REQ_PLAN_THOROUGH_REWARD, handler(self, self.getReward))
end
function planThoroughCtrl:initLocalData()
end
function planThoroughCtrl:getQuestData()
	if self.questComponent then
		return self.questComponent:getQuestData()
	end
	_UPVALUE0_ = self.questComponent.getQuestData
	return self.questComponent.getQuestData
end
function planThoroughCtrl:getTabStatusAndNum(subType)
	local queueList = planThoroughRead.getDailyQuestList(subType)
	if not self.questComponent or not self.questComponent:getQuestData() then
		return false
	end
	local data = self.questComponent:getQuestData()
	local num = 0
	for _, v in ipairs(queueList) do
		if data.finishedQuest[tostring(v)] and not data.claimedQuest[tostring(v)] then
			num = num + 1
		end
	end
	return 0 < num, num
end
function planThoroughCtrl:addQuestComponent(activityID, questData)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		local questComponent = activityTaskComponent.new()
		questComponent:setActivityID(activityID)
		questComponent:setQuestData(questData)
		self.questComponent = questComponent
	end
end
function planThoroughCtrl:getInitData(content)
	dump(content, "统筹兼顾初始化数据")
	print(content.err)
	if content.err == gErrDef.Err_None then
		self.round = content.rspdata.round
		self:addQuestComponent(self.activityID, content.rspdata.quest)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_PLANTHOROUGH_INIT"
		SoraDSendMessage(self)
	elseif content.err == gErrDef.Err_NEW_RECHARGE_NOT_OPEN then
	end
	dump(self.claimedQuest)
	dump(self.finishedQuest)
	dump(self.questProgress)
end
function planThoroughCtrl:getReward(data)
	dump(data, "奖励")
	print(data.err)
	if data.err == gErrDef.Err_None then
		self.chestCount = data.rspdata.chestCount
		local questID = data.data.questId
		local rewarddata = data.rspdata.reward
		if self.questComponent then
			local data = self.questComponent:getQuestData()
			data.claimedQuest[tostring(questID)] = 1
		end
		_ENV = data.claimedQuest
		data.claimedQuest.msg = "MESSAGE_PLANTHOROUGH_CLAIM_REWARD"
		data.claimedQuest.reward = rewarddata
		SoraDSendMessage(data.claimedQuest)
		_ENV = data.claimedQuest
		data.claimedQuest.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		data.claimedQuest.eventID = self.activityID
		SoraDSendMessage(data.claimedQuest)
		_ENV = data.claimedQuest
		data.claimedQuest.msg = "MESSAGE_PLANTHOROUGH_INIT"
		SoraDSendMessage(data.claimedQuest)
	else
	end
end
function planThoroughCtrl:registerNotify()
	print("统筹兼顾registerNotify")
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PLAN_THOROUGH, handler(self, self.notifyHandler))
end
function planThoroughCtrl:notifyHandler(event)
	dump(event, "统筹兼顾数据变化")
	dump(event.data[1])
	for k, v in pairs(event.data[1]) do
		if v.activityID == self.activityID and self.questComponent ~= nil then
			self.questComponent:onNotify_progressUpdate(v)
		end
	end
	_ENV = pairs(event.data[1])
	pairs(event.data[1]).msg = "MESSAGE_PLANTHOROUGH_UPDATA"
	SoraDSendMessage(pairs(event.data[1]))
end
function planThoroughCtrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_PLAN_THOROUGH_MODULE, gCmd.REQ_PLAN_THOROUGH_INIT)
end
function planThoroughCtrl:reqReward(id)
	serverproxy = nil
	local (nil).questId, data = id, nil
	serverproxy:Request(gCmd.CMD_PLAN_THOROUGH_MODULE, gCmd.REQ_PLAN_THOROUGH_REWARD, data)
end
return planThoroughCtrl
