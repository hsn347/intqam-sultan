local eventQuestRead = include("eventQuestRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local inheritGiftCtrl = class("inheritGiftCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function inheritGiftCtrl:ctor(properties)
	self.activityID = gActivityTimeActivityID.WEALTH_ACTIVITY
	inheritGiftCtrl.super.ctor(self, properties)
	self:resetData()
end
function inheritGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WEALTH_INHERIT_MODULE, gCmd.REQ_WEALTH_INHERIT_INIT, handler(self, self.reqWealthInheritInitRsp))
	msgCtrl.register(gCmd.CMD_WEALTH_INHERIT_MODULE, gCmd.REQ_WEALTH_INHERIT_RECEIVE, handler(self, self.reqWealthInheritRewardRsp))
	msgCtrl.register(gCmd.CMD_WEALTH_INHERIT_MODULE, gCmd.REQ_WEALTH_INHERIT_EXCHANGE, handler(self, self.reqWealthInheritExchangeRsp))
	self:registerNotify()
	inheritGiftCtrl:reqWealthInheritInit()
end
function inheritGiftCtrl:Logout()
	inheritGiftCtrl.super.Logout(self)
	self:resetData()
end
function inheritGiftCtrl:resetData()
	self.dollor = 0
	self.stage = 0
	self.type = 1
	self.exchangeRecord, _UPVALUE0_, self.taskRewardRecord, _UPVALUE0_, self.taskFinishProcess, _UPVALUE0_, self.inherit = nil, nil, nil, nil, nil, nil, 0
	self.updateTime = 0
	self.createTime = 0
end
function inheritGiftCtrl:setData(data)
	dump(data, "inheritGiftCtrl:setData")
	self:resetData()
	self.dollor = data.dollor
	self.stage = data.stage
	self.type = data.type
	self.inherit = data.inherit
	dump(self.inherit, "wjfkljsjlfjsldfjldf")
	for i, v in pairs(data.taskFinishProcess) do
		self.taskFinishProcess[i] = v
	end
	for i, v in pairs(data.taskRewardRecord) do
		self.taskRewardRecord[i] = v
	end
	self:createQuestComponent(self.taskFinishProcess, self.taskRewardRecord)
	for i, v in pairs(data.exchangeRecord) do
		self.exchangeRecord[i] = v
	end
	self.updateTime = data.updateTime
	self.createTime = data.createTime
end
function inheritGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WEALTH_INHERIT, handler(self, self.notifyHandler))
end
function inheritGiftCtrl:notifyHandler(event)
	dump(event.data, "inheritGiftCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self:setData(v.initData)
		_ENV = self
		self.msg = "MESSAGE_WEALTH_INHERIT_REFRESH"
		self.subMsg = "initData"
		SoraDSendMessage(self)
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_NEWS_ERVER_BACK_RED_POINT"
	SoraDSendMessage(ipairs(event.data))
end
function inheritGiftCtrl:reqWealthInheritInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WEALTH_INHERIT_MODULE, gCmd.REQ_WEALTH_INHERIT_INIT, nil)
end
function inheritGiftCtrl:reqWealthInheritReward(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_WEALTH_INHERIT_MODULE, gCmd.REQ_WEALTH_INHERIT_RECEIVE, nil)
end
function inheritGiftCtrl:reqWealthInheritExchange(exchangeID)
	serverproxy = nil
	;(nil).rechargeID = exchangeID
	serverproxy:Request(gCmd.CMD_WEALTH_INHERIT_MODULE, gCmd.REQ_WEALTH_INHERIT_EXCHANGE, nil)
