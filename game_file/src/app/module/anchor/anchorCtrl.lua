local gamemodulec = include("GameModule")
local anchorCtrl = class("anchorCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
function anchorCtrl:reqAnchorRooms(data)
	dump(data, "anchorCtrl:reqAnchorRooms", 10)
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_RW_ROOMS, data)
end
function anchorCtrl:reqAnchorRwTeamMembers(teamId, mapId)
	mapId = mapId or worldMapDefine.currentMapKindomID
	print("anchorCtrl:reqAnchorRwTeamMembers", mapId, teamId)
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).teamId = teamId
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_RW_TEAM_MEMBERS, nil)
end
function anchorCtrl:reqAnchorRwPlayerPointsList(mapId, beAttackStatus)
	print("anchorCtrl:reqAnchorRwPlayerPointsList", mapId)
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).beAttackStatus = beAttackStatus
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_RW_PLAYER_POINTS_LIST, nil)
end
function anchorCtrl:reqSyncRW(mapId, uid)
	self:reqAnchorOtherLocalQueueSync(mapId, uid, true)
	if self.watchPlayerKid ~= mapId or self.watchPlayerUid ~= uid then
		self.watchPlayerKid = mapId
		self.watchPlayerUid = uid
		return true
	end
	return false
end
function anchorCtrl:reqStopSyncRW()
	if self.watchPlayerUid and self.watchPlayerKid ~= 0 then
		self:reqAnchorOtherLocalQueueSync(self.watchPlayerKid, self.watchPlayerUid, false)
		return true
	end
	return false
end
function anchorCtrl:reqRemainsWarData(mapId)
	print("anchorCtrl:reqRemainsWarData")
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_WAR_DATA, nil)
end
function anchorCtrl:reqAnchorOtherLocalQueueSync(mapId, uid, isSync)
	print("anchorCtrl:reqAnchorOtherLocalQueueSync", mapId, uid, isSync)
	_ENV = isSync
	isSync.mapId = mapId
	isSync.uid = uid
	isSync.isSync = isSync
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_OTHER_LOCAL_QUEUE_SYNC, isSync)
end
function anchorCtrl:setMailInfo(mapId, uid)
	print("anchorCtrl:setMailInfo", mapId, uid)
	self.mailPlayerKid = mapId
	self.mailPlayerUid = uid
end
function anchorCtrl:reqAnchorOtherMail(setType)
	print("anchorCtrl:reqAnchorOtherMail", self.mailPlayerKid, self.mailPlayerUid, setType)
	_ENV = setType
	setType.mapId = self.mailPlayerKid
	setType.uid = self.mailPlayerUid
	setType.setType = setType
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_OTHER_MAIL, setType)
end
function anchorCtrl:reqAnchorRwTeamExistPlayer(mapId, teamId)
	print("anchorCtrl:reqAnchorRwTeamExistPlayer", mapId, teamId)
	_ENV = nil
	;(nil).mapId = mapId
	;(nil).teamId = teamId
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_RW_TEAM_EXIST_PLAYER, nil)
end
function anchorCtrl:reqAnchorAllPlayerPos(mapId)
	print("anchorCtrl:reqAnchorAllPlayerPos", mapId)
	_ENV = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_ALL_PLAYER_POS, nil)
end
function anchorCtrl:reqQueueWatchTowerData(queueIds, ...)
	serverproxy = nil
	local (nil).queueIds, data = queueIds, nil
	serverproxy:Request(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_OTHER_QUEUE_WATCHTOWER_DATA, data, ...)
end
function anchorCtrl:hasWatchMap()
	return self.watchMapID and self.watchMapID ~= 0
end
function anchorCtrl:getWatchMap()
	return self.watchMapID or 0
end
function anchorCtrl:setWatchMap(mapID)
	self.watchMapID = mapID or 0
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_ANCHOR_WATCH"
	SoraDSendMessage(nil)
end
function anchorCtrl:ctor(properties)
	anchorCtrl.super.ctor(self, properties)
