local gamemodulec = include("GameModule")
local allianceWarCtrl = class("allianceWarCtrl", gamemodulec)
local allianceWarCell = include("allianceWarCell")
local msgCtrl = include("msgCtrl")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
function allianceWarCtrl:ctor(properties)
	allianceWarCtrl.super.ctor(self, properties)
	self.allianceWarCell = allianceWarCell.new()
	self:init()
end
function allianceWarCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_AW_GET_PLACE_LOG, handler(self, self.getPlaceLogRSP))
	msgCtrl.register(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_AW_DATA, handler(self, self.reqDataRSP))
	msgCtrl.register(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_AW_PERSONAL_POINTS_LIST, handler(self, self.reqPersonalPointsListRSP))
	msgCtrl.register(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_SYNC_AW, handler(self, self.reqSyncAWRSP))
	msgCtrl.register(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_STOP_SYNC_AW, handler(self, self.reqStopSyncAWRSP))
	self.kid = gametop.playertop_:getMapID()
	self.uid = gametop.playertop_:getPlayerID()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.AW, handler(self, self.onMsg))
	local allianceWarSettingCtrl = include("allianceWarSettingCtrl")
	allianceWarSettingCtrl:init()
end
function allianceWarCtrl:Logout()
	allianceWarCtrl.super.Logout(self)
	self.allianceWarCell:clearWarData()
end
function allianceWarCtrl:init()
end
function allianceWarCtrl:getPlaceLog(kid, x, y, startIndex, ...)
	local placeId
	local allianceWarltCtrl = include("allianceWarltCtrl")
	local allianceBuilding = allianceWarltCtrl.getAllianceWarBuildingByPos(x, y)
	if allianceBuilding then
		placeId = allianceBuilding.id
	end
	if placeId then
		kid = kid or worldMapDefine.currentMapKindomID
		_ENV = nil
		;(nil).kid = kid
		;(nil).placeId = placeId
		;(nil).startIndex = startIndex
		serverproxy:Request(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_AW_GET_PLACE_LOG, nil, ...)
	else
		print("allianceWarCtrl:getPlaceLog placeId not found", kid, x, y, startIndex)
	end
end
function allianceWarCtrl:reqAWData(kid, ...)
	kid = kid or self.kid or worldMapDefine.currentMapKindomID
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	_ENV = nil
	;(nil).kid = kid
	;(nil).aid = allianceMgr:getOwnTeamID()
	serverproxy:Request(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_AW_DATA, nil, ...)
end
function allianceWarCtrl:getPersonalPointsList(kid, red, blue, ...)
	serverproxy = nil
	;(nil).kid = kid
	;(nil).red = red
	;(nil).blue = blue
	serverproxy:Request(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_AW_PERSONAL_POINTS_LIST, nil, ...)
end
function allianceWarCtrl:reqSyncAW(kid, ...)
	kid = kid or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_SYNC_AW, nil, ...)
end
function allianceWarCtrl:reqStopSyncAW(kid, ...)
	kid = kid or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_AW_MGR_MODULE, gCmd.REQ_STOP_SYNC_AW, nil, ...)
end
function allianceWarCtrl:getPlaceLogRSP(rsp)
	dump(rsp.retData, "allianceWarCtrl:getPlaceLogRSP", 10)
	if not rsp.retData then
		local _ENV, retData = rsp.retData, rsp.retData
	end
	_ENV = "allianceWarCtrl:getPlaceLogRSP"
	;("allianceWarCtrl:getPlaceLogRSP").msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACE"
	;("allianceWarCtrl:getPlaceLogRSP").retdate = retData
	SoraDSendMessage("allianceWarCtrl:getPlaceLogRSP")
end
function allianceWarCtrl:reqDataRSP(rsp)
	dump(rsp.retData, "allianceWarCtrl:reqDataRSP", 10)
	local retData = rsp.retData
	if retData and next(retData) then
		self:changeWarStatus(rsp.data.kid, retData.warStatus, retData.warStartTime, retData.warMaxTime, true)
		self.allianceWarCell:setAllianceWarPlus(rsp.data.kid, retData.atkPlus or 0, retData.defPlus or 0, retData.hpPlus or 0)
		self.allianceWarCell:setAllianceWarStyle(rsp.data.kid, retData.style or 0)
		self.allianceWarCell:setWatchingNum(rsp.data.kid, retData.watchNum or 0)
	end
