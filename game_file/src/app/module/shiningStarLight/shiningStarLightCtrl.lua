local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local shiningStarLightCtrl = class("shiningStarLightCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function shiningStarLightCtrl:ctor(properties)
	shiningStarLightCtrl.super.ctor(self, properties)
	self:resetData()
end
function shiningStarLightCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GLORIOUS_STAR_LAMP_MODULE, gCmd.REQ_GLORIOUS_STAR_LAMP_INIT, handler(self, self.reqGloriousStarLampInitRsp))
	msgCtrl.register(gCmd.CMD_GLORIOUS_STAR_LAMP_MODULE, gCmd.REQ_GLORIOUS_STAR_LAMP_CLAIM_QUEST_REWARD, handler(self, self.reqGloriousStarLampClaimQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_GLORIOUS_STAR_LAMP_MODULE, gCmd.REQ_GLORIOUS_STAR_LAMP_UP_STAR_LAMP, handler(self, self.reqGloriousStarLampUpStarLampRsp))
	msgCtrl.register(gCmd.CMD_GLORIOUS_STAR_LAMP_MODULE, gCmd.REQ_GLORIOUS_STAR_LAMP_OPEN_BOX, handler(self, self.reqGloriousStarLampOpenBoxRsp))
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	backpackCtrl:addItemChangeEvent(829601, handler(self, self.notifyItemCount))
	self:registerNotify()
	self:reqGloriousStarLampInit()
end
function shiningStarLightCtrl:Logout()
	shiningStarLightCtrl.super.Logout(self)
	self:resetData()
end
function shiningStarLightCtrl:resetData()
	self.questData, _UPVALUE0_ = nil, nil
	self.starLampPhase = 1
	self.isOpenBox = 0
	self.initCastleLv = 1
end
function shiningStarLightCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function shiningStarLightCtrl:notifyHandler(event)
	for k, v in ipairs(event.data) do
		if v.activityID == gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY and v.notifyType == "progressUpdate" and self.questComponent and self.questComponent.onNotify_progressUpdate then
			self.questComponent:onNotify_progressUpdate(v.notifyData)
		end
	end
end
function shiningStarLightCtrl:reqGloriousStarLampInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GLORIOUS_STAR_LAMP_MODULE, gCmd.REQ_GLORIOUS_STAR_LAMP_INIT, nil)
end
function shiningStarLightCtrl:reqGloriousStarLampClaimQuestReward(data)
	serverproxy:Request(gCmd.CMD_GLORIOUS_STAR_LAMP_MODULE, gCmd.REQ_GLORIOUS_STAR_LAMP_CLAIM_QUEST_REWARD, data)
end
function shiningStarLightCtrl:reqGloriousStarLampUpStarLamp()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GLORIOUS_STAR_LAMP_MODULE, gCmd.REQ_GLORIOUS_STAR_LAMP_UP_STAR_LAMP, nil)
end
function shiningStarLightCtrl:reqGloriousStarLampOpenBox()
	serverproxy:Request(gCmd.CMD_GLORIOUS_STAR_LAMP_MODULE, gCmd.REQ_GLORIOUS_STAR_LAMP_OPEN_BOX)
