local ltBase = include("ltBase")
local questltCtrl = class("questltCtrl", ltBase, include("aAReadClass").new())
local isInited = false
local init = function()
	if isInited then
		return
	end
	questltCtrl:init()
end
function questltCtrl:ctor()
	questltCtrl.super.ctor(self)
end
function questltCtrl:init()
	local createData = function(name)
		local questltconfig = require_once("app." .. LocalTblPath .. ".config_server.questconfig")
		local _ENV, questData = "app." .. LocalTblPath .. ".config_server.questconfig", "app." .. LocalTblPath .. ".config_server.questconfig"
		local _ENV, recommended = LocalTblPath, LocalTblPath
		local _ENV, normal = ".config_server.questconfig", ".config_server.questconfig"
		local _ENV, normalCastleLevelList
		self.questData = questData
		self.recommended = recommended
		self.normal = normal
		self.normalCastleLevelList = normalCastleLevelList
		local _ENV, lastQuest
		for i, v in ipairs(questltconfig) do
			local quest = v
			if 1 == quest.showType then
				if not lastQuest[quest.questType] then
					lastQuest[quest.questType] = quest.questID
				elseif lastQuest[quest.questType] < quest.questID then
					lastQuest[quest.questType] = quest.questID
				end
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			quest.reward = serviceFunctions.tableFormat(quest.reward, nil)
			for i = #quest.reward, 1, -1 do
				if quest.reward[i].count == 0 then
					table.remove(quest.reward, i)
				end
			end
			questData[quest.questID] = quest
			local kindID = quest.showType
			if kindID == gQuestKind.RECOMMENDED then
				table.insert(recommended, quest.questID)
			else
				if not normal[quest.questType] then
					_ENV = normal[quest.questType]
				end
				normal[quest.questType] = normal[quest.questType]
				table.insert(normal[quest.questType], quest.questID)
				local castleLevel = v.castleLevel
				if not normalCastleLevelList[quest.questType] then
					_ENV = normalCastleLevelList[quest.questType]
				end
				normalCastleLevelList[quest.questType] = normalCastleLevelList[quest.questType]
				if not normalCastleLevelList[quest.questType][castleLevel] then
					_ENV = normalCastleLevelList[quest.questType][castleLevel]
				end
				normalCastleLevelList[quest.questType][castleLevel] = normalCastleLevelList[quest.questType][castleLevel]
				table.insert(normalCastleLevelList[quest.questType][castleLevel], quest.questID)
			end
			_ENV = castleLevel
			_UPVALUE3_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.BUILD_BUILDING], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "id"
			v.castleLevel[gQuestType.BUILD_BUILDING], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "level"
			v.castleLevel[gQuestType.BUILD_BUILDING], normalCastleLevelList[quest.questType][castleLevel][3] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			_UPVALUE2_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.UPGRADE_BUILDING], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "id"
			v.castleLevel[gQuestType.UPGRADE_BUILDING], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			self = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.DEFENCE], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			self = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.ATTACK_LORD], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			_UPVALUE2_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.ATTACK_THE_MONSTER], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "id"
			v.castleLevel[gQuestType.ATTACK_THE_MONSTER], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			self = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.ATTACK_MONSTER_NUM], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			self = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.UPGRADE_LORD], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			_UPVALUE2_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.GATHER_THE_RESOURCE], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "id"
			v.castleLevel[gQuestType.GATHER_THE_RESOURCE], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			_UPVALUE2_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.RESOURCE_OUTPUT], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "id"
			v.castleLevel[gQuestType.RESOURCE_OUTPUT], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			self = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.EXPLORE], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			self = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.RESEARCH_TECH_NUM], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			_UPVALUE3_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.TRAIN_THE_SOLDIERS], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "idmin"
			v.castleLevel[gQuestType.TRAIN_THE_SOLDIERS], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "idmax"
			v.castleLevel[gQuestType.TRAIN_THE_SOLDIERS], normalCastleLevelList[quest.questType][castleLevel][3] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			self = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.UNLOCK_EMPTY_AREA], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			_UPVALUE2_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.RESEARCH_THE_TECH], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "id"
			v.castleLevel[gQuestType.RESEARCH_THE_TECH], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			_UPVALUE2_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.EQUIPMENT], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "id"
			v.castleLevel[gQuestType.EQUIPMENT], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			self = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.PET_TOTAL_LEVEL], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			_UPVALUE2_ = normalCastleLevelList[quest.questType][castleLevel]
			v.castleLevel[gQuestType.UPGRADESTAR_BUILDING], normalCastleLevelList[quest.questType][castleLevel][1] = normalCastleLevelList[quest.questType][castleLevel], "id"
			v.castleLevel[gQuestType.UPGRADESTAR_BUILDING], normalCastleLevelList[quest.questType][castleLevel][2] = normalCastleLevelList[quest.questType][castleLevel], "aim"
			local conditionKey = v.castleLevel
			local _ENV, condition = gQuestType.UPGRADESTAR_BUILDING, gQuestType.UPGRADESTAR_BUILDING
			if not conditionKey[quest.questType] then
				local _ENV, list = conditionKey[quest.questType], conditionKey[quest.questType]
			end
			for i, v in ipairs(list) do
				condition[v] = quest.condition[i]
			end
			quest.condition = condition
		end
		self.lastQuest, _ENV = ipairs(questltconfig)
		for k, questID in pairs(lastQuest) do
			self.lastQuest[questID] = true
		end
		self.typeQuest = lastQuest
		if name == "questData" then
			return questData
		elseif name == "recommended" then
			return recommended
		elseif name == "normal" then
			return normal
		elseif name == "normalCastleLevelList" then
			return normalCastleLevelList
		elseif name == "lastQuest" then
			return self.lastQuest
		elseif name == "typeQuest" then
			return self.typeQuest
		end
	end
	questltCtrl:defineValue("questData", createData)
	questltCtrl:defineValue("recommended", createData)
	questltCtrl:defineValue("normal", createData)
	questltCtrl:defineValue("normalCastleLevelList", createData)
	questltCtrl:defineValue("lastQuest", createData)
	questltCtrl:defineValue("typeQuest", createData)
	questltCtrl:defineValue("operationQuestConfig", function()
		local operationQuestConfig = require_once("app." .. LocalTblPath .. ".config_server.operation_quest_config_ar")
		for questID, v in pairs(operationQuestConfig) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			v.condition.aim = v.condition[1]
			v.condition[1] = nil
		end
		self.operationQuestConfig = operationQuestConfig
		return self.operationQuestConfig
	end)