end
function inheritGiftCtrl:reqWealthInheritInitRsp(content)
	dump(content, "inheritGiftCtrl:reqWealthInheritInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		newStartMainCtrl:setActInitFlag(self.activityID)
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_WEALTH_INHERIT_REFRESH"
		self.subMsg = "initData"
		SoraDSendMessage(self)
	end
end
function inheritGiftCtrl:reqWealthInheritRewardRsp(content)
	dump(content, "inheritGiftCtrl:reqWealthInheritRewardRsp(content)", 10)
	_ENV = dump
	local _ENV, dump.err, myContent = content.err, content.err, dump
	content.err.questID = content.data.taskID
	content.err.reward = content.rspdata and content.rspdata.reward
	myContent.rspdata, content.err.activityID = content.err, self.activityID
	self.questComponent:reqRuestClaimRewardRsp(myContent)
end
function inheritGiftCtrl:reqWealthInheritExchangeRsp(content)
	dump(content, "inheritGiftCtrl:reqWealthInheritExchangeRsp", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_WEALTH_INHERIT_REFRESH"
		self.subMsg = "exchange"
		self.rid = content.data.rechargeID
		SoraDSendMessage(self)
		self:popRechargeSuccessView(content)
		return
	end
	if content.err == gErrDef.Err_WEALTH_INHERIT_NOT_ENOUGH_LV then
		SoraDShowMsgTip(i18n("remains_text_20"))
		return
	end
	if content.err == gErrDef.Err_WEALTH_INHERIT_NOT_ENOUGH_BUY_COUNT then
		SoraDShowMsgTip(i18n("common_text_4570"))
		return
	end
	if content.err == gErrDef.Err_WEALTH_INHERIT_NOT_ENOUGH_COUNT then
		SoraDShowMsgTip(i18n("notice_0120"))
		return
	end
	if content.err == gErrDef.Err_WEALTH_INHERIT_ILLEGAL_PARAMS then
		SoraDShowMsgTip(i18n("notice_0026"))
		return
	end
	if content.err == gErrDef.Err_WEALTH_INHERIT_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return
	end
end
function inheritGiftCtrl:getInheritWealthOwn()
	return self.dollor
end
function inheritGiftCtrl:getInheritStage()
	return self.stage
end
function inheritGiftCtrl:getInheritGroupType()
	return self.type
end
function inheritGiftCtrl:getInheritPoint()
	return self.inherit
end
function inheritGiftCtrl:getInheritExchangeTimesByRecgargeID(rechargeID)
	dump(self.exchangeRecord, "fsklfkld456456")
	dump(rechargeID, "fsklfkldkf24242")
	dump(self.exchangeRecord[tostring(rechargeID)], "fsklfkldkfldkfldkfld")
	return self.exchangeRecord[tostring(rechargeID)] or 0
end
function inheritGiftCtrl:createQuestComponent(taskFinishProcess, taskRewardRecord)
	local activityTaskComponent = include("activityTaskComponent")
	if not self.questComponent then
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
	end
	local _ENV, taskDone = self.questComponent.setActivityID, self.questComponent.setActivityID
	local _ENV, taskProgress = self.questComponent, self.questComponent
	for i, v in pairs(taskFinishProcess) do
		local questInfo = eventQuestRead.getTaskConfig(tonumber(i))
		if v >= questInfo.aim then
			taskDone[i] = 1
		end
		taskProgress[i] = v
	end
	_ENV = (for generator)
	pairs(taskFinishProcess).claimedQuest = taskRewardRecord
	pairs(taskFinishProcess).finishedQuest = taskDone
	local pairs(taskFinishProcess).questProgress, questData = taskProgress, pairs(taskFinishProcess)
	dump(questData, "inheritGiftCtrl:createQuestComponent456464565")
	self.questComponent:setQuestData(questData)
end
function inheritGiftCtrl:getTaskList(quests)
	local _ENV, ret
	for _, taskID in pairs(quests) do
		local questInfo = eventQuestRead.getTaskConfig(taskID)
		dump(questInfo, "inheritGiftCtrl:getTaskList")
		if not self.questComponent or not self.questComponent:getQuestData() then
			local _ENV, serverData = self.questComponent:getQuestData(), self.questComponent:getQuestData()
		end
		local taskStatus = gBtnTargetStatusDef.GO
		local progress = 0
		if serverData then
			if serverData.questProgress then
				progress = serverData.questProgress[tostring(taskID)] or 0
				dump(progress, "fsfjksdfjlsdjfkdjfdj")
			end
			if serverData.claimedQuest and serverData.claimedQuest[tostring(taskID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.claimedQuest and serverData.finishedQuest[tostring(taskID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		_ENV = taskID
		taskID.taskID = taskID
		taskID.taskStatus = taskStatus
		taskID.taskDes = questInfo.taskDes
		taskID.progress = progress
		taskID.aim = questInfo.aim
		taskID.guideId = questInfo.guideId
		taskID.isAct = questInfo.isAct
		taskID.award = eventQuestRead.getReward(taskID)
		taskID.statsRuleID = questInfo.statsRuleID
		table.insert(ret, taskID)
	end
	table.sort(ret, function(l, r)
		if l.taskStatus == r.taskStatus then
			return l.taskID < r.taskID
		else
			return l.taskStatus < r.taskStatus
		end
	end)
	return ret
end
function inheritGiftCtrl:getReceiveStatusAndNum()
	if self.questComponent then
		return self.questComponent:getReceiveStatusAndNum()
	else
		return false, 0
	end
end
function inheritGiftCtrl:popRechargeSuccessView(event)
	local rechargePopMsg = function(goods, mid, rid)
		if goods and next(goods) ~= nil then
			_ENV = nil
			;(nil).itemList = goods
			;(nil).mailID = mid
			;(nil).rid = rid
			uiManager:show("gemGoodsBuyGiftSuccess", nil)
		end
	end
	local _rid = event.data.exchangeID
	local goods = event.rspdata.reward
	local mailID = event.rspdata.mailid
	rechargePopMsg(goods, mailID, _rid)
end
return inheritGiftCtrl