end
function allianceWarCtrl:reqPersonalPointsListRSP(rsp)
	if rsp.err == gErrDef.Err_None then
		if not rsp.retData then
			local _ENV, retData = rsp.retData, rsp.retData
		end
		table.sort(retData, function(member1, member2)
			if member1.points == member2.points then
				return member1.uid < member2.uid
			else
				return member1.points > member2.points
			end
		end)
		_ENV = retData
		retData.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_FIELDINTEGRAL"
		retData.retdate = retData
		SoraDSendMessage(retData)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_FIELDINTEGRAL_ERR"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function allianceWarCtrl:reqSyncAWRSP(rsp)
	dump(rsp, "allianceWarCtrl:reqSyncAWRSP", 10)
	if rsp.err == gErrDef.Err_None then
		local warData = rsp.retData and rsp.retData.warData
		if warData and next(warData) then
			self:changeWarStatus(rsp.data.kid, warData.warStatus, warData.warStartTime, warData.warMaxTime)
			self.allianceWarCell:setAllianceWarStyle(rsp.data.kid, warData.style or 0)
			self.allianceWarCell:setAllianceWarCampData(rsp.data.kid, warData.warCampData)
		end
		local warBuildingOwnerMap = rsp.retData and rsp.retData.warBuildingOwnerMap
		if warBuildingOwnerMap then
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			for buildId, owner in pairs(warBuildingOwnerMap) do
				kingdomMapCtrl:setWarBuildingOwner(rsp.data.kid, tonumber(buildId), owner)
			end
		end
		_ENV = pairs(warBuildingOwnerMap)
		pairs(warBuildingOwnerMap).msg = "MESSAGE_SERVER_PYRAMIDBATTLE_CAMP_DATA"
		SoraDSendMessage(pairs(warBuildingOwnerMap))
	else
	end
end
function allianceWarCtrl:reqStopSyncAWRSP(rsp)
	if rsp.err == gErrDef.Err_None then
	else
	end
