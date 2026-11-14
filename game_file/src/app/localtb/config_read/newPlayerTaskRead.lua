local newPlayerTaskRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "new_player_chapter_reward"
	;(nil)[2] = true
	newPlayerTaskRead:defineValue("localChatperReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "new_player_task_reward"
	;(nil)[2] = true
	newPlayerTaskRead:defineValue("localTaskReward", nil)
	newPlayerTaskRead = nil
	;(nil)[1] = "new_player_chapter_describe"
	newPlayerTaskRead:defineValue("localChatperDes", nil)
	newPlayerTaskRead = nil
	;(nil)[1] = "new_player_task_describe"
	newPlayerTaskRead:defineValue("localTaskDes", nil)
end
init()
function newPlayerTaskRead.getAllChapterReward()
	return newPlayerTaskRead.localChatperReward
end
function newPlayerTaskRead.getFirstChapterID()
	return self.localChatperReward[1].chapterID
end
function newPlayerTaskRead.getAllChapterID()
	local _ENV, ret
	for key, value in pairs(newPlayerTaskRead.localChatperReward) do
		table.insert(ret, value.chapterID)
	end
	return ret
end
function newPlayerTaskRead.getRewardByChapterID(chapterID)
	local _ENV, ret
	local _ENV, prize
	for key, value in pairs(newPlayerTaskRead.localChatperReward) do
		if value.chapterID == tonumber(chapterID) then
			ret = value.reward
			break
		end
	end
	for i, v in ipairs(ret) do
		if i % 2 == 1 and ret[i + 1] then
			_ENV = chapterID
			chapterID.itemID = v
			chapterID.itemCount = ret[i + 1]
			table.insert(prize, chapterID)
		end
	end
	return prize
end
function newPlayerTaskRead.getCastleLevelByChapterID(chapterID)
	local ret = 0
	for key, value in pairs(newPlayerTaskRead.localChatperReward) do
		if value.chapterID == tonumber(chapterID) then
			ret = value.castleLevel
			break
		end
	end
	return ret
end
function newPlayerTaskRead.getIndexByChapterID(chapterID)
	local ret = 0
	for key, value in pairs(newPlayerTaskRead.localChatperReward) do
		if value.chapterID == tonumber(chapterID) then
			ret = value.index
			break
		end
	end
	return ret
end
function newPlayerTaskRead.getTaskIDByChapterID(chapterID)
	local _ENV, ret
	for key, value in ipairs(newPlayerTaskRead.localTaskReward) do
		if tonumber(chapterID) == value.chapterID then
			table.insert(ret, value.taskID)
		end
	end
	return ret
end
function newPlayerTaskRead.getInfoByTaskID(taskID)
	local _ENV, ret
	for key, value in pairs(newPlayerTaskRead.localTaskReward) do
		if tonumber(taskID) == value.taskID then
			ret = value
			break
		end
	end
	return ret
end
function newPlayerTaskRead.getRewardByTaskID(taskID)
	local _ENV, ret
	for key, value in pairs(newPlayerTaskRead.localTaskReward) do
		if value.taskID == tonumber(taskID) then
			ret = value.reward
			break
		end
	end
	return ret
end
function newPlayerTaskRead.getConditionByTaskID(taskID)
	for key, value in pairs(newPlayerTaskRead.localTaskReward) do
		if tonumber(taskID) == value.taskID then
			return value.condition, value.questType, value.num
		end
	end
end
function newPlayerTaskRead.getAllTaskID()
	local _ENV, ret
	for k, v in pairs(newPlayerTaskRead.localTaskReward) do
		table.insert(ret, v.taskID)
	end
	return ret
end
function newPlayerTaskRead.getNeedFinishCountByTaskID(taskID)
	local ret = 1
	for key, value in pairs(self.localTaskReward) do
		if value.taskID == tonumber(taskID) then
			ret = value.num
			break
		end
	end
	return ret
end
function newPlayerTaskRead.getCondition(taskID)
	local condition, questType, num = newPlayerTaskRead.getConditionByTaskID(taskID)
	newPlayerTaskRead = nil
	;(nil).condition = condition
	local (nil).questType, ret = questType, nil
	if condition and questType then
		if questType == gNewPLayerTaskType.BUILD_UPGRADE then
			ret.bid = condition[1]
			ret.lv = condition[2]
			if num and 1 < num then
				ret.count = num
			end
		elseif questType == gNewPLayerTaskType.TRAIN_SOLDIERS then
			ret.bid = condition[1]
			ret.lv = condition[2]
			ret.count = condition[3]
		elseif questType == gNewPLayerTaskType.COLLECT_RESOURCE or questType == gNewPLayerTaskType.COLLECT_RESOURCE_START then
			ret.resid = condition[1]
			ret.count = condition[2]
		elseif questType == gNewPLayerTaskType.RESEARCH_TECHNOLOGY then
			ret.technologyId = condition[1]
		elseif questType == gNewPLayerTaskType.KILL_MONSTER then
			ret.lv = condition[1]
		elseif questType == gNewPLayerTaskType.TIME_REWARD then
		elseif questType == gNewPLayerTaskType.LORD_SKILL then
		elseif questType == gNewPLayerTaskType.EVERYDAY_REWARD then
		elseif questType == gNewPLayerTaskType.ACTIVITY_VIP then
		elseif questType == gNewPLayerTaskType.UNLOCK_PET then
			local petid = condition[1]
		elseif questType == gNewPLayerTaskType.HARVEST_RESOURCE then
		elseif questType == gNewPLayerTaskType.UNLOCK_AREA then
		elseif questType == gNewPLayerTaskType.OPEN_BUILD_QUEUE then
		elseif questType == gNewPLayerTaskType.JOIN_ALLIANCE then
		elseif questType == gNewPLayerTaskType.HELP_PLAYER then
		elseif questType == gNewPLayerTaskType.MAKE_A_WISH then
		elseif questType == gNewPLayerTaskType.MYSTICAL_STORE then
		elseif questType == gNewPLayerTaskType.ALLIANCE_DONATE then
		elseif questType == gNewPLayerTaskType.PYRAMID then
		elseif questType == gNewPLayerTaskType.STUFFWORKSHOP then
			ret.materialID = condition[1]
			ret.materialNum = condition[2]
		elseif questType == gNewPLayerTaskType.EQUIP then
			ret.equipmentID = condition[1]
			ret.equipmentCount = condition[2]
		elseif questType == gNewPLayerTaskType.ESCORT then
			ret.isNewTrial = true
		elseif questType == gNewPLayerTaskType.POWRE then
			ret.power = condition[1]
		elseif questType == gNewPLayerTaskType.ALLIANCE_DONATE_POINT then
			ret.donateHistoryPoint = condition[1]
		elseif questType == gNewPLayerTaskType.HERO_TRIAL then
			ret.heroTrialCount = condition[1]
			ret.isNewTrial = true
			ret.className = "mainUI"
		end
	end
	return ret
end
function newPlayerTaskRead.isChapterRealOpen()
	local ret = false
	local gametop = gModuleMgr.getObject("gametop")
	local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if curChapterID and 0 < curChapterID then
		local castleLv = newPlayerTaskRead.getCastleLevelByChapterID(curChapterID)
		local curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if castleLv <= curCastleLv then
			ret = true
		end
	end
	return ret
end
function newPlayerTaskRead.getPngByCID(chatperID)
	local png = ""
	if newPlayerTaskRead.localChatperDes[chatperID] then
		png = newPlayerTaskRead.localChatperDes[chatperID].picture
	end
	return png
end
function newPlayerTaskRead.getTitleByCID(chatperID)
	local str = ""
	if newPlayerTaskRead.localChatperDes[chatperID] then
		str = i18n(newPlayerTaskRead.localChatperDes[chatperID].chapter)
	end
	return str
end
function newPlayerTaskRead.getNameByCID(chatperID)
	local str = ""
	if newPlayerTaskRead.localChatperDes[chatperID] then
		str = i18n(newPlayerTaskRead.localChatperDes[chatperID].chapterName)
	end
	return str
end
function newPlayerTaskRead.getDesByCID(chatperID)
	local str = ""
	if newPlayerTaskRead.localChatperDes[chatperID] then
		str = i18n(newPlayerTaskRead.localChatperDes[chatperID].chapterDes)
	end
	return str
end
function newPlayerTaskRead.getNPCNoticeByCID(chatperID)
	local str = ""
	if newPlayerTaskRead.localChatperDes[chatperID] then
		str = newPlayerTaskRead.localChatperDes[chatperID].dialogue
		str = str ~= "" and i18n(str) or str
	end
	return str
end
function newPlayerTaskRead.getChapterTitlePng(chatperID)
	if newPlayerTaskRead.localChatperDes[chatperID] then
		return SoraDFIsRA() and newPlayerTaskRead.localChatperDes[chatperID].picture_name_arab or newPlayerTaskRead.localChatperDes[chatperID].picture_name_en
	end
	return "chapter_en_1.png"
end
function newPlayerTaskRead.getDesByTID(taskID)
	local str = ""
	if newPlayerTaskRead.localTaskDes[taskID] then
		str = i18n(newPlayerTaskRead.localTaskDes[taskID].taskDes)
	end
	return str
end
return newPlayerTaskRead