end
function anchorCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_RW_ROOMS, handler(self, self.anchorRoomsRSP))
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_RW_TEAM_MEMBERS, handler(self, self.anchorRwTeamMembersRSP))
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_RW_PLAYER_POINTS_LIST, handler(self, self.anchorRwPlayerPointsListRSP))
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_OTHER_LOCAL_QUEUE_SYNC, handler(self, self.anchorOtherLocalQueueSyncRSP))
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_OTHER_QUEUE_WATCHTOWER_DATA, handler(self, self.onRspQueueWatchTowerData))
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_OTHER_MAIL, handler(self, self.anchorOtherMailRSP))
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_RW_TEAM_EXIST_PLAYER, handler(self, self.anchorRwTeamExistPlayerRSP))
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_ALL_PLAYER_POS, handler(self, self.anchorAllPlayerPosRSP))
	msgCtrl.register(gCmd.CMD_ANCHOR_MODULE, gCmd.REQ_ANCHOR_WAR_DATA, handler(self, self.remainswarDataRSP))
	self:resetData()
end
function anchorCtrl:resetData()
	self.watchPlayerKid = 0
	self.watchPlayerUid = 0
	self.mailPlayerKid = 0
	self.mailPlayerUid = 0
end
function anchorCtrl:Logout()
	anchorCtrl.super.Logout(self)
	self:resetData()
end
function anchorCtrl:initClientData(data)
	if not data then
		return
	end
end
function anchorCtrl:onMsg(event)
	local data = event.data
	dump(data, "anchorCtrl:onMsg", 10)
	if data then
		for _, msg in pairs(data) do
		end
	end