end
function questltCtrl:getRecommendedList()
	return self.recommended
end
function questltCtrl:getNormalList(questType)
	if questType then
		return self.normal[questType]
	else
		return self.normal
	end
end
function questltCtrl:getKindOfQuest(questID)
	if self:isOperationalQuest(questID) then
		return gQuestKind.OPERATION
	else
		return self:getProperty(self.questData, questID, "showType")
	end
end
function questltCtrl:getQuestType(questID)
	if self:isOperationalQuest(questID) then
		return gQuestType.OPERATION
	else
		return self:getProperty(self.questData, questID, "questType")
	end
end
function questltCtrl:getQuestSortType(questID)
	return self:getProperty(self.questData, questID, "newQuestType")
end
function questltCtrl:getCastleLevel(questID)
	return self:getProperty(self.questData, questID, "castleLevel")
end
function questltCtrl:getPreQuestID(questID)
	local preQuestID = self:getProperty(self.questData, questID, "preQuestID")
	if preQuestID and 0 < preQuestID then
		return preQuestID
	end
end
function questltCtrl:getCompleteCondition(questID)
	return self:getProperty(self.questData, questID, "condition")
end
function questltCtrl:getQuestAim(questID)
	if self:isOperationalQuest(questID) then
		return self:getAimOfOperatinQuest(questID)
	else
		local condition = self:getCompleteCondition(questID)
		return condition.aim
	end
end
function questltCtrl:getReward(questID)
	if self:isOperationalQuest(questID) then
		return self:getRewardOfOperationQuest(questID)
	else
		return self:getProperty(self.questData, questID, "reward")
	end
end
function questltCtrl:isLastQuest(questID)
	return self.lastQuest[questID] or self:getProperty(self.questData, questID, "questType") == nil
end
_UPVALUE18_, questltCtrl.getLastQuest = function(self, questType)
	return self.typeQuest[questType]
end, function(self, questType)
	return self.typeQuest[questType]
