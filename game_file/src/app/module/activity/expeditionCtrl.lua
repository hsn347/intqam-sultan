local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local expeditionCtrl = class("expeditionCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function expeditionCtrl:ctor(properties)
	expeditionCtrl.super.ctor(self, properties)
end
function expeditionCtrl:Logout()
	expeditionCtrl.super.Logout(self)
	self:resetData()
end
function expeditionCtrl:resetData()
	self.questProgress, _UPVALUE0_, self.finishedQuest, _UPVALUE0_, self.claimedQuest, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
	self.round = 0
end
function expeditionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EXPEDITION_ACTIVITY_INIT_DATA, handler(self, self.getInitDataRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CLAIM_EXPEDITION_ACTIVITY_REWARD, handler(self, self.getRewardRsp))
end
function expeditionCtrl:initClientData(data)
	if data then
		self.claimedQuest = data.claimedQuest
		self.finishedQuest = data.finishedQuest
		self.questProgress = data.questProgress
		self.round = data.round
	end
	self:registerNotify()
end
function expeditionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function expeditionCtrl:notifyHandler(event)
	local isNeedUpdate = false
	for _, content in ipairs(event.data) do
		if content.activityID == gActivityTimeActivityID.EXPEDITON then
			if content.notifyType == "progressUpdate" then
				local notifyData = content.notifyData
				self.questProgress[tostring(notifyData.questID)] = notifyData.progress
			end
			if content.notifyType == "questFinish" then
				local notifyData = content.notifyData
				self.finishedQuest[tostring(notifyData.questID)] = 1
			end
			isNeedUpdate = true
		end
	end
	if isNeedUpdate then
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_SERVER_EXPEDITON_UPDATE"
		SoraDSendMessage(ipairs(event.data))
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		ipairs(event.data).eventID = gActivityTimeActivityID.EXPEDITON
		SoraDSendMessage(ipairs(event.data))
	end
end
function expeditionCtrl:getQuestStatus(questID)
	local status = gBtnTargetStatusDef.GO
	local amount = 0
	if self.claimedQuest and next(self.claimedQuest) and self.claimedQuest[tostring(questID)] then
		status = gBtnTargetStatusDef.GOT
	elseif self.finishedQuest and next(self.finishedQuest) and self.finishedQuest[tostring(questID)] then
		status = gBtnTargetStatusDef.GET
	else
		amount = self.questProgress and next(self.questProgress) and self.questProgress[tostring(questID)] or 0
	end
	return status, amount
end
function expeditionCtrl:isCanClaimReward()
	local ret = false
	local num = 0
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXPEDITON, false) and self.finishedQuest and next(self.finishedQuest) then
		ret = true
		for k, v in pairs(self.finishedQuest) do
			if not self.claimedQuest[k] then
				num = num + 1
			end
		end
	end
	return ret, num
end
function expeditionCtrl:getReceiveStatusAndNum()
	return self:isCanClaimReward()
end
function expeditionCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EXPEDITION_ACTIVITY_INIT_DATA, nil)
end
function expeditionCtrl:sendGetRewardMsg(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CLAIM_EXPEDITION_ACTIVITY_REWARD, nil)
end
function expeditionCtrl:getInitDataRsp(content)
	dump(content, "expeditionCtrl:getInitDataRsp", 5)
	if gErrDef.Err_None == content.err then
		self.claimedQuest = content.rspData.claimedQuest
		self.finishedQuest = content.rspData.finishedQuest
		self.questProgress = content.rspData.questProgress
		self.round = content.rspData.round
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_EXPEDITON_UPDATE"
	SoraDSendMessage(content.err)
end
function expeditionCtrl:getRewardRsp(content)
	dump(content, "expeditionCtrl:getRewardRsp", 5)
	if gErrDef.Err_None == content.err then
		local data = content.rspData
		self.claimedQuest[tostring(data.questID)] = 1
		SoraDMailGainItems(data.reward, true)
		_ENV = data.reward
		data.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		data.reward.eventID = gActivityTimeActivityID.EXPEDITON
		SoraDSendMessage(data.reward)
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_SERVER_EXPEDITON_UPDATE"
	SoraDSendMessage(SoraDSendMessage)
end
return expeditionCtrl
