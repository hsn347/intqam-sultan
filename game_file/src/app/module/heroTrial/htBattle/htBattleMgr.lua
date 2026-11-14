local gametop = gModuleMgr.getObject("gametop")
local htPointMgr = include("htPointMgr")
local htMapMgr = include("htMapMgr")
local heroTrialltCtrl = include("heroTrialltCtrl")
local htMap = include("htMap")
local htLogMgr = include("htLogMgr")
local _ENV, htBattleMgr = "htLogMgr", "htLogMgr"
local isInit = false
function htBattleMgr.init(battleData)
	if isInit then
		printError("heroTrial log: repeat ot init the htBattleMgr!")
		return
	end
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	htBattleMgr.autoStatus = battleData.auto
	htBattleMgr.trialStatus = battleData.trialStatus
	if htBattleMgr.trialStatus then
		local trialMapID = battleData.trialMID
		local trialStageID = battleData.trialSID
		local defSoldiers = battleData.defSoldiers
		htBattleMgr.curTrialMap = htMap.new(trialMapID, trialStageID, defSoldiers)
		htBattleMgr.trialSoldiers = battleData.soldiers
		htBattleMgr.marchSoldiers = battleData.marchSoldiers
		local data = battleData.mvTimeData
		if "table" == type(data) and next(data) then
			local bTime = data.bTime
			local mvTime = serviceFunctions.systemTime() - bTime
			local totalTime = data.totalTime
			local timeData = data.SUList[#data.SUList]
			if "table" == type(timeData) then
				local remainTimeOfMarch = timeData.time - mvTime
				if 0 < remainTimeOfMarch then
					htBattleMgr.setMVTimeData(data, mvTime)
					queueCtrl:removeQueue(gQueueTypeDef.trial_march)
					isInit = nil
					;(nil).stageID = trialStageID
					;(nil).soldiers = htBattleMgr.marchSoldiers
					queueCtrl:addQueue(gQueueTypeDef.trial_march, bTime, totalTime, remainTimeOfMarch, nil)
				end
			end
		end
	end
	queueCtrl:addEventListener(tostring(gQueueTypeDef.auto_trial_prepare), htBattleMgr.autoQueueFinishListener)
	queueCtrl:addEventListener(tostring(gQueueTypeDef.trial_march), htBattleMgr.marchQueueFinishListener)
end
function htBattleMgr.logout()
	htBattleMgr.reset()
end
function htBattleMgr.whetherTrialCanOpen(mapID)
	if not htMapMgr.whetherMapUnlock(mapID) then
		htBattleMgr.trialStatus = false
		return gErrDef.Err_HT_MAP_NOT_UNLOCK
	end
	local costPoint = heroTrialltCtrl.getCostPointOfTrial()
	if not htPointMgr.isPointEnough(costPoint) then
		htBattleMgr.trialStatus = false
		return gErrDef.Err_HT_TRIAL_POINT_NOT_ENOUGH
	end
	if htBattleMgr.trialStatus and mapID == htBattleMgr.curTrialMap:getMapID() then
		return gErrDef.Err_HT_REPEAT_TO_OPEN_TRIAL
	end
	return gErrDef.Err_None
end
function htBattleMgr.openTrial(mapID, soldiers)
	htBattleMgr.trialStatus = true
	htBattleMgr.trialSoldiers = soldiers
	htBattleMgr.curTrialMap = htMap.new(mapID)
	htLogMgr.reset(mapID)
	return gErrDef.Err_None
end
function htBattleMgr.whetherTrialCanQuit()
	if not htBattleMgr.trialStatus then
		return gErrDef.Err_HT_NOT_IN_TRIAL
	end
	return gErrDef.Err_None
end
function htBattleMgr.quitTrial()
	htBattleMgr.reset()
	return gErrDef.Err_None
end
function htBattleMgr.whetherCanGeneralTrial(stageID, soldiers)
	if not htBattleMgr.trialStatus then
		return gErrDef.Err_HT_NOT_IN_TRIAL
	end
	local mapID = htBattleMgr.curTrialMap:getMapID()
	if not heroTrialltCtrl.whetherStageInMap(stageID, mapID) then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	local ret = htBattleMgr.curTrialMap:whetherStageAttack(stageID)
	if gErrDef.Err_None ~= ret then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	local matchSoldiers = function(soldiers)
		return true
	end
	if not matchSoldiers(soldiers) then
		htBattleMgr.soldiersStatus = false
		return gErrDef.Err_HT_SOLDIER_NOT_ENOUGH
	end
	return gErrDef.Err_None
end
function htBattleMgr.generalTrial(stageID, soldiers, bTime, marchTime)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	gametop = nil
	;(nil).stageID = stageID
	;(nil).soldiers = soldiers
	queueCtrl:addQueue(gQueueTypeDef.trial_march, bTime, marchTime, marchTime, nil)
	return gErrDef.Err_None
end
function htBattleMgr.finishBattle(ret, stageID, finish, soldiers, deSoldiers)
	htBattleMgr.trialSoldiers = soldiers
	if ret then
		htMapMgr.completeStage(stageID)
		if htBattleMgr.curTrialMap then
			htBattleMgr.curTrialMap:completeStage(stageID)
		end
	elseif htBattleMgr.curTrialMap then
		htBattleMgr.curTrialMap:updateSoldiers(deSoldiers)
	end
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:removeQueue(gQueueTypeDef.trial_march)
	htBattleMgr.mvTimeData = nil
	if finish then
		htBattleMgr.quitTrial()
	end
end
function htBattleMgr.whetherCanAutoTrial(stageID, soldiers)
	if htBattleMgr.autoStatus then
		return gErrDef.Err_HT_REPEAT_TO_AUTO_TRIAL
	end
	return htBattleMgr.whetherCanGeneralTrial(stageID, soldiers)
end
function htBattleMgr.openAutoTrial()
	htBattleMgr.autoStatus = true
	return gErrDef.Err_None
end
function htBattleMgr.autoTrial(bTime, preTime)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:addQueue(gQueueTypeDef.auto_trial_prepare, bTime, preTime, preTime)
	return gErrDef.Err_None
end
function htBattleMgr.stopAutoTrial()
	if not htBattleMgr.trialStatus then
		return
	end
	if not htBattleMgr.autoStatus then
		return
	end
	htBattleMgr.autoStatus = false
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:removeQueue(gQueueTypeDef.auto_trial_prepare)
	return gErrDef.Err_None
end
function htBattleMgr.getMapOfCurTrial()
	return htBattleMgr.curTrialMap
end
function htBattleMgr.getSoldiersList()
	local _ENV, ret
	if "table" ~= type(htBattleMgr.trialSoldiers) or not next(htBattleMgr.trialSoldiers) then
		return
	end
	for k, v in pairs(htBattleMgr.trialSoldiers) do
		_ENV = nil
		;(nil).id = tonumber(k)
		;(nil).num = v
		table.insert(ret, nil)
	end
	table.sort(ret, function(l, r)
		local lSID = tonumber(l.id) % 1000
		local rSID = tonumber(r.id) % 1000
		local lSType, lSLv = string.match(lSID, "(%d)(%d%d)")
		lSType = tonumber(lSType)
		lSLv = tonumber(lSLv)
		local rSType, rSLv = string.match(rSID, "(%d)(%d%d)")
		rSType = tonumber(rSType)
		rSLv = tonumber(rSLv)
		if lSLv == rSLv then
			return lSType < rSType
		else
			return lSLv > rSLv
		end
	end)
	if next(ret) then
		return ret
	end
end
function htBattleMgr.speedUp(reduceTime)
	if "number" ~= type(reduceTime) or reduceTime <= 0 then
		print("HT EXCEPTION: reduceTime is not a number or reduceTime <= 0. reduceTime = ", reduceTime)
		return
	end
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	if not queueCtrl:queryQueue(gQueueTypeDef.trial_march) then
		print("HT EXCEPTION: not found queue of trial_march.")
		return
	end
	queueCtrl:updateLeftTime(gQueueTypeDef.trial_march, -reduceTime)
end
function htBattleMgr.setMVTimeData(data, moveTime)
	local htBattleMgr, ret
	ret.moveSpan = data.SUList
	ret.currentMoveTime = moveTime or 0
	htBattleMgr.mvTimeData = ret
	return ret
end
function htBattleMgr.getMVTimeData()
	return htBattleMgr.mvTimeData
end
function htBattleMgr.dump()
	if htBattleMgr.trialStatus then
		htBattleMgr.curTrialMap:dump()
	end
end
function htBattleMgr.reset()
	htBattleMgr.trialStatus = false
	htBattleMgr.autoStatus = false
	htBattleMgr.curTrialMap = nil
	htBattleMgr.trialSoldiers = nil
	htBattleMgr.mvTimeData = nil
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:removeQueue(gQueueTypeDef.auto_trial_prepare)
	queueCtrl:removeQueue(gQueueTypeDef.trial_march)
end
function htBattleMgr.autoQueueFinishListener(event)
	local queuetype = tonumber(event.name)
	local data = event.data
end
function htBattleMgr.marchQueueFinishListener(event)
	local queuetype = tonumber(event.name)
	local data = event.data
	htBattleMgr.mvTimeData = nil
end
return htBattleMgr
