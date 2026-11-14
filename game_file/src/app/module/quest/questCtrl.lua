local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local playerQuestUnitClass = include("playerQuestUnit")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local operationalQuestMgr = include("operationalQuestMgr")
local questCtrl = class("questCtrl", gameModule)
local reqPageNum = 10
local _ENV, RSP = gameModule, gameModule
function questCtrl:ctor(properties)
	questCtrl.super.ctor(self, properties)
	self:resetData()
end
function questCtrl:resetData()
	self.playerQuestUnit = nil
	self.playerQuestUnit = playerQuestUnitClass.new()
	operationalQuestMgr.release()
end
function questCtrl:EnterGame()
	questCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_QUEST_MODULE, gCmd.REQ_INIT_QUESTDATA, handler(self, RSP.initDataRsp))
	msgCtrl.register(gCmd.CMD_QUEST_MODULE, gCmd.REQ_COMMIT_QUEST, handler(self, RSP.commitQuestRsp))
	msgCtrl.register(gCmd.CMD_QUEST_MODULE, gCmd.REQ_COMPLETE_OPERATIONAL_QUEST, handler(self, RSP.completeOperationalQuestRsp))
	msgCtrl.register(gCmd.CMD_QUEST_MODULE, gCmd.REQ_COMMIT_OPERATIONAL_QUEST, handler(self, RSP.commitOperationalQuestRsp))
end
function questCtrl:Logout()
	questCtrl.super.Logout(self)
	self.handle_quest_notify = nil
	self:resetData()
end
function questCtrl:getNoramlPerformingQuestList()
	local _ENV, list
	for _, questType in pairs(gQuestType) do
		if gQuestType.NONE ~= questType then
			local quest = self:getNoramlPerformingQuest(questType)
			if quest then
				table.insert(list, quest)
			else
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				local castleLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
				local nextLevel = castleLevel + 1
				local nextQuestID = questltCtrl:getFirstNormalQuestByCastleLevel(questType, nextLevel)
				if nextQuestID then
					_ENV = questltCtrl
					questltCtrl.questID = nextQuestID
					questltCtrl.status = gQuestStatus.NONE
					questltCtrl.progress = 0
					questltCtrl.aim = questltCtrl:getQuestAim(nextQuestID)
					questltCtrl.lock = true
					local questltCtrl.sortIndex, property = questltCtrl:getQuestSortType(nextQuestID), questltCtrl
					local nextQuest = include("questCell").new(property)
					table.insert(list, nextQuest)
				end
			end
		end
	end
	table.sort(list, function(a, b)
		if a and b then
			local aQuestID = a:getQuestID()
			local aOrder = questltCtrl:getQuestSortType(aQuestID)
			local bQuestID = b:getQuestID()
			local bOrder = questltCtrl:getQuestSortType(bQuestID)
			return aOrder > bOrder
		else
			return true
		end
	end)
	return list
end
function questCtrl:getNoramlPerformingQuest(questType)
	return self.playerQuestUnit:getNoramlPerformingQuest(questType)
end
function questCtrl:getRecommendedPerformingQuest()
	return self.playerQuestUnit:getRecommendedPerformingQuest()
end
function questCtrl:getPerformingGuideQuest()
	return self.pGuideQuest
end
function questCtrl:getCommitQuestNum()
	local num = 0
	local quest = self.playerQuestUnit:getRecommendedPerformingQuest()
	if quest and quest:canCommit() then
		num = num + 1
	end
	for _, questType in pairs(gQuestType) do
		if gQuestType.NONE ~= questType then
			local quest = self:getNoramlPerformingQuest(questType)
			if quest and quest:canCommit() then
				num = num + 1
			end
		end
	end
	num = num + operationalQuestMgr.getCommitQuestNum()
	return num
end
function questCtrl:getGuideQuest()
	return self.playerQuestUnit:getGuideQuest()
end
function questCtrl:getCanCommitQuest()
	local quest = self.playerQuestUnit:getGuideQuest()
	if quest and quest:canCommit() then
		return quest
	else
		quest = nil
	end
	for _, questType in pairs(gQuestType) do
		if gQuestType.NONE ~= questType then
			quest = self:getNoramlPerformingQuest(questType)
			if quest and quest:canCommit() then
				return quest
			else
				quest = nil
			end
		end
	end
	quest = operationalQuestMgr:getCanCommitQuest()
	return quest
