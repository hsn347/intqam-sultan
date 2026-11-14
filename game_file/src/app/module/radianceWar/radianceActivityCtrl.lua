local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local radianceWarRead = include("radianceWarRead")
local radianceActivityCtrl = class("radianceActivityCtrl", gamemodulec)
local timerList = gModuleMgr.getObject("timerList")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local radianceWarDef = include("radianceWarDef")
local RADIANCE_WAR_STATE = radianceWarDef.RADIANCE_WAR_STATE
local TASK_TYPE = radianceWarDef.TASK_TYPE
function radianceActivityCtrl:isActiveOpen()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
	local remainsWarStatus = param.curState
	if remainsWarStatus == _G.ACTIVITY_STATE.ACTIVE or remainsWarStatus == _G.ACTIVITY_STATE.SETTLE then
		return true
	end
	return false
end
function radianceActivityCtrl:getWarStatusTime_imp(curState)
	if not self.radianceWarStateInfo then
		local RADIANCE_WAR_STATE, timeConfig = self.radianceWarStateInfo, self.radianceWarStateInfo
	end
	local endTime
	if curState == RADIANCE_WAR_STATE.MATCH then
		endTime = timeConfig.resultTime
	elseif curState == RADIANCE_WAR_STATE.RESULT then
		endTime = timeConfig.battleTime
	elseif curState == RADIANCE_WAR_STATE.BATTLE then
		endTime = timeConfig.settleTime
	elseif curState == RADIANCE_WAR_STATE.FINISH then
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
		if param and param.timeConfig then
			endTime = param.timeConfig.finishTime
		end
	end
	local sysTime = serviceFunctions.systemTime()
	if endTime and endTime > sysTime then
		return endTime - sysTime
	end
	return 0
end
function radianceActivityCtrl:getWarStatusBattleEndTime()
	if not self.radianceWarStateInfo then
		local _UPVALUE0_, timeConfig = self.radianceWarStateInfo, self.radianceWarStateInfo
	end
	return timeConfig.settleTime or 0
end
function radianceActivityCtrl:getWarMapId()
	return self.radianceWarStateInfo and self.radianceWarStateInfo.mapId
end
function radianceActivityCtrl:getReceiveStatusAndNum(activityID)
	local has = true
	if not self:getTaskReceiveStatusAndNum(1) and not self:getTaskReceiveStatusAndNum(2) then
		local activityExchangeMallCtrl = _G.SoraDGetCtrl("activityExchangeMallCtrl")
		local retShop = activityExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
		if not retShop then
			local lightShiningCtrl = _G.SoraDGetCtrl("lightShiningCtrl")
			local retShine = lightShiningCtrl:getReceiveStatusAndNum()
			if not retShine then
				local radianceWarCtrl = _G.SoraDGetCtrl("radianceWarCtrl")
				local hasUnReadResWarLog = radianceWarCtrl:isHasUnReadResWarLog()
				if not hasUnReadResWarLog then
					has = false
				end
			end
		end
	end
	return has, -1
end
function radianceActivityCtrl:getActivityStatusTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
	local endTime
	local remainsWarStatus = param.curState
	if not param.timeConfig then
		local gametop, timeConfig = param.timeConfig, param.timeConfig
	end
	if remainsWarStatus == _G.ACTIVITY_STATE.PREPARE then
		endTime = timeConfig.prepareTime
	elseif remainsWarStatus == _G.ACTIVITY_STATE.ACTIVE then
		endTime = timeConfig.finishTime
	elseif remainsWarStatus == _G.ACTIVITY_STATE.SETTLE then
		endTime = timeConfig.finishTime
	elseif remainsWarStatus == _G.ACTIVITY_STATE.FINISH then
		endTime = timeConfig.finishTime
	end
	local sysTime = serviceFunctions.systemTime()
	if endTime and endTime > sysTime then
		return endTime - sysTime
	end
	return 0
end
function radianceActivityCtrl:getActivitySeasonRound()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
	local round = param and param.round or 0
	return round
end
function radianceActivityCtrl:getActivitySeasonTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
	local beginTime = 0
	local endTime = 0
	if param and param.timeConfig then
		beginTime = param.timeConfig.activeTime
		endTime = param.timeConfig.finishTime
	end
	local beginTimeStr = os.date("!%Y.%m.%d", beginTime)
	local endTimeStr = os.date("!%Y.%m.%d", endTime)
	return beginTimeStr .. " - " .. endTimeStr