end
function shiningStarLightCtrl:reqGloriousStarLampInitRsp(content)
	dump(content, "shiningStarLightCtrl:reqGloriousStarLampInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:addQuestComponent(gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY, content.rspdata.questData)
		self.starLampPhase = content.rspdata.starLampPhase
		self.isOpenBox = content.rspdata.isOpenBox
		self.initCastleLv = content.rspdata.initCastleLv
	end
end
function shiningStarLightCtrl:reqGloriousStarLampClaimQuestRewardRsp(content)
	dump(content, "shiningStarLightCtrl:reqGloriousStarLampClaimQuestRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None and self.questComponent and self.questComponent.reqRuestClaimRewardRsp then
		self.questComponent:reqRuestClaimRewardRsp(content)
	end
end
function shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)
	dump(content, "shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local reward = content.rspdata.reward
		self.starLampPhase = content.rspdata.starLampPhase
		_ENV = "shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)"
		;("shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)").msg = "MESSAGE_SHINING_STAR_LIGHT"
		;("shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)").subMsg = "Star_Reward"
		;("shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)").reward = reward
		;("shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)").index = self.starLampPhase
		SoraDSendMessage("shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)")
		_ENV = "shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)"
		;("shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)").activityID = gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY
		SoraDSendMessage("shiningStarLightCtrl:reqGloriousStarLampUpStarLampRsp(content)")
	end
end
function shiningStarLightCtrl:notifyItemCount(...)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;(nil).activityID = gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY
	SoraDSendMessage(nil)
end
function shiningStarLightCtrl:reqGloriousStarLampOpenBoxRsp(content)
	dump(content, "shiningStarLightCtrl:reqGloriousStarLampOpenBoxRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local reward = content.rspdata.reward
		self.isOpenBox = content.rspdata.isOpenBox
		SoraDMailGainItems(reward, true)
		_ENV = reward
		reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		reward.activityID = gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY
		SoraDSendMessage(reward)
		_ENV = reward
		reward.msg = "MESSAGE_SHINING_STAR_LIGHT"
		SoraDSendMessage(reward)
	end
end
function shiningStarLightCtrl:addQuestComponent(activityID, questData)
	local activityTaskComponent = include("activityTaskComponent")
	local questComponent = activityTaskComponent.new()
	questComponent:setActivityID(activityID)
	questComponent:setQuestData(questData)
	self.questComponent = questComponent
end
function shiningStarLightCtrl:getStarLampIndex()
	return self.starLampPhase or 1
end
function shiningStarLightCtrl:getBoxIsOpen()
	return self.isOpenBox or 0
end
function shiningStarLightCtrl:getInitCastleLv()
	return self.initCastleLv or SoraDGetCastleLv()
end
function shiningStarLightCtrl:getQuestData()
	return self:getSortList(self.questComponent and self.questComponent:getQuestData())
end
function shiningStarLightCtrl:getTaskReceiveStatusAndNum()
	if self.questComponent then
		return self.questComponent:getReceiveStatusAndNum()
	end
	return false, 0
end
function shiningStarLightCtrl:getLightStatusAndNum()
	local shiningStarLightRead = include("shiningStarLightRead")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local canLight = false
	print("starLampPhase", self.initCastleLv, self.starLampPhase)
	local config = shiningStarLightRead.getLightAward(self.initCastleLv, self.starLampPhase + 1)
	if next(config) and backpackCtrl:getItemCount(config.need[1]) >= config.need[2] then
		canLight = true
	end
	if self.isOpenBox == 0 and self.starLampPhase == 5 then
		canLight = true
	end
	return canLight
end
function shiningStarLightCtrl:getReceiveStatusAndNum(activityID)
	local retTask_1 = self:getTaskReceiveStatusAndNum()
	return retTask_1 or self:getLightStatusAndNum(), -1
end
function shiningStarLightCtrl:getSortList(serverData)
	local _ENV, ret
	local eventQuestRead = include("eventQuestRead")
	local shiningStarLightRead = include("shiningStarLightRead")
	if not shiningStarLightRead.getQuestList(self.initCastleLv) then
		local _ENV, queueList = shiningStarLightRead.getQuestList(self.initCastleLv), shiningStarLightRead.getQuestList(self.initCastleLv)
	end
	dump(serverData, "eventQuestRead.serverData")
	dump(queueList, "eventQuestRead.queueList")
	for i, v in ipairs(queueList) do
		local questID = v
		local cfgItem = eventQuestRead.questconfig[tonumber(questID)]
		SoraDPrint(cfgItem)
		local count = 0
		local taskStatus = gBtnTargetStatusDef.GO
		if serverData then
			if serverData.questProgress then
				count = serverData.questProgress[tostring(questID)] or 0
			end
			if serverData.claimedQuest and serverData.claimedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.claimedQuest and serverData.finishedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		_ENV = questID
		questID.activityID = gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY
		questID.taskID = questID
		questID.count = count
		questID.award = cfgItem.reward
		questID.total = cfgItem.aim
		questID.taskStatus = taskStatus
		questID.taskDes = cfgItem.taskDes
		questID.guideId = cfgItem.guideId
		table.insert(ret, questID)
	end
	table.sort(ret, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	return ret
end
return shiningStarLightCtrl