end
function questCtrl:getFirstNormalQuest()
	_UPVALUE4_ = nil
	;(nil)[1] = 27
	;(nil)[2] = 28
	;(nil)[3] = 31
	local (nil)[4], behindArray = 37, nil
	local _ENV, list = 27, 27
	local _ENV, noGoList = 28, 28
	for _, questType in pairs(gQuestType) do
		if gQuestType.NONE ~= questType then
			local quest = self:getNoramlPerformingQuest(questType)
			if quest and not quest:canCommit() then
				if SoraDisInList(questType, behindArray) then
					table.insert(noGoList, quest)
				else
					table.insert(list, quest)
				end
			end
		end
	end
	table.sort(list, function(a, b)
		if a and b then
			local aQuestID = a:getQuestID()
			local aOrder = questltCtrl:getQuestSortType(aQuestID)
			local bQuestID = b:getQuestID()
			local bOrder = questltCtrl:getQuestSortType(bQuestID)
			return aOrder < bOrder
		else
			return true
		end
	end)
	dump(list, "getFirstNormalQuest", 100)
	table.sort(noGoList, function(a, b)
		if a and b then
			local aQuestID = a:getQuestID()
			local aOrder = questltCtrl:getQuestSortType(aQuestID)
			local bQuestID = b:getQuestID()
			local bOrder = questltCtrl:getQuestSortType(bQuestID)
			return aOrder < bOrder
		else
			return true
		end
	end)
	return list[1] or noGoList[1]
end
function questCtrl:completeOperationalQuest(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_QUEST_MODULE, gCmd.REQ_COMPLETE_OPERATIONAL_QUEST, nil)
end
function questCtrl:commitOperationalQuest(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_QUEST_MODULE, gCmd.REQ_COMMIT_OPERATIONAL_QUEST, nil)
end
function questCtrl:getOperationalQuestListOfTop()
	return operationalQuestMgr.getListOfTop()
end
function questCtrl:getOperationalQuestListOfBottom()
	return operationalQuestMgr.getListOfBottom()
end
function questCtrl:getCompleteQuestList()
	return self.playerQuestUnit:getCompleteQuestList()
end
function questCtrl:needUpdate()
	return self.playerQuestUnit:needUpdate()
end
function questCtrl:reqInitData(...)
	serverproxy:Request(gCmd.CMD_QUEST_MODULE, gCmd.REQ_INIT_QUESTDATA, ...)
end
function questCtrl:reqCommitQuest(questID, ...)
	if include("pyramidWarltCtrl").checkPwXianXiaSai() then
		if questltCtrl:isOperationalQuest(questID) then
			self:commitOperationalQuest(questID)
		else
			_ENV = nil
			;(nil).questID = questID
			serverproxy:Request(gCmd.CMD_QUEST_MODULE, gCmd.REQ_COMMIT_QUEST, nil, ...)
		end
	end
end
function RSP:initDataRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local questArray = data.questArray
		local guideQuest = data.guideQuest
		if guideQuest then
			self.playerQuestUnit:refreshGuideQuest(guideQuest)
		end
		for _, property in ipairs(questArray) do
			self.playerQuestUnit:performNewQuest(property)
		end
	end
end
function RSP:updateDataRsp(event)
	local data = event.data
	for i, notifyData in ipairs(data) do
		local notifyType = notifyData.notifyType
		if "new" == notifyType then
			local array = notifyData.array
			for i, property in ipairs(array) do
				self.playerQuestUnit:performNewQuest(property)
			end
		elseif "update" == notifyType then
			local questID = notifyData.questID
			local progress = notifyData.progress
			self.playerQuestUnit:updateQuest(questID, progress)
			self.pGuideQuest = notifyData.pGuideQuest
		elseif "guide" == notifyType then
			local property = notifyData.property
			self.playerQuestUnit:refreshGuideQuest(property)
		elseif "finish_guide" == notifyType then
			self.playerQuestUnit:finishGuideQuest()
		elseif "newOQuest" == notifyType then
			local quest = notifyData.quest
			operationalQuestMgr.addQuest(quest)
		elseif "closeOQuest" == notifyType then
			local questID = notifyData.questID
			operationalQuestMgr.removeQuest(questID)
		elseif "openOQuest" == notifyType then
			local quest = notifyData.quest
			operationalQuestMgr.addQuest(quest)
		end
	end
	_ENV = ipairs(data)
	ipairs(data).msg = "MESSAGE_GREEN_POINT_UPDATE"
	ipairs(data).type = GREEN_POINT_NOTICE_TYPE.QUEST
	SoraDSendMessage(ipairs(data))