end
function radianceActivityCtrl:getActivitySeasonTitle()
	local round = self:getActivitySeasonRound()
	_ENV = nil
	;(nil).num = round
	return i18n("remains_text_02", nil)
end
function radianceActivityCtrl:getWarStatus()
	return self.radianceWarStateInfo.cruState
end
function radianceActivityCtrl:getWarStatusTime()
	local curState = self.radianceWarStateInfo.cruState
	return self:getWarStatusTime_imp(curState)
end
function radianceActivityCtrl:isWarBattle()
	local curState = self.radianceWarStateInfo.cruState
	return curState == RADIANCE_WAR_STATE.BATTLE
end
function radianceActivityCtrl:isWarFinish()
	local curState = self.radianceWarStateInfo.cruState
	return curState == RADIANCE_WAR_STATE.FINISH
end
function radianceActivityCtrl:isWarMatchBegin()
	local curState = self.radianceWarStateInfo.cruState
	return curState == RADIANCE_WAR_STATE.MATCH
end
function radianceActivityCtrl:getQuestData(taskType)
	local questComponent = self.questComponentMap[taskType]
	return self:getSortList(taskType, questComponent and questComponent:getQuestData())
end
function radianceActivityCtrl:getTaskReceiveStatusAndNum(taskType)
	local questComponent = self.questComponentMap[taskType]
	if questComponent then
		return questComponent:getReceiveStatusAndNum()
	end
	return false, 0
end
function radianceActivityCtrl:getNecklaceList()
	dump(self.neckLaceList, "radianceActivityCtrl", 10)
	return self.neckLaceList
end
function radianceActivityCtrl:getHistoryList(...)
	return self.historyInfoList
end
function radianceActivityCtrl:getExchangeNum(itemID)
	return tonumber(itemID) == 1608 and self.radianceWarExplot or self.radianceWarStarlight
end
function radianceActivityCtrl:getWarAmberPoint()
	return self.radianceWarAmberPoint
end
function radianceActivityCtrl:getWarTotalAmberPoint()
	return self.seasonTotalAmberPoint
end
function radianceActivityCtrl:isRadianceWarEnd()
	return self.isBettleEnd
end
function radianceActivityCtrl:resetRadianceWarEnd()
	self.isBettleEnd = false
end
function radianceActivityCtrl:updateTimer()
	if self:isWarBattle() then
		self:addTimer()
	else
		self:stopTimer()
	end
end
function radianceActivityCtrl:addTimer()
	self:stopTimer()
	local dispatchQueueEvent = function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		;(nil).activityID = gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_RADIANCE_WAR_STATUS_ACTIVITY"
		SoraDSendMessage(nil)
	end
	local lefttime
	local radianceWarUtil = include("radianceWarUtil")
	if radianceWarUtil.checkEnterWarByTime() then
		lefttime = radianceWarUtil.getWarLeftTime() + 1
		print(lefttime, "lefttime------1")
	else
		lefttime = radianceWarUtil.getWarOpenTime()
		print(lefttime, "lefttime------2")
	end
	if 0 <= lefttime then
		local ok, node = timerList:createTimer(lefttime, _G.timerHandler(dispatchQueueEvent))
		if ok then
			self.timerNode = node
		end
	end
end
function radianceActivityCtrl:stopTimer()
	if self.timerNode then
		timerList:cancelTimer(self.timerNode)
		self.timerNode = nil
	end
end
function radianceActivityCtrl:reqStateData()
	print("radianceActivityCtrl:reqreqStateData")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_STATE_DATA)
end
function radianceActivityCtrl:reqMatchResult()
	print("radianceActivityCtrl:reqreqMatchResult")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_MATCH_RESULT)
end
function radianceActivityCtrl:reqEnterBattlefield(army)
	dump("radianceActivityCtrl:reqreqEnterBattlefield", army, 10)
	_ENV = nil
	;(nil).army = army
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_ENTER_BATTLEFIELD, nil)
end
function radianceActivityCtrl:reqQuitBattlefield()
	print("radianceActivityCtrl:reqreqQuitBattlefield")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_QUIT_BATTLEFIELD)
end
function radianceActivityCtrl:reqGetReward(data)
	print("radianceActivityCtrl:reqGetReward")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_CLAIM_QUEST_REWARD, data)
