local gamemodulec = include("GameModule")
local legendLordWarCtrl = class("legendLordWarCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local ACTIVITY_STATE = _G.ACTIVITY_STATE
local armyltCtrl = include("armyltCtrl")
function legendLordWarCtrl:getMemoirList(buildId, idx, count, mapId, ...)
	serverproxy = nil
	;(nil).buildId = buildId
	;(nil).idx = idx
	;(nil).count = count
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_MEMOIR_LIST, nil, ...)
end
function legendLordWarCtrl:getKingAlliance(buildId, reqMyInfo, mapId, ...)
	serverproxy = nil
	;(nil).buildId = buildId
	;(nil).reqMyInfo = reqMyInfo
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_LEGENDLORD_ALLYS, nil, ...)
end
function legendLordWarCtrl:getOccupyRankList(buildId, idx, count, mapId, ...)
	serverproxy = nil
	;(nil).buildId = buildId
	;(nil).idx = idx
	;(nil).count = count
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_OCCUPY_RANK_LIST, nil, ...)
end
function legendLordWarCtrl:getOccupyInfo(buildId, mapId)
	serverproxy = nil
	;(nil).buildId = buildId
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_BUILD_OCCUPIER_INFO, nil)
end
function legendLordWarCtrl:reqLegendLordData(mapId)
	print("legendLordWarCtrl:reqLegendLordData")
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_DATA, nil)
end
function legendLordWarCtrl:reqBestRank(buildId, isAttacker, mapId)
	serverproxy = nil
	;(nil).buildId = buildId
	;(nil).isAttacker = isAttacker
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_BUILD_KILL_FC_RANK, nil)
end
function legendLordWarCtrl:reqBestKillInfo(mapId)
	serverproxy = nil
	;(nil).buildId = gLegendBuildID
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_BUILD_BEST_KILL_FC_PLAYERS, nil)
end
function legendLordWarCtrl:getOpenBuildID(mapid)
	if self.openBuildId <= 0 then
		self:reqLegendLordData(mapid)
	end
	return self.openBuildId
end
function legendLordWarCtrl:getLegendOccupyTime(time)
	return serviceFunctions.systemTime() - self.legendLordStartTime - time
end
function legendLordWarCtrl:getLegendOccupyMaxTime(bID)
	local hegemonRead = include("hegemonRead")
	if bID and bID ~= 0 and not hegemonRead.isLegendLordBuilding(bID) then
		return 7200
	end
	return 21600
end
function legendLordWarCtrl:isOpen()
	return self.legendLordWarStatus ~= gKingdomWarStatusType.rule
end
function legendLordWarCtrl:isHasTicket()
	if self.legendData and self.legendData.player and next(self.legendData.player) then
		return true
	end
end
function legendLordWarCtrl:isInWar()
	return self.legendLordWarStatus == gKingdomWarStatusType.inWar
end
function legendLordWarCtrl:getStatusTime()
	if self.legendLordWarStatus == gKingdomWarStatusType.inWar then
		local sysTime = serviceFunctions.systemTime()
		local endTime = self.legendLordStartTime + self.legendLordWarTotalTime
		if sysTime < endTime then
			return endTime - sysTime
		end
	elseif self.legendLordWarStatus == gKingdomWarStatusType.close then
		local sysTime = serviceFunctions.systemTime()
		if sysTime < self.legendLordStartTime then
			return self.legendLordStartTime - sysTime
		end
	end
	return 0
end
function legendLordWarCtrl:getWatchingNum()
	return self.legendWatchingNum or 0
end
function legendLordWarCtrl:setWatchingNum(watchingNum)
	self.legendWatchingNum = watchingNum
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_WATCHING_NUM"
	SoraDSendMessage(nil)