end
;(function(self, questType)
	return self.typeQuest[questType]
end)[1] = gQuestType.UNLOCK_EMPTY_AREA
;(function(self, questType)
	return self.typeQuest[questType]
end)[2] = gQuestType.BUILD_BUILDING
;(function(self, questType)
	return self.typeQuest[questType]
end)[3] = gQuestType.UPGRADE_BUILDING
;(function(self, questType)
	return self.typeQuest[questType]
end)[4] = gQuestType.ATTACK_LORD
;(function(self, questType)
	return self.typeQuest[questType]
end)[5] = gQuestType.DEFENCE
;(function(self, questType)
	return self.typeQuest[questType]
end)[6] = gQuestType.TRAIN_THE_SOLDIERS
;(function(self, questType)
	return self.typeQuest[questType]
end)[7] = gQuestType.UPGRADE_LORD
;(function(self, questType)
	return self.typeQuest[questType]
end)[8] = gQuestType.EQUIPMENT
;(function(self, questType)
	return self.typeQuest[questType]
end)[9] = gQuestType.RESOURCE_OUTPUT
;(function(self, questType)
	return self.typeQuest[questType]
end)[10] = gQuestType.EXPLORE
;(function(self, questType)
	return self.typeQuest[questType]
end)[11] = gQuestType.GATHER_THE_RESOURCE
;(function(self, questType)
	return self.typeQuest[questType]
end)[12] = gQuestType.ATTACK_MONSTER_NUM
;(function(self, questType)
	return self.typeQuest[questType]
end)[13] = gQuestType.ATTACK_THE_MONSTER
;(function(self, questType)
	return self.typeQuest[questType]
end)[14] = gQuestType.RESEARCH_TECH_NUM
;(function(self, questType)
	return self.typeQuest[questType]
end)[15] = gQuestType.RESEARCH_THE_TECH
;(function(self, questType)
	return self.typeQuest[questType]
end)[16] = gQuestType.PET_TOTAL_LEVEL
;(function(self, questType)
	return self.typeQuest[questType]
end)[17] = gQuestType.UPGRADESTAR_BUILDING
;(function(self, questType)
	return self.typeQuest[questType]
end)[18] = gQuestType.SOLDIER_RUSH
local (function(self, questType)
	return self.typeQuest[questType]
end)[19], normalQuestOrder = gQuestType.COMMAND_HALL, function(self, questType)
	return self.typeQuest[questType]
end
local _ENV, temp = gQuestType.UNLOCK_EMPTY_AREA, gQuestType.UNLOCK_EMPTY_AREA
for i, v in ipairs(normalQuestOrder) do
	temp[v] = i
end
normalQuestOrder = temp
function questltCtrl:getNormalQuestOrder(questType)
	return normalQuestOrder[questType]
