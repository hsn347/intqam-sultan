local questMgrUnit = class(questMgrUnit)
function questMgrUnit:updateQuest(questID, progress)
	local performQuest = self:getPerformingQuest()
	if performQuest and performQuest:getQuestID() == questID and performQuest:isPerforming() then
		local curProgress = performQuest:setProgress(progress)
		if performQuest:canCommit() then
			_ENV = performQuest
			performQuest.msg = "MESSAGE_GREEN_POINT_UPDATE"
			performQuest.type = GREEN_POINT_NOTICE_TYPE.QUEST
			SoraDSendMessage(performQuest)
		end
		return curProgress
	end
end
function questMgrUnit:commitQuest(questID)
	local quest = self:getPerformingQuest()
	if quest and questID == quest:getQuestID() then
		self:setPerformingQuest(nil)
	end
	if gModuleMgr.sharedMgr("questltCtrl"):isLastQuest(questID) then
		self:complete()
	end
end
function questMgrUnit:getPerformingQuest()
	return self.performing_quest
end
function questMgrUnit:setPerformingQuest(questCell)
	self.performing_quest = questCell
end
function questMgrUnit:complete()
	self.complete_status = true
end
function questMgrUnit:isComplete()
	return self.complete_status
end
function questMgrUnit:ctor()
	local uid
	self.uid = uid
	self.performing_quest = nil
	self.complete_status = nil
end
function questMgrUnit:dump()
	if self.performing_quest then
		print("正在执行的任务：")
		self.performing_quest:dump()
	end
end
return questMgrUnit