end
function allianceWarCtrl:onMsg(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			local msgType = msg.msgType
			if msgType == gAWMsgType.warStatusChange then
				self:onWarStatusChange(msg)
			elseif msgType == gAWMsgType.placeOccupyAllianceChange then
				self:onPlaceOccupyAllianceChange(msg)
			elseif msgType == gAWMsgType.placeOwnerInfoChange then
				self:onPlaceOwnerInfoChange(msg)
			elseif msgType == gAWMsgType.finishOccupy then
				self:onFinishOccupy(msg)
			elseif msgType == gAWMsgType.updateCamps4AllianceWar then
				self:onUpdateCamps(msg)
			elseif msgType == gAWMsgType.allianceBuffChange then
				self:onAllianceBuffChange(msg)
			elseif msgType == gAWMsgType.updateRemindFreeMoveTimesByTransPoints then
				self:onUpdateRemindFreeMoveTimesByTransPoints(msg)
			end
		end
	end
end
function allianceWarCtrl:onWarStatusChange(msg)
	dump(msg, "allianceWarCtrl:onWarStatusChange(msg)", 10)
	self:changeWarStatus(msg.data.kid, msg.data.warStatus, msg.data.warStartTime, msg.data.warMaxTime, false)
end
function allianceWarCtrl:onPlaceOccupyAllianceChange(msg)
	dump(msg, "allianceWarCtrl:onPlaceOccupyAllianceChange(msg)", 10)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onPlaceOccupyAllianceChange(msg)
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED"
	SoraDSendMessage(kingdomMapCtrl)
end
function allianceWarCtrl:onPlaceOwnerInfoChange(msg)
	dump(msg, "allianceWarCtrl:onPlaceOwnerInfoChange(msg)", 10)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onPlaceOwnerInfoChange(msg)
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED"
	SoraDSendMessage(kingdomMapCtrl)
end
function allianceWarCtrl:onFinishOccupy(msg)
	dump(msg, "allianceWarCtrl:onFinishOccupy(msg)", 10)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:setWarBuildingOwner(msg.data.kid, msg.data.placeId, msg.data.owner)
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED"
	SoraDSendMessage(kingdomMapCtrl)
end
function allianceWarCtrl:onUpdateCamps(msg)
	dump(msg, "allianceWarCtrl:onUpdateCamps(msg)", 10)
	self.allianceWarCell:setAllianceWarCampData(msg.data.kid, msg.data.campData)
	_ENV = self.allianceWarCell
	self.allianceWarCell.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_CAMP_DATA"
	SoraDSendMessage(self.allianceWarCell)
end
function allianceWarCtrl:onAllianceBuffChange(msg)
	dump(msg, "allianceWarCtrl:onAllianceBuffChange(msg)", 10)
	self.allianceWarCell:setAllianceWarPlus(msg.data.kid, msg.data.atkPlus, msg.data.defPlus, msg.data.hpPlus)
end
function allianceWarCtrl:onUpdateRemindFreeMoveTimesByTransPoints(msg)
	dump(msg, "allianceWarCtrl:onUpdateRemindFreeMoveTimesByTransPoints(msg)", 10)
	self.allianceWarCell:setRemainFreeMoveTimesByTransPoints(msg.data.kid, msg.data.times)
	_ENV = self.allianceWarCell
	self.allianceWarCell.msg = "MESSAGE_WORLD_MAP_TRANSFER_CD_REFRESH"
	SoraDSendMessage(self.allianceWarCell)
end
function allianceWarCtrl:changeWarStatus(kid, warStatus, warStartTime, warMaxTime, isInit)
	print("allianceWarCtrl:changeWarStatus", kid, warStatus, warStartTime, warMaxTime, isInit)
	local curTime = serviceFunctions.systemTime()
	local warData = self.allianceWarCell:setWarStatus(kid, warStatus or 0, warStartTime or 0, warMaxTime or 0)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local coolQueue = queueCtrl:queryQueue(gQueueTypeDef.world_resource_cool, gAllianceWarCoolQueueId)
	if not coolQueue then
		_ENV = nil
		queueCtrl:addQueue(gQueueTypeDef.world_resource_cool, curTime, warData.warMaxTime, warData.warStatusTime, nil, gAllianceWarCoolQueueId)
	else
		queueCtrl:restartLeftTime(gQueueTypeDef.world_resource_cool, warData.warStatusTime, gAllianceWarCoolQueueId)
	end
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onAllianceWarStatusChange(kid, isInit)
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED"
	SoraDSendMessage(kingdomMapCtrl)
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED"
	SoraDSendMessage(kingdomMapCtrl)
end
function allianceWarCtrl:initClientData(data)
	if worldMapDefine.isInPyramid() then
		self.kid = gametop.playertop_:getMapID()
		self:reqAWData()
	end
end
function allianceWarCtrl:getWarData(kid)
	kid = kid or worldMapDefine.currentMapKindomID or self.kid
	return self.allianceWarCell:getWarData(kid)
end
function allianceWarCtrl:getAllianceWarCampData(kid)
	kid = kid or worldMapDefine.currentMapKindomID or self.kid
	return self.allianceWarCell:getAllianceWarCampData(kid)
end
function allianceWarCtrl:setAllianceWarCampData(kid, allianceWarCampData)
	kid = kid or worldMapDefine.currentMapKindomID or self.kid
	self.allianceWarCell:setAllianceWarCampData(kid, allianceWarCampData)
end
function allianceWarCtrl:setRemainFreeMoveTimesByTransPoints(kid, points)
	kid = kid or self.kid
	return self.allianceWarCell:setRemainFreeMoveTimesByTransPoints(kid, points)
end
function allianceWarCtrl:getRemainFreeMoveTimesByTransPoints(kid)
	kid = kid or self.kid
	return self.allianceWarCell:getRemainFreeMoveTimesByTransPoints(kid)
end
function allianceWarCtrl:getRemainMoveTimes4AllianceWar(kid, aid)
	kid = kid or self.kid
	aid = aid or gametop.playertop_:getModule("allianceMgr"):getOwnTeamID()
	return self.allianceWarCell:getRemainMoveTimes4AllianceWar(kid, aid)
end
function allianceWarCtrl:getCampType(kid, aid)
	kid = kid or self.kid
	aid = aid or gametop.playertop_:getModule("allianceMgr"):getOwnAid()
	return self.allianceWarCell:getCampType(kid, aid)
end
function allianceWarCtrl:getWatchingNum(kid)
	kid = kid or worldMapDefine.currentMapKindomID or self.kid
	return self.allianceWarCell:getWatchingNum(kid)
end
function allianceWarCtrl:setWatchingNum(kid, num)
	print("allianceWarCtrl:setWatchingNum", kid, num)
	kid = kid or worldMapDefine.currentMapKindomID or self.kid
	self.allianceWarCell:setWatchingNum(kid, num or 0)
	_ENV = self.allianceWarCell
	self.allianceWarCell.msg = "MESSAGE_SERVER_LEGENDLORD_WATCHING_NUM"
	SoraDSendMessage(self.allianceWarCell)
end
return allianceWarCtrl
