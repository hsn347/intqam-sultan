local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local radianceWarCtrl = class("radianceWarCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function radianceWarCtrl:getWarStatus()
	return self.radianceWarData.warStatus
end
function radianceWarCtrl:isOpen()
	return self.radianceWarData.warStatus ~= gKingdomWarStatusType.rule
end
function radianceWarCtrl:isInClose()
	return self.radianceWarData.warStatus == gKingdomWarStatusType.close
end
function radianceWarCtrl:isInWar()
	return self.radianceWarData.warStatus == gKingdomWarStatusType.inWar
end
function radianceWarCtrl:getSeason()
	return self.radianceWarData.season
end
function radianceWarCtrl:getStatusTime()
	local warData = self:getRadianceWarData()
	if warData.warStatus == gKingdomWarStatusType.inWar then
		local sysTime = serviceFunctions.systemTime()
		local endTime = warData.warStartTime + warData.warTotalTime
		if sysTime < endTime then
			return endTime - sysTime
		end
	elseif warData.warStatus == gKingdomWarStatusType.close then
		local sysTime = serviceFunctions.systemTime()
		if sysTime < warData.warStartTime then
			return warData.warStartTime - sysTime
		end
	end
	return 0
end
function radianceWarCtrl:getRadianceWarData()
	if not self.radianceWarData or not next(self.radianceWarData) then
		next(self.radianceWarData).campInfo, _ENV, _ENV = self.radianceWarData, self.radianceWarData, next(self.radianceWarData)
		next(self.radianceWarData).warStatus = gKingdomWarStatusType.rule
		next(self.radianceWarData).warStartTime = 0
		self.radianceWarData, next(self.radianceWarData).warTotalTime = next(self.radianceWarData), 0
	end
	return self.radianceWarData
end
function radianceWarCtrl:setMoveCityCDEndTime(moveCityCDEndTime)
	self.moveCityCDEndTime = moveCityCDEndTime or 0
end
function radianceWarCtrl:isMoveCityCDEndTime()
	return self:getMoveCityCDEndTime() > 0
end
function radianceWarCtrl:isHasUnReadResWarLog()
	return self.hasUnReadResWarLog
end
function radianceWarCtrl:resetHasUnReadResWarLog()
	self:updateHasUnReadResWarLog(false)
end
function radianceWarCtrl:updateHasUnReadResWarLog(statues)
	if self.hasUnReadResWarLog ~= statues then
		self.hasUnReadResWarLog = statues
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_RADIANCE_WAR_HAS_UNREAD_WAR_LOG"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY
		SoraDSendMessage(nil)
	end
end
function radianceWarCtrl:getMoveCityCDEndTime()
	if self.moveCityCDEndTime and self.moveCityCDEndTime > 0 then
		local sysTime = serviceFunctions.systemTime()
		if sysTime < self.moveCityCDEndTime then
			return self.moveCityCDEndTime - sysTime
		end
	end
	return 0
end
function radianceWarCtrl:reqRadianceWarData(mapId)
	print("radianceWarCtrl:reqRadianceWarData", mapId)
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_DATA, nil)
end
function radianceWarCtrl:reqRadianceWarMinis(mapId)
	print("radianceWarCtrl:reqRadianceWarMinis", mapId)
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_MINIS, nil)
end
function radianceWarCtrl:reqRadianceWarFreeRes(objId)
	print("radianceWarCtrl:reqRadianceWarFreeRes", objId)
	_ENV = nil
	;(nil).mapObjId = objId
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_FREE_RES, nil)
end
function radianceWarCtrl:reqRadianceWarFreeBeacon(objId)
	print("radianceWarCtrl:reqRadianceWarFreeBeacon", objId)
	_ENV = nil
	;(nil).buildId = objId
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_FREE_BEACON, nil)
end
function radianceWarCtrl:reqRadianceWarCancelFreeBeacon(objId)
	print("radianceWarCtrl:reqRadianceWarCancelFreeBeacon", objId)
	_ENV = nil
	;(nil).buildId = objId
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_CANCEL_FREE_BEACON, nil)
end
function radianceWarCtrl:radianceWarMatchResult(mapId)
	print("radianceWarCtrl:radianceWarMatchResult")
	local radianceWarUtil = include("radianceWarUtil")
	_ENV = nil
	;(nil).mapId = radianceWarUtil.getWarMapId()
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_MATCH_RESULT, nil)
end
function radianceWarCtrl:radianceWarPlayerResList()
	print("radianceWarCtrl:radianceWarPlayerResList")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_RES_LIST)