end
function legendLordWarCtrl:isLegendLordTeamOpen(mapid)
	local activityId = worldMapDefine.isKingStarMapId(mapid) and worldMapDefine.getKingStarActivityID(mapid) or gActivityTimeActivityID.LEGEND_LORD
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local legendLordActivityStatus = activityShowCtrl:getStateByID(activityId)
	print("activityId", activityId, mapid, legendLordActivityStatus)
	if legendLordActivityStatus == gActivityState.OPEN or legendLordActivityStatus == gActivityState.PREPARE then
		local param = activityShowCtrl:getParamByID(activityId)
		dump(param, "isLegendLordTeamOpen")
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE or legendLordState == ACTIVITY_STATE.PREPARE then
			return true
		end
	end
	return false
end
function legendLordWarCtrl:isLegendLordActivityOpen(mapid)
	mapid = mapid ~= nil and mapid or self.mapid
	local activityId = worldMapDefine.isKingStarMapId(mapid) and worldMapDefine.getKingStarActivityID(mapid) or gActivityTimeActivityID.LEGEND_LORD
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local legendLordActivityStatus = activityShowCtrl:getStateByID(activityId)
	print("activityId", activityId, mapid)
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(activityId)
		local legendLordState = param.curState
		print("legendLordState", legendLordState)
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			return true
		end
	end
	return false
end
function legendLordWarCtrl:isLegendLordActivityOpenOrSetTitle(mapid)
	mapid = mapid ~= nil and mapid or self.mapid
	local activityId = worldMapDefine.isKingStarMapId(mapid) and worldMapDefine.getKingStarActivityID(mapid) or gActivityTimeActivityID.LEGEND_LORD
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local legendLordActivityStatus = activityShowCtrl:getStateByID(activityId)
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(activityId)
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE or legendLordState == ACTIVITY_STATE.SETTLE then
			return true
		end
	end
	return false
end
function legendLordWarCtrl:isLegendLordHasLord(mapid)
	mapid = mapid ~= nil and mapid or self.mapid
	local activityId = worldMapDefine.isKingStarMapId(mapid) and worldMapDefine.getKingStarActivityID(mapid) or gActivityTimeActivityID.LEGEND_LORD
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local legendLordActivityStatus = activityShowCtrl:getStateByID(activityId)
	if legendLordActivityStatus == gActivityState.CLOSE then
		return true
	elseif legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(activityId)
		local legendLordState = param.curState
		if legendLordState ~= ACTIVITY_STATE.ACTIVE and legendLordState ~= ACTIVITY_STATE.PREPARE then
			return true
		end
	end
	return false
end
function legendLordWarCtrl:getMapid()
	return self.mapid
end
function legendLordWarCtrl:isKingdomJoinActivity()
	return self.isKingdomJoin
end
function legendLordWarCtrl:isPlayerMoveToLegendLordWar(targetKid, mapid)
	mapid = mapid ~= nil and mapid or self.mapid
	print("targetKid, mapid=======", targetKid, mapid)
	if self:isLegendLordActivityOpen(mapid) and not worldMapDefine.isInLegendLord() and targetKid >= GAME_KINGDOM_ID_ASSIGN.LEGEND.START and targetKid <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return true
	end
	return false
end
function legendLordWarCtrl:isPlayerReturnSourceKingdom(targetKid, mapid)
	mapid = mapid ~= nil and mapid or self.mapid
	if self:isLegendLordActivityOpenOrSetTitle(mapid) then
		local kid = gametop.playertop_:getKingdomID()
		if targetKid == kid then
			return true
		end
	end
	return false
end
function legendLordWarCtrl:ctor(properties)
	legendLordWarCtrl.super.ctor(self, properties)
	self:init()