end
function questltCtrl:jumpToFinishedById(questID)
	local questData = self:getCompleteCondition(questID)
	local questType = self:getQuestType(questID)
	if gQuestType.BUILD_BUILDING == questType or gQuestType.UPGRADE_BUILDING == questType or gQuestType.RESOURCE_OUTPUT == questType then
		local bid = questData.id
		local iid, count
		local lv = 1
		if gQuestType.BUILD_BUILDING == questType then
			lv = questData.level
			count = questData.aim
		end
		if gQuestType.UPGRADE_BUILDING == questType then
			lv = questData.aim
		end
		if gQuestType.RESOURCE_OUTPUT == questType then
			local buildLogic = include("buildLogic")
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			bid = buildLogic.getBuildID(bid)
			lv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			count = math.ceil(questData.aim / include("cityltCtrl").buildLvInfo(bid, lv, "output"))
		end
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = questData.aim / include("cityltCtrl").buildLvInfo(bid, lv, "output")
		;(questData.aim / include("cityltCtrl").buildLvInfo(bid, lv, "output")).bid = bid
		;(questData.aim / include("cityltCtrl").buildLvInfo(bid, lv, "output")).lv = lv
		;(questData.aim / include("cityltCtrl").buildLvInfo(bid, lv, "output")).count = count
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, questData.aim / include("cityltCtrl").buildLvInfo(bid, lv, "output"))
	elseif gQuestType.RESEARCH_TECH_NUM == questType or gQuestType.RESEARCH_THE_TECH == questType then
		local technologyId = questData.id or 0
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = mildGuideManager.starMildByNewPlayerQuestID
		mildGuideManager.starMildByNewPlayerQuestID.technologyId = technologyId
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESEARCH_TECHNOLOGY, mildGuideManager.starMildByNewPlayerQuestID)
	elseif gQuestType.TRAIN_THE_SOLDIERS == questType then
		local armyDesRead = include("armyDesRead")
		local bid = armyDesRead.getBuildID(questData.idmin)
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = mildGuideManager
		mildGuideManager.bid = bid
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, mildGuideManager)
	elseif gQuestType.UNLOCK_EMPTY_AREA == questType then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = mildGuideManager
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, mildGuideManager)
	elseif gQuestType.EQUIPMENT == questType then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = mildGuideManager
		mildGuideManager.id = questData.id
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.EQUIP, mildGuideManager)
	elseif gQuestType.OPERATION == questType then
		userSDKManager.showUserCenter()
	elseif gQuestType.ATTACK_THE_MONSTER == questType or gQuestType.ATTACK_MONSTER_NUM == questType then
		local lv = questData.level or 10
		_ENV = gNewPLayerTaskType.EQUIP
		gNewPLayerTaskType.EQUIP.lv = lv
		gNewPLayerTaskType.EQUIP.msg = include("questDesRead").getName(questID)
		gModuleMgr.sharedMgr("mildGuideManager"):starToWorldAndKillMonster(gNewPLayerTaskType.EQUIP)
	elseif gQuestType.GATHER_THE_RESOURCE == questType then
		_ENV = gModuleMgr.sharedMgr("mildGuideManager")
		gModuleMgr.sharedMgr("mildGuideManager").resid = questData.id
		gModuleMgr.sharedMgr("mildGuideManager").msg = include("questDesRead").getDes(questID)
		gModuleMgr.sharedMgr("mildGuideManager"):starToWorldAndCollectRes((gModuleMgr.sharedMgr("mildGuideManager")))
	elseif gQuestType.EXPLORE == questType then
		_ENV = gModuleMgr.sharedMgr("mildGuideManager")
		gModuleMgr.sharedMgr("mildGuideManager").msg = include("questDesRead").getName(questID)
		gModuleMgr.sharedMgr("mildGuideManager"):starToWorldAndExplore((gModuleMgr.sharedMgr("mildGuideManager")))
	elseif gQuestType.PET_TOTAL_LEVEL == questType then
		gModuleMgr.sharedMgr("mildGuideManager"):starToUnlockPet()
	elseif gQuestType.UPGRADESTAR_BUILDING == questType then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = questID
		questID.bid = questData.id
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILDSTAR_UPGRADE, questID)
	elseif gQuestType.DEFENCE == questType or gQuestType.UPGRADE_LORD == questType or gQuestType.UNLOCK_EMPTY_AREA == questType then
		SoraDShowMsgTip(i18n("chapter_task_tip_01"))
	elseif gQuestType.SOLDIER_RUSH == questType then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = i18n("chapter_task_tip_01")
		i18n("chapter_task_tip_01").bid = questData.id
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.FINISH_SOLDIER_RUSH, i18n("chapter_task_tip_01"))
	elseif gQuestType.COMMAND_HALL == questType then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = i18n("chapter_task_tip_01")
		i18n("chapter_task_tip_01").bid = questData.id
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.COMMAND_HALL_ATTACK_CITY, i18n("chapter_task_tip_01"))
	else
		_ENV = mildGuideManager
		mildGuideManager.msg = include("questDesRead").getName(questID)
		gModuleMgr.sharedMgr("mildGuideManager"):starToQuickToWorld(mildGuideManager)
	end
end
function questltCtrl:isOperationalQuest(questID)
	if questID then
		return self.operationQuestConfig[questID]
	end
end
function questltCtrl:getOperationQuestList()
	return self.operationQuestConfig
end
function questltCtrl:getRewardOfOperationQuest(questID)
	return self.operationQuestConfig[questID].reward
end
function questltCtrl:getAimOfOperatinQuest(questID)
	return self.operationQuestConfig[questID].condition.aim
end
function questltCtrl:getPriorityOfOperatinQuest(questID)
	return self.operationQuestConfig[questID].priority
end
function questltCtrl:getActiveRangeOfOperatinQuest(questID)
	local min = self.operationQuestConfig[questID].activeCondition[1]
	local max = self.operationQuestConfig[questID].activeCondition[2]
	return min, max
end
function questltCtrl:getFirstNormalQuestByCastleLevel(questType, castleLevel)
	local questlist = self.normalCastleLevelList[questType]
	if not questlist then
		return
	end
	if questlist[castleLevel] then
		return questlist[castleLevel][1]
	end
	local nearestCastleLevel
	for level, _ in pairs(questlist) do
		if castleLevel <= level then
			if not nearestCastleLevel then
				nearestCastleLevel = level
			elseif level < nearestCastleLevel then
				nearestCastleLevel = level
			end
		end
	end
	if nearestCastleLevel then
		return questlist[nearestCastleLevel][1]
	end
end
init()
return questltCtrl
