local questMgrUnit = include("questMgrUnit")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local questCellClass = include("questCell")
local playerQuestUnit = class("playerQuestUnit")
function playerQuestUnit:init(completeQuest)
	if not completeQuest then
		return
	end
	for i, questType in ipairs(completeQuest) do
		local mgrUnit = self.noraml_quest_list[questType]
		if mgrUnit then
			mgrUnit:complete()
		end
	end
end
function playerQuestUnit:performNewQuest(property)
	local cell = questCellClass.new(property)
	local questID = cell:getQuestID()
	local mgrUnit = self:getQuestMgrUnit(questID)
	if mgrUnit then
		return mgrUnit:setPerformingQuest(cell)
	end
end
function playerQuestUnit:refreshGuideQuest(property)
	local cell = questCellClass.new(property)
	self.guideQuest = cell
	local questID = cell:getQuestID()
	local questType = questltCtrl:getQuestType(questID)
	questCellClass = questID
	questID.msg = "MESSAGE_QUEST_NOTICE_RECOMMEND_UPDATE"
	questID.questID = questID
	questID.questType = questType
	SoraDSendMessage(questID)
end
function playerQuestUnit:finishGuideQuest()
	self.guideQuest = nil
	_ENV = nil
	;(nil).msg = "MESSAGE_QUEST_NOTICE_RECOMMEND_UPDATE"
	SoraDSendMessage(nil)
end
function playerQuestUnit:getGuideQuest()
	return self.guideQuest
end
function playerQuestUnit:updateQuest(questID, progress)
	local mgrUnit = self:getQuestMgrUnit(questID)
	if mgrUnit and mgrUnit:updateQuest(questID, progress) then
		local questType = questltCtrl:getQuestType(questID)
		questltCtrl = questID
		questID.msg = "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE"
		questID.questType = questType
		SoraDSendMessage(questID)
	end
	local guideQuest = self:getGuideQuest()
	if guideQuest and guideQuest:getQuestID() == questID then
		guideQuest:setProgress(progress)
		local questType
		questltCtrl = progress
		progress.msg = "MESSAGE_QUEST_NOTICE_RECOMMEND_UPDATE"
		progress.questID = questID
		progress.questType = questType
		SoraDSendMessage(progress)
	end
end
function playerQuestUnit:commitQuest(questID)
	local mgrUnit = self:getQuestMgrUnit(questID)
	if mgrUnit then
		mgrUnit:commitQuest(questID)
	end
end
function playerQuestUnit:getQuestMgrUnit(questID)
	local kind = questltCtrl:getKindOfQuest(questID)
	if gQuestKind.NORMAL == kind then
		local questType = questltCtrl:getQuestType(questID)
		self.noraml_quest_list[questType] = self.noraml_quest_list[questType] or questMgrUnit.new(self.uid)
		return self.noraml_quest_list[questType]
	elseif gQuestKind.RECOMMENDED == kind then
		return self.recommended_quest_unit
	end
	self._needUpdate = true
end
function playerQuestUnit:getQuestMgrUnit_(kind, questType)
	if gQuestKind.NORMAL == kind then
		self.noraml_quest_list[questType] = self.noraml_quest_list[questType] or questMgrUnit.new(self.uid)
		return self.noraml_quest_list[questType]
	elseif gQuestKind.RECOMMENDED == kind then
		return self.recommended_quest_unit
	end
end
function playerQuestUnit:getNoramlPerformingQuest(questType)
	local mgrUnit = self:getQuestMgrUnit_(gQuestKind.NORMAL, questType)
	return mgrUnit:getPerformingQuest()
end
function playerQuestUnit:getRecommendedPerformingQuest()
	return self:getGuideQuest()
end
function playerQuestUnit:getCompleteQuestList()
	local _ENV, ret
	for questType, mgrUnit in pairs(self.noraml_quest_list) do
		if mgrUnit:isComplete() then
			local lastQuest = questltCtrl:getLastQuest(questType)
			table.insert(ret, lastQuest)
		end
	end
	return ret
end
function playerQuestUnit:needUpdate()
	return self._needUpdate
end
function playerQuestUnit:ctor()
	self.noraml_quest_list, questMgrUnit = nil, nil
	self.recommended_quest_unit = questMgrUnit.new(self.uid)
	for _, questType in pairs(gQuestType) do
		if gQuestType.NONE ~= questType then
			self.noraml_quest_list[questType] = questMgrUnit.new(self.uid)
		end
	end
end
function playerQuestUnit:loadQuestData(questArray)
	if questArray then
		for _, property in ipairs(questArray) do
			self:performNewQuest(property)
		end
	end
end
function playerQuestUnit:dump()
	print("=====>playerQuestUnit:")
	print("推荐任务：")
	self.recommended_quest_unit:dump()
	for questType, mgrUnit in pairs(self.noraml_quest_list) do
		print("普通任务：" .. questType)
		mgrUnit:dump()
	end
end
return playerQuestUnit
