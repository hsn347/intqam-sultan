local _ENV, expostulationLogic
local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
function expostulationLogic.fixMass(queue)
	if not queue:isMainQueueFun() and queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		return kingdomMapCtrl.kingdomMapCell:optMapEvent4Mass(queue)
	end
	return queue
end
function expostulationLogic.getRealTroops()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local troops = kingdomMapCtrl:getMapEventList()
	local gametop, realTroops = kingdomMapCtrl, kingdomMapCtrl
	for _, v in ipairs(troops) do
		local queue = expostulationLogic.fixMass(v)
		local remainTime = queue:getStatusRemainTime()
		local totalTime = queue:getOrgStatusTotalTime()
		if 0 < remainTime and 0 < totalTime or remainTime <= 0 and totalTime <= 0 then
			table.insert(realTroops, queue)
		end
	end
	return realTroops
end
function expostulationLogic.checkDonateQueue()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local isJoin = allianceMgr:hasJoinAlliance()
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local queue = allianceScience:queryQueue(SCIENCE_DONATE_QUEUE)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local isLock = memberMgr:getOwnMember():getProperty("donateLock") == 1
	local isFull = false
	if isJoin then
		isFull = allianceScience:isSciLvFull()
	end
	local ret = isLock and queue and queue.timerNode.timer:getRemainTime() > 0
	return isJoin and not ret and not isInConquestWar and not isFull
end
function expostulationLogic.checkEpicAction()
	local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
	local curActon = epicWarCtrl:getCurExploreCount()
	return SoraDGetCastleLv() >= CASTLE_LV7_LIMITED and curActon >= SWEEP_COST_ACTION
end
function expostulationLogic.checkPrisonHero()
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	return heroJailCtrl:isCanExecutePrisonInMyJail()
end
function expostulationLogic.checkArena()
	local arenaCtrl = gametop.playertop_:getModule("arenaCtrl")
	local buildLogic = include("buildLogic")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local normal = arenaCtrl:getBattleInfo(gArenaBattleType.ARENA_LOCAL).remainTimes
	local global = arenaCtrl:getBattleInfo(gArenaBattleType.AREAN_GLOBAL).remainTimes
	local open = arenaCtrl:getBattleInfo(gArenaBattleType.AREAN_GLOBAL).arenaStatus == gActivityState.OPEN
	local isOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.ARENA_ACTIVITY)
	local isOwn = buildLogic.isOwnBuild(BUILDID.DRILL_GROUDS)
	print("检测玩家的技场挑战剩余次数", normal, global, open)
	if not isOpen or not isOwn then
		return false
	end
	if normal or global then
		print("normal or global")
		if normal and 0 < normal then
			return true
		end
		if global and 0 < global and open then
			return true
		end
		return false
	else
		return false
	end
end
function expostulationLogic.jumpToArena()
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.DRILL_ARENA, nil)
	SoraDRemoveAllPanelFromManager()
end
function expostulationLogic.jumpToPrison()
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.HERO_PRISON, nil)
	SoraDRemoveAllPanelFromManager()
end
function expostulationLogic.jumpToDonate()
	if GLOBAL_GAME_ALLIANCE_MODE then
		uiManager:show("AllianceScience")
	else
		SoraDCreatePanel("allianceScienceView"):show()
	end
end
function expostulationLogic.jumpToEpic()
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.EPIC_WAR, nil)
	SoraDRemoveAllPanelFromManager()
end
function expostulationLogic.checkArmyQueue()
	local buildLogic = include("buildLogic")
	local totalTroop = buildLogic.getExpQueueCount().total
	local troops = expostulationLogic.getRealTroops()
	return totalTroop > table.nums(troops)
end
function expostulationLogic.jumpToWorld()
	mildGuideManager = nil
	mildGuideManager:starToWorldAndKillMonster(nil)