end
function anchorCtrl:anchorRoomsRSP(event)
	dump(event, "anchorCtrl:anchorRoomsRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		if not retdata.rooms then
			local _ENV, roomList = retdata.rooms, retdata.rooms
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REMAINS_ANCHOR_ROOMS"
		;(nil).err = err
		;(nil).roomList = roomList
		;(nil).count = retdata.roomTotalCount or 0
		SoraDSendMessage(nil)
	else
		_ENV = retdata.rooms
		retdata.rooms.msg = "MESSAGE_SERVER_REMAINS_ANCHOR_ROOMS"
		retdata.rooms.err = err
		SoraDSendMessage(retdata.rooms)
	end
end
function anchorCtrl:anchorRwPlayerPointsListRSP(event)
	dump(event, "anchorCtrl:anchorRwPlayerPointsListRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		local _ENV, playerPointsList = "anchorCtrl:anchorRwPlayerPointsListRSP", rspdata or "anchorCtrl:anchorRwPlayerPointsListRSP"
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REMAINS_WAR_TEAM_INFO_POINT_DATA"
		;(nil).playerPointsList = playerPointsList
		SoraDSendMessage(nil)
	else
		_ENV = "anchorCtrl:anchorRwPlayerPointsListRSP"
		;("anchorCtrl:anchorRwPlayerPointsListRSP").playerPointsList, _ENV, ("anchorCtrl:anchorRwPlayerPointsListRSP").msg = SoraDSendMessage, SoraDSendMessage, "MESSAGE_SERVER_REMAINS_WAR_TEAM_INFO_POINT_DATA"
		SoraDSendMessage("anchorCtrl:anchorRwPlayerPointsListRSP")
	end
end
function anchorCtrl:anchorOtherLocalQueueSyncRSP(event)
	dump(event, "anchorCtrl:anchorOtherLocalQueueSyncRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
	else
	end
end
function anchorCtrl:anchorRwTeamMembersRSP(event)
	dump(event, "anchorCtrl:anchorRwTeamMembersRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local teamInfo = retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_INFO"
		;(nil).teamInfo = teamInfo
		;(nil).err = err
		SoraDSendMessage(nil)
	else
		_ENV = retdata
		retdata.msg = "MESSAGE_SERVER_REMAINS_TEAM_INFO"
		retdata.err = err
		SoraDSendMessage(retdata)
	end
end
function anchorCtrl:onRspQueueWatchTowerData(rsp)
	dump(rsp, "anchorCtrl:onRspQueueWatchTowerData", 10)
	if rsp.err == gErrDef.Err_None and rsp.rspdata and next(rsp.rspdata) then
		for _, queueData in pairs(rsp.rspdata) do
			local gametop = gModuleMgr.getObject("gametop")
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			local orgQueue = kingdomMapCtrl.kingdomMapCell.localQueueMgr:getQueue(queueData.id)
			if orgQueue then
				serviceFunctions.deepMerge(orgQueue:getData(), queueData)
				_ENV = orgQueue:getData()
				orgQueue:getData().msg = "MESSAGE_SERVER_WATCHTOWER_DETAILBACK"
				orgQueue:getData().data = orgQueue
				SoraDSendMessage((orgQueue:getData()))
			else
				_ENV = orgQueue:getData()
				orgQueue:getData().msg = "MESSAGE_SERVER_WATCHTOWER_DETAILBACK"
				SoraDSendMessage((orgQueue:getData()))
			end
		end
	else
		_ENV = pairs(rsp.rspdata)
		pairs(rsp.rspdata).msg = "MESSAGE_SERVER_WATCHTOWER_DETAILBACK"
		pairs(rsp.rspdata).err = rsp.err
		SoraDSendMessage(pairs(rsp.rspdata))
	end
end
function anchorCtrl:anchorOtherMailRSP(event)
	dump(event, "anchorCtrl:anchorOtherMailRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local data = event.data
		local rspData = event.rspdata
		local mailSetType = data.setType
		local pageNum = 0
		if tolua.type(mailSetType) == "table" then
			for i, setType in ipairs(mailSetType) do
				local list = rspData[tostring(setType)]
				for i, v in ipairs(list) do
					v.mailSetType = setType
					mailMgr:addMail(v, true)
				end
				pageNum = pageNum + #list
			end
		else
			local list = rspData
			for i, v in ipairs(list) do
				v.mailSetType = mailSetType
				mailMgr:addMail(v, true)
			end
			pageNum = pageNum + #list
		end
		_ENV = #list
		;(#list).msg = "MESSAGE_SERVER_MAIL_REQ_MAIL_TYPE_LIST_BACK"
		;(#list).mailSetType = mailSetType
		;(#list).num = pageNum
		SoraDSendMessage(#list)
	else
	end
end
function anchorCtrl:anchorRwTeamExistPlayerRSP(event)
	dump(event, "anchorCtrl:anchorRwTeamExistPlayerRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local uid = retdata.uid
		if uid and 0 < uid then
			local data = event.data
			local kid = data.mapId
			local teamId = data.teamId
			local anchorUtil = include("anchorUtil")
			anchorUtil.doAllianceWar(kid, uid, teamId)
		end
	else
	end
end
function anchorCtrl:anchorAllPlayerPosRSP(event)
	dump(event, "anchorCtrl:anchorAllPlayerPosRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local retData = event.rspdata
		if retData then
			local _ENV, ret = "anchorCtrl:anchorAllPlayerPosRSP", "anchorCtrl:anchorAllPlayerPosRSP"
			for _, v in pairs(retData) do
				table.insert(ret, v)
			end
			_ENV = pairs(retData)
			pairs(retData).msg = "MESSAGE_SERVER_WORLD_RESOURCE_MAP_MEMBERS"
			_ENV, _ENV, pairs(retData).data = nil, pairs(retData)
			pairs(retData).clientData, (nil).from = nil, "worldMapComUI"
			SoraDSendMessage(pairs(retData))
		end
	else
		_ENV = "anchorCtrl:anchorAllPlayerPosRSP"
		_ENV, _ENV, ("anchorCtrl:anchorAllPlayerPosRSP").data, _ENV, ("anchorCtrl:anchorAllPlayerPosRSP").msg = pairs(retData)
		SoraDSendMessage.clientData, pairs(retData).from = pairs(retData)
		SoraDSendMessage("anchorCtrl:anchorAllPlayerPosRSP", SoraDSendMessage)
	end
end
function anchorCtrl:remainswarDataRSP(event)
	dump(event, "anchorCtrl:remainswarDataRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_REMAINS_ANCHOR_SELECT_MAP"
		;(10).err = err
		;(10).warStatus = rspdata.warStatus
		SoraDSendMessage(10)
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_SERVER_REMAINS_ANCHOR_SELECT_MAP"
	SoraDSendMessage.err = err
	SoraDSendMessage(SoraDSendMessage)
end
return anchorCtrl
