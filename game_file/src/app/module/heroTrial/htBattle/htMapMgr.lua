local heroTrialltCtrl = include("heroTrialltCtrl")
local _ENV, htMapMgr = "heroTrialltCtrl", "heroTrialltCtrl"
local isInit = false
htMapMgr.lastStageID = nil
function htMapMgr.init(mapInfo)
	if isInit then
		printError("heroTrial log: repeat ot init the htMapMgr!")
		return
	end
	local stageID = mapInfo.lastSID
	htMapMgr.lastStageID = htMapMgr.compatibleWithLastStageID(stageID)
	local lastCOMPSID = mapInfo.lastCOMPSID
	htMapMgr.lastCOMPSID = htMapMgr.compatibleWithLastStageID(lastCOMPSID)
end
function htMapMgr.logout()
	htMapMgr.lastStageID = nil
	htMapMgr.lastCOMPSID = nil
end
function htMapMgr.completeStage(stageID)
	if stageID == nil or htMapMgr.lastStageID == nil then
		return false
	elseif stageID < htMapMgr.lastStageID then
		return true
	elseif stageID == htMapMgr.lastStageID then
		local nextStageID = heroTrialltCtrl.getNextStage(stageID)
		if nextStageID then
			htMapMgr.lastStageID = nextStageID
		end
		htMapMgr.lastCompleteStageID = stageID
		return true
	elseif stageID > htMapMgr.lastStageID then
		return false
	end
end
function htMapMgr.isAllPass()
	return htMapMgr.getLastCompleteStage() >= heroTrialltCtrl.getLastStageID()
end
function htMapMgr.getLastUnlockMap()
	if htMapMgr.lastStageID then
		return heroTrialltCtrl.getMapIDOfStage(htMapMgr.lastStageID)
	end
	return heroTrialltCtrl.getInitFirst()
end
function htMapMgr.isAreaUnlock(areaId)
	local lastUnlockMap = htMapMgr.getLastUnlockMap()
	local unlockArea = heroTrialltCtrl.getAreaByMap(lastUnlockMap)
	return areaId <= unlockArea
end
function htMapMgr.isAreaPass(areaId)
	return htMapMgr.getLastCompleteStage() >= heroTrialltCtrl.getLastStageIDOfArea(areaId)
end
function htMapMgr.getLastUnlockStage()
	return htMapMgr.lastStageID
end
function htMapMgr.getLastCompleteStage()
	return htMapMgr.lastCOMPSID
end
function htMapMgr.setLastCompleteStage(lastCOMPSID)
	htMapMgr.lastCOMPSID = lastCOMPSID
end
function htMapMgr.whetherMapUnlock(mapID)
	local lastMapID = htMapMgr.getLastUnlockMap()
	if mapID <= lastMapID then
		return true
	end
	return false
end
function htMapMgr.whetherStageUnlock(stageID)
	local lastStageID = htMapMgr.getLastUnlockStage()
	if stageID <= lastStageID then
		return true
	end
	return false
end
function htMapMgr.dump()
end
function htMapMgr.getIsPass(mapId)
	local lastCompleteStage = htMapMgr.getLastCompleteStage()
	if not lastCompleteStage or lastCompleteStage <= 0 then
		return false
	end
	local lastMapId = heroTrialltCtrl.getMapIDOfStage(lastCompleteStage)
	if mapId > lastMapId then
		return false
	end
	if mapId == lastMapId and not heroTrialltCtrl.isLastStageOfMap(lastCompleteStage) then
		return false
	end
	return true
end
function htMapMgr.compatibleWithLastStageID(stageID)
	if nil == stageID or heroTrialltCtrl.isStageID(stageID) then
		return stageID
	end
	local lastStageID = heroTrialltCtrl.getLastStage()
	if stageID > lastStageID then
		return lastStageID
	end
	return stageID
end
return htMapMgr