end
function expostulationLogic.checkPetExp()
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	return petCtrl.feedInfo.curFreeFeed < PET_FEED_FREE_TIMES_LIMIT
end
function expostulationLogic.jumpToPet()
	mildGuideManager = nil
	;(nil).tipKey = "OpPet"
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_PET, nil)
end
function expostulationLogic.checkTrainQueue()
	local ret = false
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	gametop, gametop = "cityCtrl", gametop.playertop_
	;("cityCtrl").bid = BUILDID.CHARIOT_PLANT
	gametop, gametop.playertop_[1], ("cityCtrl").qType = "cityCtrl", "cityCtrl", gQueueTypeDef.chariot_plant_queue
	;("cityCtrl").bid = BUILDID.STABLES
	gametop, gametop.playertop_[2], ("cityCtrl").qType = "cityCtrl", "cityCtrl", gQueueTypeDef.stables_queue
	;("cityCtrl").bid = BUILDID.RANGE
	gametop, gametop.playertop_[3], ("cityCtrl").qType = "cityCtrl", "cityCtrl", gQueueTypeDef.range_queue
	;("cityCtrl").bid = BUILDID.BARRACKS
	gametop.playertop_[4], ("cityCtrl").qType = "cityCtrl", gQueueTypeDef.barracks_queue
	local bidList = gametop.playertop_
	for k, v in ipairs(bidList) do
		local buildCell = cityCtrl:getBuildCell(v.bid, 0)
		local queue = queueCtrl:queryQueue(v.qType)
		local buildState
		if buildCell then
			buildState = tonumber(buildCell.info.state)
			if buildState == BUILD_STATE.NORMAL then
				local buildLogic = include("buildLogic")
				buildState = tonumber(buildLogic.getBuildStateByBid(v.bid))
			end
		end
		if buildCell and buildState == BUILD_STATE.NORMAL and not queue then
			ret = true
			break
		end
	end
	return ret
end
function expostulationLogic.jumpToCamp(isForce)
	_UPVALUE4_ = nil
	;(nil)[1] = BUILDID.CHARIOT_PLANT
	;(nil)[2] = BUILDID.STABLES
	;(nil)[3] = BUILDID.RANGE
	local (nil)[4], bidList = BUILDID.BARRACKS, nil
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local bid
	for k, v in ipairs(bidList) do
		local buildCell = cityCtrl:getBuildCell(v, 0)
		local buildState
		if buildCell then
			buildState = tonumber(buildCell.info.state)
			if buildState == BUILD_STATE.NORMAL then
				local buildLogic = include("buildLogic")
				buildState = tonumber(buildLogic.getBuildStateByBid(v))
			end
		end
		if buildCell and buildState == BUILD_STATE.NORMAL then
			bid = v
			break
		end
	end
	bid = isForce and BUILDID.CHARIOT_PLANT or bid
	if expostulationLogic.checkTrainQueue() and bid then
		_ENV = nil
		;(nil).bid = bid
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
end
function expostulationLogic.checkFreeExplore()
	local pyramidCtrl = gametop.playertop_:getModule("pyramidCtrl")
	local freeTimes = pyramidCtrl:getFreeTime() or 0
	return 0 < freeTimes
end
function expostulationLogic.jumpToPyramid()
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.PYRAMID, nil)
end
function expostulationLogic.checkFreeWish()
	local treviFountainCtrl = gametop.playertop_:getModule("treviFountainCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildCell = cityCtrl:getBuildCell(BUILDID.WISHING_WELL, 0)
	return buildCell and 0 < treviFountainCtrl:getTreviFountainData().multipleTimes
end
function expostulationLogic.jumpToWish()
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, nil)
end
function expostulationLogic.checkBuildQueue()
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local rechargeQueue = cityCtrl:getCurCity():queryQueue(gQueueTypeDef.charge_build_queue)
	local chargeQueue = queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)
	return not queueCtrl:queryQueue(gQueueTypeDef.free_build_queue) or rechargeQueue and not chargeQueue
end
function expostulationLogic.jumpToBuild()
	local questCtrl = gametop.playertop_:getModule("questCtrl")
	local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local quest = questCtrl:getPerformingGuideQuest()
	if quest then
		local questID = quest.questID
		local questType = questltCtrl:getQuestType(questID)
		if gQuestType.BUILD_BUILDING == questType or gQuestType.UPGRADE_BUILDING == questType or gQuestType.RESOURCE_OUTPUT == questType then
			questltCtrl:jumpToFinishedById(questID)
		end
	else
		if cityCtrl:getEmptyArea() then
			gametop = questltCtrl
			questltCtrl.lv = 1
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, questltCtrl)
			return
		end
		local bid, iid, lv = cityCtrl:getUnFullLvBuild()
		if bid then
			gametop = nil
			;(nil).bid = bid
			;(nil).iid = iid
			;(nil).lv = lv
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, nil)
			return
		end
	end
end
function expostulationLogic.checkTechQueue()
	local ret = false
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local buildCell = cityCtrl:getBuildCell(BUILDID.COLLEGE, 0)
	local isFull = technologyCtrl:checkIsFullTech()
	if buildCell and tonumber(buildCell.info.state) == BUILD_STATE.NORMAL and not queueCtrl:queryQueue(gQueueTypeDef.technology_upgrade_queue) and not isFull then
		ret = true
	end
	return ret
