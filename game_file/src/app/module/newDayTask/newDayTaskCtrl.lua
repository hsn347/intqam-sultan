local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local newDayTaskCtrl = class("newDayTaskCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function newDayTaskCtrl:ctor(properties)
	newDayTaskCtrl.super.ctor(self, properties)
	self:resetData()
end
function newDayTaskCtrl:EnterGame()
end
function newDayTaskCtrl:Logout()
	newDayTaskCtrl.super.Logout(self)
	self:resetData()
end
function newDayTaskCtrl:resetData()
end
function newDayTaskCtrl:getSortList(activityID)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local newDayTaskRead = include("newDayTaskRead")
	local _ENV, ret = "newDayTaskRead", "newDayTaskRead"
	local questComponent = activityTaskComponentCtrl:getQuestComponent(activityID)
	if questComponent then
		local serverData = questComponent and questComponent:getQuestData()
		local otherInfo = activityTaskComponentCtrl:getActivityInitData(activityID)
		if not newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0) then
			local _ENV, queueList = newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0), newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0)
		end
		local eventQuestRead = include("eventQuestRead")
		dump(serverData, "eventQuestRead.serverData")
		dump(queueList, "eventQuestRead.queueList")
		for _, questID in ipairs(queueList) do
			local cfgItem = eventQuestRead.getTaskConfig(tonumber(questID))
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
			questID.activityID = activityID
			questID.taskID = questID
			questID.count = count
			questID.award = cfgItem.reward
			questID.total = cfgItem.aim
			questID.taskStatus = taskStatus
			questID.taskDes = cfgItem.taskDes
			questID.guideId = cfgItem.guideId
			questID.type = cfgItem.type
			table.insert(ret, questID)
		end
		table.sort(ret, function(a, b)
			if a.taskStatus ~= b.taskStatus then
				return a.taskStatus < b.taskStatus
			end
			return a.taskID < b.taskID
		end)
	end
	return ret
end
function newDayTaskCtrl:getQuestData(activityID)
	return self:getSortList(activityID)
end
function newDayTaskCtrl:getReceiveStatusAndNum(activityID)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local newDayTaskRead = include("newDayTaskRead")
	local questComponent = activityTaskComponentCtrl:getQuestComponent(activityID)
	if questComponent then
		local count = 0
		local serverData = questComponent and questComponent:getQuestData()
		local otherInfo = activityTaskComponentCtrl:getActivityInitData(activityID)
		if not newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0) then
			local _ENV, queueList = newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0), newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0)
		end
		for _, questID in ipairs(queueList) do
			if serverData and serverData.claimedQuest and serverData.finishedQuest[tostring(questID)] and not serverData.claimedQuest[tostring(questID)] then
				count = count + 1
			end
		end
		return 0 < count, count
	end
	return false
end
function newDayTaskCtrl:isResetEveryday()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local newDayTaskRead = include("newDayTaskRead")
	local eventQuestRead = include("eventQuestRead")
	local otherInfo = activityTaskComponentCtrl:getActivityInitData(gActivityTimeActivityID.CHANGE_DAY_ACTIVITY)
	if not newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0) then
		local _ENV, queueList = newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0), newDayTaskRead.getTaskList(otherInfo.castleLv or 0, otherInfo.starLv or 0)
	end
	if next(queueList) then
		local questInfo = eventQuestRead.getTaskConfig(tonumber(queueList[1]))
		if questInfo and next(questInfo) then
			return questInfo.type == 1
		end
	end
	return false
end
return newDayTaskCtrl