end
function RSP:commitQuestRsp(content)
	if gErrDef.Err_None == content.err then
		local data = content.data
		local questID = data.questID
		local property = data.property
		if property then
			self.playerQuestUnit:performNewQuest(property)
		end
		local questType = questltCtrl:getQuestType(questID)
		self.playerQuestUnit:commitQuest(questID)
		local guideQuest = data.guideQuest
		if guideQuest then
			self.playerQuestUnit:refreshGuideQuest(guideQuest)
		end
		self.pGuideQuest = data.pGuideQuest
		_ENV = self.playerQuestUnit
		self.playerQuestUnit.msg = "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS"
		self.playerQuestUnit.err = content.err
		self.playerQuestUnit.questType = questType
		self.playerQuestUnit.questID = questID
		SoraDSendMessage(self.playerQuestUnit)
		_ENV = self.playerQuestUnit
		self.playerQuestUnit.msg = "MESSAGE_GREEN_POINT_UPDATE"
		self.playerQuestUnit.type = GREEN_POINT_NOTICE_TYPE.QUEST
		SoraDSendMessage(self.playerQuestUnit)
		local reward = questltCtrl:getReward(questID)
		SoraDMailGainItems(reward, true)
		_ENV = reward
		reward.msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
		reward.step = 2032
		SoraDSendMessage(reward)
	else
		_ENV = data.questID
		data.questID.msg = "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS"
		data.questID.err = content.err
		SoraDSendMessage(data.questID)
	end
end
function RSP:completeQuestRsp(content)
	if gErrDef.Err_None == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS"
		content.err.err = content.err
		SoraDSendMessage(content.err)
	end
end
function RSP:completeOperationalQuestRsp(content)
	if gErrDef.Err_None == content.err then
		local rspData = content.data
		local questID = rspData.questID
		operationalQuestMgr.completeQuest(questID)
		_ENV = questID
		questID.msg = "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE"
		questID.questType = questType
		SoraDSendMessage(questID)
		_ENV = questID
		questID.msg = "MESSAGE_GREEN_POINT_UPDATE"
		questID.type = GREEN_POINT_NOTICE_TYPE.QUEST
		SoraDSendMessage(questID)
	end
end
function RSP:commitOperationalQuestRsp(content)
	if gErrDef.Err_None == content.err then
		local rspData = content.data
		local questID = rspData.questID
		operationalQuestMgr.commitQuest(questID)
		local questType = questltCtrl:getQuestType(questID)
		_ENV = questID
		questID.msg = "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS"
		questID.err = content.err
		questID.questType = questType
		questID.questID = questID
		SoraDSendMessage(questID)
		_ENV = questID
		questID.msg = "MESSAGE_GREEN_POINT_UPDATE"
		questID.type = GREEN_POINT_NOTICE_TYPE.QUEST
		SoraDSendMessage(questID)
		local title = i18n("common_text_850")
		local reward = questltCtrl:getReward(questID)
		for _, item in ipairs(reward) do
			local itemOrResRead
			if SoraDJudgeResOrItem(item.id) then
				itemOrResRead = include("itemDesRead")
			else
				itemOrResRead = include("resDesRead")
			end
			_ENV = nil
			;(nil).msg = title
			;(nil).name = itemOrResRead.getName(item.id)
			;(nil).count = string.formatnumberthousands(item.count)
			title = i18n("common_text_929", nil)
		end
		SoraDShowMsgTip(title, "#icon_guide_quest.png")
	else
		_ENV = rspData.questID
		rspData.questID.msg = "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS"
		rspData.questID.err = content.err
		SoraDSendMessage(rspData.questID)
	end
end
function questCtrl:initClientData(data)
	local questArray = data.questArray
	local guideQuest = data.guideQuest
	if guideQuest then
		self.playerQuestUnit:refreshGuideQuest(guideQuest)
	end
	for _, property in ipairs(questArray) do
		self.playerQuestUnit:performNewQuest(property)
	end
	local oQuestArray = data.oQuestArray
	operationalQuestMgr.init(oQuestArray)
	self.pGuideQuest = data.pGuideQuest
	self.playerQuestUnit:init(data.completeQuest)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_quest_notify = notifyCtrl:register(gNotifyID.QUEST, handler(self, RSP.updateDataRsp))
end
return questCtrl