end
function legendLordWarCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_DATA, handler(self, self.getLegendLordData))
	msgCtrl.register(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_OCCUPY_RANK_LIST, handler(self, self.reqRankListRSP))
	msgCtrl.register(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_MEMOIR_LIST, handler(self, self.reqMemoirListRSP))
	msgCtrl.register(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_LEGENDLORD_ALLYS, handler(self, self.reqKingAllianceRSP))
	msgCtrl.register(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_BUILD_OCCUPIER_INFO, handler(self, self.reqBuildOccupierInfoRSP))
	msgCtrl.register(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_BUILD_KILL_FC_RANK, handler(self, self.reqBestRankRSP))
	msgCtrl.register(gCmd.CMD_LLW_MGR_MODULE, gCmd.REQ_LLW_BUILD_BEST_KILL_FC_PLAYERS, handler(self, self.reqBestKillInfoRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LLW, handler(self, self.onMsg))
	self:resetData()
end
function legendLordWarCtrl:resetData()
	self.legendLordWarStatus = gKingdomWarStatusType.rule
	self.legendLordWarStatusTime = 0
	self.legendLordWarTotalTime = 0
	self.legendLordStartTime = 0
	self.openBuildId = 0
	self.legendKingInfo = nil
	self.legendData = nil
	self.isKingdomJoin = false
	self.legendWatchingNum = 0
	self.mapid = nil
end
function legendLordWarCtrl:Logout()
	legendLordWarCtrl.super.Logout(self)
	self:resetData()
end
function legendLordWarCtrl:init()
end
function legendLordWarCtrl:getLegendLordData(event)
	dump(event, "legendLordWarCtrl:getLegendLordData", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		self.legendData = event.rspdata.warData
		self.isKingdomJoin = event.rspdata.isKingdomJoin or false
		self.mapid = event.data.mapId
		self.personalData = event.rspdata.personalData
		self:updateLegendData()
	else
		print("legendLordWarCtrl:getLegendLordData err code = ", tostring(err))
	end
	_ENV = "legendLordWarCtrl:getLegendLordData err code = "
	;("legendLordWarCtrl:getLegendLordData err code = ").msg = "MESSAGE_SERVER_LEGENDLORD_WAR_DATA"
	SoraDSendMessage("legendLordWarCtrl:getLegendLordData err code = ")
end
function legendLordWarCtrl:updateLegendData()
	self.openBuildId = self.legendData.openBuildId or 0
	if self.legendData.startTime and 0 < self.legendData.startTime then
		self.legendLordStartTime = self.legendData.startTime
	else
		self.legendLordStartTime = 0
	end
	if self.legendData.watchNum then
		self:setWatchingNum(self.legendData.watchNum)
	end
	_UPVALUE3_ = self
	self[1] = self.legendData.startTime
	self[2] = self.legendData.startTime
	self[3] = self.legendLordStartTime
	dump(self, "updateLegendData")
	self:onStatusChange(self.legendData.status, self.legendData.runTime, self.legendData.maxTime)
end
function legendLordWarCtrl:reqMemoirListRSP(event)
	dump(event, "legendLordWarCtrl:reqMemListRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local rankList = retdata.msgs
		local newStartIndex = retdata.idx + 1
		local bCanContinueGet = retdata.nTotal > retdata.idx
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_MEMOIR"
		;(nil).rankList = rankList
		;(nil).idx = newStartIndex
		;(nil).wget = bCanContinueGet
		SoraDSendMessage(nil)
	else
		print("legendLordWarCtrl:reqMemoirListRSP err code = ", tostring(err))
	end
end
function legendLordWarCtrl:reqKingAllianceRSP(event)
	dump(event, "legendLordWarCtrl:reqKingAllianceRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local rankList = retdata.allys
		local legendLord = retdata.legendLord
		local myInfo = retdata.myInfo
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_ALLIANCE"
		;(nil).rankList = rankList
		;(nil).legendLord = legendLord
		;(nil).myInfo = myInfo
		SoraDSendMessage(nil)
	else
		print("legendLordWarCtrl:reqKingAllianceRSP err code = ", tostring(err))
	end
end
function legendLordWarCtrl:reqRankListRSP(event)
	dump(event, "legendLordWarCtrl:reqRankListRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local myInfo = retdata.myInfo
		local rankList = retdata.msgs
		local newStartIndex = retdata.idx + 1
		local bCanContinueGet = retdata.nTotal > retdata.idx
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_OCCUPY_RANK"
		;(nil).myInfo = myInfo
		;(nil).rankList = rankList
		;(nil).idx = newStartIndex
		;(nil).wget = bCanContinueGet
		SoraDSendMessage(nil)
	else
		print("legendLordWarCtrl:reqRankListRSP err code = ", tostring(err))
	end
end
function legendLordWarCtrl:reqBuildOccupierInfoRSP(content)
	dump(content.rspdata, "legendLordWarCtrl:BuildOccupierInfoRSP", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local occupier = content.rspdata
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_INFO"
		;(10).occupier = occupier
		SoraDSendMessage(10)
	else
		print("legendLordWarCtrl:BuildOccupierInfoRSP err code = ", tostring(err))
	end
end
function legendLordWarCtrl:reqBestRankRSP(content)
	dump(content, "legendLordWarCtrl:reqGetBestRankRSP", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.rspdata
		local rankList = retdata.rankList
		local myInfo = retdata.myInfo
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_ALLIANCE"
		;(nil).rankList = rankList
		;(nil).myInfo = myInfo
		SoraDSendMessage(nil)
	end
end
function legendLordWarCtrl:reqBestKillInfoRSP(content)
	dump(content, "legendLordWarCtrl:reqBestKillInfoRSP", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local _ENV, topRankList = gErrDef.Err_None, gErrDef.Err_None
		if not content.rspdata then
			local _ENV, rspdata = content.rspdata, content.rspdata
		end
		if not rspdata.bestAlly then
			_ENV = rspdata.bestAlly
		end
		table.insert(topRankList, rspdata.bestAlly)
		if not rspdata.bestAttacker then
			_ENV = rspdata.bestAttacker
		end
		table.insert(topRankList, rspdata.bestAttacker)
		if not rspdata.bestDefender then
			_ENV = rspdata.bestDefender
		end
		table.insert(topRankList, rspdata.bestDefender)
		_ENV = topRankList
		topRankList.msg = "MESSAGE_SERVER_LEGENDLORD_ALLIANCE"
		topRankList.topRankList = topRankList
		SoraDSendMessage(topRankList)
	end
end
function legendLordWarCtrl:onMsg(event)
	local data = event.data
	dump(data, "legendLordWarCtrl:onMsg(msg)", 10)
	if data then
		for _, msg in pairs(data) do
			local msgType = msg.type
			if msgType == LLW_MSG_TYPE.WAR_DATA then
				self:onWarStatusChange(msg)
			elseif msgType == LLW_MSG_TYPE.WAR_PERSONAL_RESULT then
				self:onPersonalResult(msg)
			elseif msgType == LLW_MSG_TYPE.PERSONAL_DATA then
				self:onPersonalData(msg)
			elseif msgType == LLW_MSG_TYPE.OCCUPY_ALLIANCE_CHANGE then
				self:onPlaceOccupyAllianceChange(msg)
			end
		end
	end
end
function legendLordWarCtrl:onWarStatusChange(msg)
	dump(msg, "legendLordWarCtrl:onWarStatusChange(msg)", 10)
	self.legendData = msg.data
	self:updateLegendData()
end
function legendLordWarCtrl:onPersonalResult(msg)
	dump(msg, "legendLordWarCtrl:onPersonalResult(msg)", 10)
	_ENV = msg
	msg.msg = "MESSAGE_SERVER_LEGENDLORD_PERSONAL_RESULT"
	msg.data = msg.data
	SoraDSendMessage(msg)
end
function legendLordWarCtrl:onPersonalData(msg)
	dump(msg, "legendLordWarCtrl:onPersonalResult(msg)", 10)
	if not self.personalData then
		self.personalData, _ENV = self.personalData, self.personalData
	end
	if msg.data and msg.data.killFc then
		self.personalData.killFc = msg.data.killFc
	end
	if msg.data and msg.data.killNum then
		self.personalData.killNum = msg.data.killNum
	end
	if msg.data and msg.data.speedUpTimes then
		self.personalData.speedUpTimes = msg.data.speedUpTimes
	end
	if msg.data and msg.data.cureWoundedCount then
		self.personalData.cureWoundedCount = msg.data.cureWoundedCount
	end
end
function legendLordWarCtrl:onPlaceOccupyAllianceChange(msg)
	dump(msg, "legendLordWarCtrl:onPlaceOccupyAllianceChange(msg)", 10)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onPlaceOccupyAllianceChange(msg, true)
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED"
	SoraDSendMessage(kingdomMapCtrl)
end
function legendLordWarCtrl:onStatusChange(legendLordWarStatus, legendLordWarStatusTime, legendLordWarTotalTime, isInit)
	self.legendLordWarStatus = legendLordWarStatus
	self.legendLordWarStatusTime = legendLordWarStatusTime
	self.legendLordWarTotalTime = legendLordWarTotalTime
	if self.legendLordStartTime <= 0 then
		self.legendLordWarStatus = gKingdomWarStatusType.rule
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED"
	SoraDSendMessage(nil)
end
function legendLordWarCtrl:getPersonalData()
	return self.personalData
end
function legendLordWarCtrl:getCostResPercent(mapid, level, resId)
	local legendKingdomResCost = function(ctype, level, resId, state)
		local cfg = armyltCtrl.getLegendarykingCureCostCfg(ctype, level)
		if resId == gIDDef.FOOD then
			return cfg.costFood / 1000
		elseif resId == gIDDef.WOOD then
			return cfg.costWood / 1000
		elseif resId == gIDDef.IRON then
			return cfg.costIron / 1000
		elseif resId == gIDDef.MITHRIL then
			return cfg.costSilver / 1000
		elseif resId == gIDDef.CRYSTAL then
			return cfg.costCrystal / 1000
		elseif resId == gIDDef.METEOR_CRYSTAL then
			local constantRead = include("constantRead")
			if not constantRead.checkLegendLordMeteorCrystal() then
				state = ACTIVITY_STATE.ACTIVE
			end
			if state == ACTIVITY_STATE.ACTIVE then
				return cfg.costMeteor / 1000
			else
				return 0
			end
		elseif resId == gIDDef.GILDED_CRYSTAL or resId == gIDDef.GILDED_CURE_ESSENCE then
			if state == ACTIVITY_STATE.ACTIVE then
				return cfg.costGilded / 1000
			else
				return 0
			end
		end
		return 1
	end
	level = level or 1
	resId = resId or gIDDef.FOOD
	local value = 0
	local curState = self:getCurState(mapid)
	if curState == ACTIVITY_STATE.ACTIVE or curState == ACTIVITY_STATE.SETTLE then
		if worldMapDefine.isKingStarMapId(mapid) then
			value = legendKingdomResCost(1, level, resId, curState)
		else
			value = legendKingdomResCost(3, level, resId, curState)
		end
	else
		value = legendKingdomResCost(2, level, resId, ACTIVITY_STATE.ACTIVE)
	end
	return math.floor(100 - value * 100)
end
function legendLordWarCtrl:getCureSpeed(mapid)
	local constantRead = include("constantRead")
	local curState = self:getCurState(mapid)
	if curState == ACTIVITY_STATE.ACTIVE or curState == ACTIVITY_STATE.SETTLE then
		local value = constantRead.getConstCureSpeed_lgeend()
		return value
	else
		local value = constantRead.getConstCureSpeed_hegemon()
		return value
	end
end
function legendLordWarCtrl:getCurState(mapid)
	mapid = mapid ~= nil and mapid or self.mapid
	local activityId = worldMapDefine.isKingStarMapId(mapid) and worldMapDefine.getKingStarActivityID(mapid) or gActivityTimeActivityID.LEGEND_LORD
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(activityId)
	local curState = param and param.curState or ACTIVITY_STATE.NONE
	return curState
end
function legendLordWarCtrl:getBackPlayerTime()
	return self.legendData and self.legendData.backPlayerTime or 0
end
function legendLordWarCtrl:checkBackPlayerTime()
	local backPlayerTime = self:getBackPlayerTime()
	if backPlayerTime and backPlayerTime > serviceFunctions.systemTime() then
		return true
	else
		return false
	end
end
return legendLordWarCtrl