end
function expostulationLogic.jumpToCollege()
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESEARCH_TECHNOLOGY, nil)
end
function expostulationLogic.checkWounded()
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	return armyCtrl:getTotalWoundedArmyCount() > 0
end
function expostulationLogic.jumpToHospital()
	mildGuideManager:starToHospital()
end
function expostulationLogic.checkUnlockArea()
	local ret = false
	local index
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local cityCell = cityCtrl:getCurCity()
	local openAreaList = cityCell.areaList
	local opengroundinfo = require("app." .. LocalTblPath .. ".config_server.opengroundinfo")
	if #openAreaList < #opengroundinfo then
		for k, v in ipairs(opengroundinfo) do
			if not SoraDisInList(v.areaid, openAreaList) and SoraDGetCastleLv() >= v.preCond[2] then
				ret = true
				index = v.areaid
				break
			end
		end
	end
	return ret, index
end
_ENV, _ENV, expostulationLogic.jumpToOutArea = nil, function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end, function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end
;(nil).des = "proposal_text_01"
;(nil).condition = expostulationLogic.checkWounded
;(nil).jump = expostulationLogic.jumpToHospital
;(nil).rank = 1
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[1], (nil).lv = nil, nil, 1
;(nil).des = "proposal_text_02"
;(nil).condition = expostulationLogic.checkUnlockArea
;(nil).jump = expostulationLogic.jumpToOutArea
;(nil).rank = 2
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[2], (nil).lv = nil, nil, 2
;(nil).des = "proposal_text_03"
;(nil).condition = expostulationLogic.checkTechQueue
;(nil).jump = expostulationLogic.jumpToCollege
;(nil).rank = 3
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[3], (nil).lv = nil, nil, 4
;(nil).des = "proposal_text_04"
;(nil).condition = expostulationLogic.checkBuildQueue
;(nil).jump = expostulationLogic.jumpToBuild
;(nil).rank = 4
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[4], (nil).lv = nil, nil, 1
;(nil).des = "proposal_text_05"
;(nil).condition = expostulationLogic.checkFreeWish
;(nil).jump = expostulationLogic.jumpToWish
;(nil).rank = 5
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[5], (nil).lv = nil, nil, 11
;(nil).des = "proposal_text_06"
;(nil).condition = expostulationLogic.checkFreeExplore
;(nil).jump = expostulationLogic.jumpToPyramid
;(nil).rank = 6
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[6], (nil).lv = nil, nil, 13
;(nil).des = "proposal_text_07"
;(nil).condition = expostulationLogic.checkTrainQueue
;(nil).jump = expostulationLogic.jumpToCamp
;(nil).rank = 7
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[7], (nil).lv = nil, nil, 1
;(nil).des = "prison_text_01"
;(nil).condition = expostulationLogic.checkPrisonHero
;(nil).jump = expostulationLogic.jumpToPrison
;(nil).rank = 8
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[8], (nil).lv = nil, nil, 16
;(nil).des = "proposal_text_13"
;(nil).condition = expostulationLogic.checkArena
;(nil).jump = expostulationLogic.jumpToArena
;(nil).rank = 9
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[9], (nil).lv = nil, nil, 12
;(nil).des = "proposal_text_08"
;(nil).condition = expostulationLogic.checkPetExp
;(nil).jump = expostulationLogic.jumpToPet
;(nil).rank = 10
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[10], (nil).lv = nil, nil, 4
;(nil).des = "proposal_text_09"
;(nil).condition = expostulationLogic.checkArmyQueue
;(nil).jump = expostulationLogic.jumpToWorld
;(nil).rank = 11
_ENV, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[11], (nil).lv = nil, nil, 2
;(nil).des = "proposal_text_10"
;(nil).condition = expostulationLogic.checkDonateQueue
;(nil).jump = expostulationLogic.jumpToDonate
;(nil).rank = 12
expostulationLogic.jumpTaskDef, (function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end)[12], (nil).lv = function()
	local ret, index = expostulationLogic.checkUnlockArea()
	if ret and index then
		expostulationLogic = nil
		;(nil).index = index
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_AREA, nil)
	end
end, nil, 8
function expostulationLogic.getExpostulation()
	local expostulation
	local index = 1
	while index <= #expostulationLogic.jumpTaskDef do
		index = index + 1
		local _dex = GLOBAL_EXPOSTULATION_INDEX % #expostulationLogic.jumpTaskDef + 1
		GLOBAL_EXPOSTULATION_INDEX = _dex
		local data = expostulationLogic.jumpTaskDef[_dex]
		if data.condition() and SoraDGetCastleLv() >= data.lv then
			expostulation = data
			break
		end
	end
	return expostulation
end
return expostulationLogic