end
function radianceWarCtrl:radianceWarDrawOutAllRes()
	print("radianceWarCtrl:radianceWarDrawOutAllRes")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_DRAW_OUT_ALL_RES)
end
function radianceWarCtrl:reqRadianceWarBuildOccupyLog(mapId, buildId)
	print("radianceWarCtrl:reqRadianceWarBuildOccupyLog", mapId, buildId)
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).buildId = buildId
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_BUILD_OCCUPY_LOG, nil)
end
function radianceWarCtrl:reqRadianceWarPalaceOccupyLog(mapId, buildId, iBegin, nCount)
	print("radianceWarCtrl:reqRadianceWarPalaceOccupyLog", mapId, iBegin, nCount)
	_ENV = nCount
	nCount.mapId = mapId
	nCount.buildId = buildId
	nCount.iBegin = iBegin
	nCount.nCount = nCount
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PALACE_OCCUPY_LOG, nCount)
end
function radianceWarCtrl:radianceWarTeamBuildList()
	print("radianceWarCtrl:radianceWarTeamBuildList")
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_TEAM_BUILD_LIST)
end
function radianceWarCtrl:radianceWarTeamBuildOccupy(iBegin, nCount)
	print("radianceWarCtrl:radianceWarTeamBuildOccupy")
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_TEAM_BUILD_OCCUPY_LOG, nil)
end
function radianceWarCtrl:radianceWarPlayerResLog(iBegin, nCount)
	print("radianceWarCtrl:radianceWarPlayerResLog")
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_RES_LOG, nil)
end
function radianceWarCtrl:radianceWarPlayerResWarLog(iBegin, nCount)
	print("radianceWarCtrl:radianceWarPlayerResWarLog")
	_ENV = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_RES_WAR_LOG, nil)
end
function radianceWarCtrl:reqRadianceWarBuildConnect(mapId, buildId)
	print("radianceWarCtrl:reqRadianceWarBuildConnect", mapId, buildId)
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).buildId = buildId
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_BUILD_CONNECT, nil)
end
function radianceWarCtrl:ctor(properties)
	radianceWarCtrl.super.ctor(self, properties)