end
function radianceActivityCtrl:reqInitInfo()
	print("radianceActivityCtrl:reqInitInfo")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_INIT_DATA)
end
function radianceActivityCtrl:reqGetNeckLaceList()
	print("radianceActivityCtrl:reqGetNeckLaceList")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_NECKLACE_LIST, nil)
end
function radianceActivityCtrl:reqPlayerKillRank()
	print("radianceActivityCtrl:reqPlayerKillRank")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_EXPLOIT_RANK, nil)
end
function radianceActivityCtrl:reqTeamGateRank()
	print("radianceActivityCtrl:reqTeamGateRank")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_TEAM_EXPLOIT_RANK, nil)
end
function radianceActivityCtrl:reqTeamPalaceRank()
	print("radianceActivityCtrl:reqTeamPalaceRank")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_TEAM_OCCUPY_PALACE_RANK, nil)
end
function radianceActivityCtrl:reqKindomPalaceRank()
	print("radianceActivityCtrl:reqKindomPalaceRank")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_KINGDOM_OCCUPY_PALACE_RANK, nil)
end
function radianceActivityCtrl:reqKindomPalacePlayerRank()
	print("radianceActivityCtrl:reqKindomPalacePlayerRank")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_OCCUPY_PALACE_RANK, nil)
end
function radianceActivityCtrl:reqHistory()
	print("radianceActivityCtrl:reqHistory")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_GET_HISTORY_RECORD, nil)
end
function radianceActivityCtrl:reqExchangeAmberPoint()
	print("radianceActivityCtrl:reqExchangeAmberPoint")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_EXCHANGE_AMBER_POINT)
end
function radianceActivityCtrl:reqPlayerKillFcRank(type, count)
	print("radianceActivityCtrl:reqPlayerKillFcRank")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	;(nil).type = type
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_KILL_FC_RANK, nil)
end
function radianceActivityCtrl:ctor(properties)
	radianceActivityCtrl.super.ctor(self, properties)
end
function radianceActivityCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_STATE_DATA, handler(self, self.reqStateDataRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_MATCH_RESULT, handler(self, self.reqMatchResultRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_ENTER_BATTLEFIELD, handler(self, self.reqEnterBattlefieldRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_QUIT_BATTLEFIELD, handler(self, self.reqQuitBattlefieldRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_INIT_DATA, handler(self, self.reqInitInfoRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_CLAIM_QUEST_REWARD, handler(self, self.reqGetRewardRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_NECKLACE_LIST, handler(self, self.reqGetNeckLaceListRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_EXPLOIT_RANK, handler(self, self.reqPlayerKillRankRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_TEAM_EXPLOIT_RANK, handler(self, self.reqTeamGateRankRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_TEAM_OCCUPY_PALACE_RANK, handler(self, self.reqTeamPalaceRankRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_KINGDOM_OCCUPY_PALACE_RANK, handler(self, self.reqKindomPalaceRankRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_GET_HISTORY_RECORD, handler(self, self.reqHistoryRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_EXCHANGE_AMBER_POINT, handler(self, self.exchangeAmberPointRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_OCCUPY_PALACE_RANK, handler(self, self.reqPlayerOccupyPlaceRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_KILL_FC_RANK, handler(self, self.reqPlayerKillFcRankRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.RADIANCE_WAR, handler(self, self.onMsg))
	self:resetData()
	self:reqInitInfo()
end
function radianceActivityCtrl:resetData()
	self.radianceWarStateInfo, RADIANCE_WAR_STATE = nil, nil
	self.historyInfoList, RADIANCE_WAR_STATE, self.neckLaceList, RADIANCE_WAR_STATE, self.questComponentMap, RADIANCE_WAR_STATE, self.radianceWarStateInfo.cruState = self.radianceWarStateInfo, self.radianceWarStateInfo, self.radianceWarStateInfo, self.radianceWarStateInfo, self.radianceWarStateInfo, self.radianceWarStateInfo, RADIANCE_WAR_STATE.NONE
	self.isBettleEnd = false
	self.radianceWarExplot = 0
	self.radianceWarStarlight = 0
	self.radianceWarAmberPoint = 0
	self.seasonTotalAmberPoint = 0
	self.timerNode = nil
end
function radianceActivityCtrl:Logout()
	radianceActivityCtrl.super.Logout(self)
	self:resetData()
end
function radianceActivityCtrl:setRadianceWarStatus(data)