end
function radianceWarCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_DATA, handler(self, self.radianceWarDataRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_MINIS, handler(self, self.radianceWarMinisRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_FREE_RES, handler(self, self.radianceWarFreeResRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_FREE_BEACON, handler(self, self.radianceWarFreeBeaconRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_CANCEL_FREE_BEACON, handler(self, self.radianceWarCancelFreeBeaconRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_MATCH_RESULT, handler(self, self.radianceWarMatchResultRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_RES_LIST, handler(self, self.radianceWarPlayerResListRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_DRAW_OUT_ALL_RES, handler(self, self.radianceWarDrawOutAllResRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_BUILD_OCCUPY_LOG, handler(self, self.radianceWarBuildOccupyLogRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PALACE_OCCUPY_LOG, handler(self, self.radianceWarPalaceOccupyLogRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_TEAM_BUILD_LIST, handler(self, self.radianceWarTeamBuildListRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_TEAM_BUILD_OCCUPY_LOG, handler(self, self.radianceWarTeamBuildOccupyRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_RES_LOG, handler(self, self.radianceWarPlayerResLogRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_RES_WAR_LOG, handler(self, self.radianceWarPlayerResWarLogRSP))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_BUILD_CONNECT, handler(self, self.radianceWarBuildConnectRSP))
	self:resetData()
end
function radianceWarCtrl:resetData()
	self.radianceWarBuildInfoData, _UPVALUE0_, self.radianceWarResInfoData, _UPVALUE0_, self.radianceWarMatchData, _UPVALUE0_, self.radianceWarData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
	self.hasUnReadResWarLog = false
	self.moveCityCDEndTime = 0
end
function radianceWarCtrl:Logout()
	radianceWarCtrl.super.Logout(self)
	self:resetData()
end
function radianceWarCtrl:onMsg(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
		end
	end
end
function radianceWarCtrl:initClientData(data)
	dump(data, "radianceWarCtrl:initClientData", 10)
	if worldMapDefine.isInRadiance() then
		local mapId = gametop.playertop_:getMapID()
		self:reqRadianceWarData(mapId)
	end
	if data then
		self.hasUnReadResWarLog = data.hasUnReadResWarLog
	end
end
function radianceWarCtrl:radianceWarDataRSP(event)
	dump(event, "radianceWarCtrl:radianceWarDataRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		self:setWarData(rspdata)
		_ENV = self
		self.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED"
		SoraDSendMessage(self)
	end
end
function radianceWarCtrl:updateOutResData(msg)
	if self.radianceWarResInfoData then
		if msg.notifyType == "removeResource" then
			self.radianceWarResInfoData[msg.notifyData.mapObjId] = nil
			self:updateHasUnReadResWarLog(msg.notifyData.hasUnReadResWarLog or false)
		else
			self.radianceWarResInfoData[msg.notifyData.mapObjId] = msg.notifyData.resData
		end
		_ENV = msg.notifyData.mapObjId
		msg.notifyData.mapObjId.msg = "MESSAGE_SERVER_RADIANCE_WAR_RES_INFO_BACK"
		SoraDSendMessage(msg.notifyData.mapObjId)
	end
end
function radianceWarCtrl:updateBuildData(msg)
	if self.radianceWarBuildInfoData then
		if msg.type == "removeBuild" then
			self.radianceWarBuildInfoData[tostring(msg.buildId)] = nil
		else
			self.radianceWarBuildInfoData[tostring(msg.buildId)] = msg.buildData
		end
		_ENV = tostring(msg.buildId)
		tostring(msg.buildId).msg = "MESSAGE_SERVER_RADIANCE_WAR_BUILD_INFO_BACK"
		SoraDSendMessage((tostring(msg.buildId)))
	end
end
function radianceWarCtrl:setWarData(rspdata)
	if rspdata then
		self.radianceWarData = rspdata
		self:setMoveCityCDEndTime(rspdata.moveCityCDEndTime)
		if rspdata.isLongTimeUnlogin then
			_ENV = self
			self.msg = "MESSAGE_SERVER_RADIANCE_WAR_LONGTIMEUNLOGIN"
			SoraDSendMessage(self)
		end
	end
end
function radianceWarCtrl:getMatchData()
	if not self.radianceWarMatchData then
		_UPVALUE0_ = self.radianceWarMatchData
	end
	return self.radianceWarMatchData
end
function radianceWarCtrl:radianceWarMinisRSP(event)
	dump(event, "radianceWarCtrl:radianceWarMinisRSP", 10)
	local _ENV, map = dump, dump
	local err = event.err
	if err == gErrDef.Err_None then
		map, _ENV = event.rspdata, event.rspdata
		map = event.rspdata or dump
	end
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_RADIANCE_WAR_MINIMAP"
	;(10).map = map
	SoraDSendMessage(10)
end
function radianceWarCtrl:radianceWarFreeResRSP(event)
	dump(event, "radianceWarCtrl:radianceWarFreeResRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
	else
	end
end
function radianceWarCtrl:radianceWarFreeBeaconRSP(event)
	dump(event, "radianceWarCtrl:radianceWarFreeBeaconRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
	elseif err == gErrDef.Err_ALLIANCE_ACTIVE_NO_PERMISSION then
		SoraDShowMsgTip(i18n("common_text_203"))
		SoraDCloseLoading()
	end
end
function radianceWarCtrl:radianceWarCancelFreeBeaconRSP(event)
	dump(event, "radianceWarCtrl:radianceWarCancelFreeBeaconRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
	else
	end
end
function radianceWarCtrl:radianceWarMatchResultRSP(event)
	dump(event, "radianceWarCtrl:radianceWarMatchResultRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		self.radianceWarMatchData = event.rspdata
		_ENV = "radianceWarCtrl:radianceWarMatchResultRSP"
		;("radianceWarCtrl:radianceWarMatchResultRSP").msg = "MESSAGE_SERVER_RADIANCE_WAR_MATCH_BACK"
		SoraDSendMessage("radianceWarCtrl:radianceWarMatchResultRSP")
	else
	end
end
function radianceWarCtrl:radianceWarPlayerResListRSP(event)
	dump(event, "radianceWarCtrl:radianceWarPlayerResListRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		self.radianceWarResInfoData = event.rspdata
		_ENV = "radianceWarCtrl:radianceWarPlayerResListRSP"
		;("radianceWarCtrl:radianceWarPlayerResListRSP").msg = "MESSAGE_SERVER_RADIANCE_WAR_RES_INFO_BACK"
		SoraDSendMessage("radianceWarCtrl:radianceWarPlayerResListRSP")
	else
	end
end
function radianceWarCtrl:radianceWarTeamBuildListRSP(event)
	dump(event, "radianceWarCtrl:radianceWarTeamBuildListRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		self.radianceWarBuildInfoData = event.rspdata
		_ENV = "radianceWarCtrl:radianceWarTeamBuildListRSP"
		;("radianceWarCtrl:radianceWarTeamBuildListRSP").msg = "MESSAGE_SERVER_RADIANCE_WAR_BUILD_INFO_BACK"
		SoraDSendMessage("radianceWarCtrl:radianceWarTeamBuildListRSP")
	else
	end
end
function radianceWarCtrl:radianceWarDrawOutAllResRSP(event)
	dump(event, "radianceWarCtrl:radianceWarDrawOutAllResRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None and event.rspdata then
		SoraDMailGainItems(event.rspdata)
	else
	end
end
function radianceWarCtrl:radianceWarTeamBuildOccupyRSP(event)
	dump(event, "radianceWarCtrl:radianceWarTeamBuildOccupyRSP", 10)
	if not event.rspdata then
		local _ENV, retData = event.rspdata, event.rspdata
	end
	local data = event.data
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_RADIANCE_WAR_GETLOG_PALACE"
	;(10).reqdata = data
	;(10).retdate = retData
	SoraDSendMessage(10)
end
function radianceWarCtrl:radianceWarPlayerResLogRSP(event)
	dump(event, "radianceWarCtrl:radianceWarPlayerResLogRSP", 10)
	if not event.rspdata then
		local _ENV, retData = event.rspdata, event.rspdata
	end
	local data = event.data
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_RADIANCE_WAR_GETLOG_PALACE"
	;(10).reqdata = data
	;(10).retdate = retData
	SoraDSendMessage(10)
end
function radianceWarCtrl:radianceWarPlayerResWarLogRSP(event)
	dump(event, "radianceWarCtrl:radianceWarPlayerResWarLogRSP", 10)
	if not event.rspdata then
		local _ENV, retData = event.rspdata, event.rspdata
	end
	local data = event.data
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_RADIANCE_WAR_GETLOG_PALACE"
	;(10).reqdata = data
	;(10).retdate = retData
	SoraDSendMessage(10)
end
function radianceWarCtrl:radianceWarBuildOccupyLogRSP(event)
	dump(event, "radianceWarCtrl:radianceWarBuildOccupyLogRSP", 10)
	if not event.rspdata then
		local _ENV, retData = event.rspdata, event.rspdata
	end
	local data = event.data
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_RADIANCE_WAR_GETLOG_PALACE"
	;(10).reqdata = data
	;(10).retdate = retData
	SoraDSendMessage(10)
end
function radianceWarCtrl:radianceWarPalaceOccupyLogRSP(event)
	dump(event, "radianceWarCtrl:radianceWarPalaceOccupyLogRSP", 10)
	if not event.rspdata then
		local _ENV, retData = event.rspdata, event.rspdata
	end
	local data = event.data
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_RADIANCE_WAR_GETLOG_PALACE"
	;(10).reqdata = data
	;(10).retdate = retData
	SoraDSendMessage(10)
end
function radianceWarCtrl:radianceWarBuildConnectRSP(event)
	dump(event, "radianceWarCtrl:radianceWarBuildConnectRSP", 10)
	if not event.rspdata then
		local _ENV, retData = event.rspdata, event.rspdata
	end
	local data = event.data
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_RADIANCE_WAR_BUILD_INFO"
	;(10).reqdata = data
	;(10).retdate = retData
	SoraDSendMessage(10)
end
return radianceWarCtrl
