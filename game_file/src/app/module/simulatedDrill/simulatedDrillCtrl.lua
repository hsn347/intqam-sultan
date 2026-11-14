local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local simulatedDrillCtrl = class("simulatedDrillCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
_ENV = "serverproxy"
;("serverproxy").WEST = 1
_ENV, SIMULATED_DRILL_WAR_CAMP, ("serverproxy").EAST = "serverproxy", "serverproxy", 2
;("serverproxy").READY = 1
MATCH_ROOM_STATE, ("serverproxy").START = "serverproxy", 2
function simulatedDrillCtrl:ctor(properties)
	simulatedDrillCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY
	self:resetData()
end
function simulatedDrillCtrl:EnterGame()
	local cmd_base = gCmd.CMD_SIMULATED_DRILL_WAR_MODULE
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_DATA, handler(self, self.reqWarDataRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_DATA, handler(self, self.reqRoomDataRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_LIST, handler(self, self.reqRoomListRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_SEARCH, handler(self, self.reqRoomSearchRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_CREATE, handler(self, self.reqRoomCreateRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_SET, handler(self, self.reqRoomSetRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_ENTER, handler(self, self.reqRoomEnterRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_QUIT, handler(self, self.reqRoomQuitRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_KICK, handler(self, self.reqRoomKickRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_CHANGE_SEAT, handler(self, self.reqRoomChangeSeatRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_READY, handler(self, self.reqRoomReadyRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_START, handler(self, self.reqRoomStartRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_SHARE, handler(self, self.reqRoomShareRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_QUIT_BATTLE_FIELD, handler(self, self.reqQuitBattleFieldRsp))
	msgCtrl.register(cmd_base, gCmd.REQ_SIMULATED_DRILL_WAR_PALACE_OCCUPY_LOG, handler(self, self.reqPalaceOccupyLogRsp))
	self:registerNotify()
end
function simulatedDrillCtrl:Logout()
	simulatedDrillCtrl.super.Logout(self)
	self:resetData()
end
function simulatedDrillCtrl:resetData()
	self.room = nil
	self.roomList, _UPVALUE0_, self.warData = nil, nil, nil
end
function simulatedDrillCtrl:initClientData(data)
	dump(data, "simulatedDrillCtrl:initClientData(data)", 10)
	if not data then
		return
	end
	self.room = data
end
function simulatedDrillCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.MATCH_ROOM, handler(self, self.notifyMatchRoomHandler))
	notifyCtrl:register(gNotifyID.SIMULATED_DRILL_WAR, handler(self, self.notifyWarHandler))
end
function simulatedDrillCtrl:notifyMatchRoomHandler(event)
	dump(event.data, "simulatedDrillCtrl:notifyMatchRoomHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "beKicked" then
			self.room = nil
			_ENV = nil
			;(nil).msg = "MESSAGE_SIMULATED_DRILL_ROOM_DATA"
			;(nil).subMsg = "beKicked"
			SoraDSendMessage(nil)
		elseif notifyType == "setRoom" then
			local _roomState = self:getRoomState()
			self.room = notifyData
			_ENV = nil
			;(nil).msg = "MESSAGE_SIMULATED_DRILL_ROOM_DATA"
			;(nil).subMsg = "setRoom"
			SoraDSendMessage(nil)
			local roomState = self:getRoomState()
			if roomState ~= _roomState and roomState == MATCH_ROOM_STATE.START then
				uiManager:show("SimulatedDrillReady")
			end
		elseif notifyType == "quitRoom" then
			self.room = nil
			_ENV = self:getRoomState()
			self:getRoomState().msg = "MESSAGE_SIMULATED_DRILL_ROOM_DATA"
			self:getRoomState().subMsg = "quitRoom"
			SoraDSendMessage((self:getRoomState()))
		end
	end
end
function simulatedDrillCtrl:notifyWarHandler(event)
	dump(event.data, "simulatedDrillCtrl:notifyWarHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "settleWar" then
			if not worldMapDefine.isInSimulatedDrill() then
				print("==simulatedDrillCtrl:notifyWarHandler=settleWar=1=")
				return
			end
			if not notifyData.campMap then
				local _ENV, campMap = notifyData.campMap, notifyData.campMap
			end
			local selfUid = SoraDGetPlayerID()
			local player = self:getPlayerByUid(selfUid, campMap)
			if not player or not player.isIn then
				print("==simulatedDrillCtrl:notifyWarHandler=settleWar=2=")
				return
			end
			local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
			kingdomMapCtrl:setIsBattleEnd(gKingdomClassType.simulatedDrill, true)
			SoraDRemoveAllPanelFromManager()
			_ENV = true
			;(true).notifyData = notifyData
			uiManager:show("SimulatedDrillResult", true)
		elseif notifyType == "setWarBuildingOwner" then
			local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
			kingdomMapCtrl:setWarBuildingOwner(worldMapDefine.currentMapKindomID, notifyData.buildId, notifyData.owner)
			_ENV = kingdomMapCtrl
			kingdomMapCtrl.msg = "MESSAGE_SIMULATED_DRILL_BUILD_OWNER"
			SoraDSendMessage(kingdomMapCtrl)
		elseif notifyType == "setCampScore" then
			self:setWarCampScore(notifyData.camp, notifyData.score)
			_ENV = self
			self.msg = "MESSAGE_SIMULATED_DRILL_CAMP_SCORE"
			SoraDSendMessage(self)
		end
	end
end
function simulatedDrillCtrl:reqWarData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_DATA, nil)
end
function simulatedDrillCtrl:reqWarDataRsp(content)
	dump(content, "simulatedDrillCtrl:reqWarDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.warData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SIMULATED_DRILL_WARDATA"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function simulatedDrillCtrl:reqRoomData()
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_DATA)
end
function simulatedDrillCtrl:reqRoomDataRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.room = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SIMULATED_DRILL_ROOM_DATA"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function simulatedDrillCtrl:reqRoomList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_LIST, nil)
end
function simulatedDrillCtrl:reqRoomListRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local roomList = content.rspdata
		self.roomList = roomList
		_ENV = "simulatedDrillCtrl:reqRoomListRsp(content)"
		;("simulatedDrillCtrl:reqRoomListRsp(content)").msg = "MESSAGE_SIMULATED_DRILL_ROOM_LIST"
		;("simulatedDrillCtrl:reqRoomListRsp(content)").roomList = roomList
		SoraDSendMessage("simulatedDrillCtrl:reqRoomListRsp(content)")
	end
end
function simulatedDrillCtrl:reqRoomSearch(roomId, from)
	serverproxy = nil
	serverproxy, (nil).roomId = nil, roomId
	;(nil).from = from
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_SEARCH, nil, nil)
end
function simulatedDrillCtrl:reqRoomSearchRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomSearchRsp(content)", 10)
	local from = content.clientData.from
	if from == "joinRoom" then
		if content.err == gErrDef.Err_None then
			local room = content.rspdata
			if not room.hasPassword then
				local _room = self:getRoomInfo(room.roomId)
				if _room then
					_room.hasPassword = false
				end
				_ENV = room.roomId
				room.roomId.msg = "MESSAGE_SIMULATED_DRILL_ROOM_LIST"
				room.roomId.roomList = self.roomList
				SoraDSendMessage(room.roomId)
				self:reqRoomEnter(room.roomId, nil, nil, room.createTime, "roomList")
			end
		end
		return
	end
	if content.err == gErrDef.Err_None then
		local room = content.rspdata
		if room and not room.private then
			_UPVALUE1_ = room.private
			local room.private[1], roomList = room, room.private
			self.roomList = roomList
			_ENV = self
			self.msg = "MESSAGE_SIMULATED_DRILL_ROOM_LIST"
			self.roomList = roomList
			SoraDSendMessage(self)
		else
			SoraDShowMsgTip(i18n("simulated_drill_text_01"))
		end
	else
		SoraDShowMsgTip(i18n("simulated_drill_text_01"))
	end
end
function simulatedDrillCtrl:reqRoomCreate(private, password)
	serverproxy = nil
	;(nil).private = private
	;(nil).password = password
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_CREATE, nil)
end
function simulatedDrillCtrl:reqRoomCreateRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomCreateRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self.room = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SIMULATED_DRILL_ROOM_DATA"
		gErrDef.Err_None.subMsg = "create"
		SoraDSendMessage(gErrDef.Err_None)
	elseif content.err == gErrDef.Err_MATCH_ROOM_ALL_IN_USED then
		SoraDShowMsgTip(i18n("simulated_drill_text_14"))
	elseif content.err == gErrDef.Err_RUINS_WAR_HAS_MASS_QUEUE then
		SoraDShowMsgTip(i18n("simulated_drill_text_53"))
	elseif content.err == gErrDef.Err_RADIANCE_WAR_PLAYER_BEING_ATTACKED then
		SoraDShowMsgTip(i18n("simulated_drill_text_53"))
	end
end
function simulatedDrillCtrl:reqRoomSet(private, password)
	serverproxy = nil
	;(nil).private = private
	;(nil).password = password
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_SET, nil)
end
function simulatedDrillCtrl:reqRoomSetRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomSetRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.room = content.rspdata
		SoraDShowMsgTip(i18n("simulated_drill_text_48"))
	end
end
function simulatedDrillCtrl:reqRoomEnter(roomId, key, password, createTime, from)
	serverproxy = nil
	;(nil).roomId = roomId
	;(nil).key = key
	;(nil).password = password
	local (nil).createTime, data = createTime, nil
	serverproxy = nil
	;(nil).from = from
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_ENTER, data, nil)
end
function simulatedDrillCtrl:reqRoomEnterRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomEnterRsp(content)", 10)
	local from = content.clientData.from
	if content.err == gErrDef.Err_None then
		self.room = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SIMULATED_DRILL_ROOM_DATA"
		gErrDef.Err_None.subMsg = "enter"
		SoraDSendMessage(gErrDef.Err_None)
		if from == "chat" then
			SoraDRemoveAllPanelFromManager()
			uiManager:show("SimulatedDrillRoom")
		end
	elseif content.err == gErrDef.Err_MATCH_ROOM_NOT_EXIST or content.err == gErrDef.Err_MATCH_ROOM_NOT_READY then
		SoraDShowMsgTip(i18n("simulated_drill_text_03"))
		if from == "roomList" then
			self:reqRoomList()
			uiManager:close("SimulatedDrillJoinRoom")
		end
	elseif content.err == gErrDef.Err_MATCH_ROOM_WRONG_PASSWORD then
		local data = content.data
		if not data.password then
			local _room = self:getRoomInfo(data.roomId)
			if _room then
				_room.hasPassword = true
				_ENV = i18n("simulated_drill_text_03")
				i18n("simulated_drill_text_03").room = _room
				uiManager:show("SimulatedDrillJoinRoom", i18n("simulated_drill_text_03"))
				_ENV = uiManager
				uiManager.msg = "MESSAGE_SIMULATED_DRILL_ROOM_LIST"
				uiManager.roomList = self.roomList
				SoraDSendMessage(uiManager)
			end
		else
			SoraDShowMsgTip(i18n("Safety_lock_text_06"))
		end
	elseif content.err == gErrDef.Err_MATCH_ROOM_PLAYER_FULL then
		SoraDShowMsgTip(i18n("simulated_drill_text_04"))
		if from == "roomList" then
			self:reqRoomList()
			uiManager:close("SimulatedDrillJoinRoom")
		end
	elseif content.err == gErrDef.Err_MATCH_ROOM_PLAYER_IN_KICKED_CD then
		local kickTime = content.rspdata
		local kickCD = CONST_VALUE.SIMULATED_DRILL_KICK_OUT_CD or 0
		local remainTime = kickTime + kickCD - serviceFunctions.systemTime()
		remainTime = math.max(0, remainTime)
		_ENV = i18n("simulated_drill_text_04")
		i18n("simulated_drill_text_04").time = remainTime .. "s"
		SoraDShowMsgTip(i18n("simulated_drill_text_05", i18n("simulated_drill_text_04")))
	elseif content.err == gErrDef.Err_RUINS_WAR_HAS_MASS_QUEUE then
		SoraDShowMsgTip(i18n("simulated_drill_text_06"))
	elseif content.err == gErrDef.Err_RADIANCE_WAR_PLAYER_BEING_ATTACKED then
		SoraDShowMsgTip(i18n("simulated_drill_text_06"))
	else
		SoraDShowMsgTip(i18n("recallfriends_text_04"))
	end
end
function simulatedDrillCtrl:reqRoomQuit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_QUIT, nil)
end
function simulatedDrillCtrl:reqRoomQuitRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomQuitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.room = nil
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SIMULATED_DRILL_ROOM_DATA"
		gErrDef.Err_None.subMsg = "quit"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function simulatedDrillCtrl:reqRoomKick(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_KICK, nil)
end
function simulatedDrillCtrl:reqRoomKickRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomKickRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.room = content.rspdata
	end
end
function simulatedDrillCtrl:reqRoomChangeSeat(camp, rank)
	serverproxy = nil
	;(nil).camp = camp
	;(nil).rank = rank
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_CHANGE_SEAT, nil)
end
function simulatedDrillCtrl:reqRoomChangeSeatRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomChangeSeatRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.room = content.rspdata
	elseif content.err == gErrDef.Err_MATCH_ROOM_PLAYER_IN_READY then
		SoraDShowMsgTip(i18n("simulated_drill_text_55"))
	end
end
function simulatedDrillCtrl:reqRoomReady(ready)
	serverproxy = nil
	;(nil).ready = ready
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_READY, nil)
end
function simulatedDrillCtrl:reqRoomReadyRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomReadyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.room = content.rspdata
	end
end
function simulatedDrillCtrl:reqRoomStart()
	if not self:checkRoomReady() then
		SoraDShowMsgTip(i18n("simulated_drill_text_26"))
		return
	end
	_ENV = i18n("simulated_drill_text_26")
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_START, i18n("simulated_drill_text_26"))
end
function simulatedDrillCtrl:checkRoomReady()
	local campMap = self:getRoomCampMap()
	for __, campData in pairs(campMap) do
		for __, player in pairs(campData.players) do
			if not player.ready then
				return false
			end
		end
	end
	return true
end
function simulatedDrillCtrl:reqRoomStartRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomStartRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	elseif content.err == gErrDef.Err_MATCH_ROOM_PLAYER_NOT_READY then
		SoraDShowMsgTip(i18n("simulated_drill_text_26"))
	elseif content.err == gErrDef.Err_MATCH_ROOM_CAMP_NO_PLAYER then
		SoraDShowMsgTip(i18n("simulated_drill_text_27"))
	elseif content.err == gErrDef.Err_MATCH_ROOM_PLAYER_CANT_ENTER_WAR then
		local nameStr = ""
		local playerList = content.rspdata
		for _, player in ipairs(playerList) do
			nameStr = nameStr .. "," .. player.name
		end
		_ENV = i18n("simulated_drill_text_27")
		i18n("simulated_drill_text_27").name = nameStr
		SoraDShowMsgTip(i18n("simulated_drill_text_28", i18n("simulated_drill_text_27")))
	elseif content.err == gErrDef.Err_MATCH_ROOM_ALL_IN_USED then
		SoraDShowMsgTip(i18n("simulated_drill_text_56"))
	end
end
function simulatedDrillCtrl:reqRoomShare(toUids, toAlliance, toKingdom)
	serverproxy = nil
	;(nil).toUids = toUids
	;(nil).toAlliance = toAlliance
	;(nil).toKingdom = toKingdom
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_ROOM_SHARE, nil)
end
function simulatedDrillCtrl:reqRoomShareRsp(content)
	dump(content, "simulatedDrillCtrl:reqRoomShareRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0103"))
	end
end
function simulatedDrillCtrl:reqQuitBattleField()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_QUIT_BATTLE_FIELD, nil)
end
function simulatedDrillCtrl:reqQuitBattleFieldRsp(content)
	dump(content, "simulatedDrillCtrl:reqQuitBattleFieldRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.room = nil
	end
end
function simulatedDrillCtrl:reqPalaceOccupyLog(palaceId, iBegin, nCount, mapId)
	serverproxy = nil
	;(nil).palaceId = palaceId
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	local (nil).mapId, data = mapId, nil
	serverproxy:Request(gCmd.CMD_SIMULATED_DRILL_WAR_MODULE, gCmd.REQ_SIMULATED_DRILL_WAR_PALACE_OCCUPY_LOG, data)
end
function simulatedDrillCtrl:reqPalaceOccupyLogRsp(content)
	dump(content, "simulatedDrillCtrl:reqPalaceOccupyLogRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACE"
		gErrDef.Err_None.retdate = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function simulatedDrillCtrl:getSelfRoom()
	return self.room
end
function simulatedDrillCtrl:getRoomCampMap()
	local room = self:getSelfRoom()
	if not room or not room.campMap then
		_UPVALUE0_ = room.campMap
	end
	return room.campMap
end
function simulatedDrillCtrl:getRoomCampPlayers(camp)
	local campMap = self:getRoomCampMap()
	return campMap[camp].players
end
function simulatedDrillCtrl:getRoomCampPlayerList(camp)
	local selfUid = SoraDGetPlayerID()
	local players = self:getRoomCampPlayers(camp)
	local playerList = table.values(players)
	table.sort(playerList, function(a, b)
		local isSelfA = a.uid == selfUid
		local isSelfB = b.uid == selfUid
		if isSelfA ~= isSelfB then
			return isSelfA
		end
		return a.rank < b.rank
	end)
	return playerList
end
function simulatedDrillCtrl:checkSelfIsHost()
	local room = self:getSelfRoom()
	if not room then
		return false
	end
	local selfUid = SoraDGetPlayerID()
	return room.host.uid == selfUid
end
function simulatedDrillCtrl:checkSelfIsReady()
	local room = self:getSelfRoom()
	if not room then
		return false
	end
	local selfUid = SoraDGetPlayerID()
	local player = self:getPlayerByUid(selfUid)
	if player then
		return player.ready
	end
	return false
end
function simulatedDrillCtrl:getPlayerByUid(uid, campMap)
	campMap = campMap or self:getRoomCampMap()
	for __, campData in pairs(campMap) do
		for __, player in pairs(campData.players) do
			if player.uid == uid then
				return player
			end
		end
	end
end
function simulatedDrillCtrl:getRoomName()
	local room = self:getSelfRoom()
	local roomId = room.roomId
	return tostring(roomId)
end
function simulatedDrillCtrl:getRoomPrivate()
	local room = self:getSelfRoom()
	return room.private
end
function simulatedDrillCtrl:getRoomPassword()
	local room = self:getSelfRoom()
	return room.password
end
function simulatedDrillCtrl:getRoomPlayerCount(room)
	room = room or self:getSelfRoom()
	local campMap = room.campMap
	local ret = 0
	for _, camp in pairs(campMap) do
		ret = ret + table.nums(camp.players)
	end
	return ret
end
function simulatedDrillCtrl:getRoomPlayerMax()
	return 16
end
function simulatedDrillCtrl:getSelfCamp()
	local selfUid = SoraDGetPlayerID()
	local player = self:getPlayerByUid(selfUid)
	return player and player.camp
end
function simulatedDrillCtrl:checkSameRoom(room1, room2)
	return room1.roomId == room2.roomId and room1.createTime == room2.createTime
end
function simulatedDrillCtrl:getChannelID(...)
	local room = self:getSelfRoom()
	return room.channelId or 0
end
function simulatedDrillCtrl:getRoomState()
	local room = self:getSelfRoom()
	return room and room.state or MATCH_ROOM_STATE.READY
end
function simulatedDrillCtrl:getWarData()
	return self.warData
end
function simulatedDrillCtrl:getWarTipRemainTime()
	if not self:getWarData() then
		local _ENV, warData = self:getWarData(), self:getWarData()
	end
	local startTime = warData.startTime
	if startTime then
		local remainTime = startTime - serviceFunctions.systemTime()
		return remainTime
	end
	return 0
end
function simulatedDrillCtrl:getWarRemainTime()
	if not self:getWarData() then
		local _ENV, warData = self:getWarData(), self:getWarData()
	end
	local endTime = warData.endTime
	if endTime then
		local remainTime = endTime - serviceFunctions.systemTime()
		return remainTime
	end
	return 0
end
function simulatedDrillCtrl:getWarCampScore(camp)
	if not self:getWarData() then
		local _UPVALUE0_, warData = self:getWarData(), self:getWarData()
	end
	local campMap = warData.campMap
	if not campMap then
		return 0
	end
	return campMap[camp].occupyScore
end
function simulatedDrillCtrl:setWarCampScore(camp, score)
	if not self:getWarData() then
		local _UPVALUE0_, warData = self:getWarData(), self:getWarData()
	end
	local campMap = warData.campMap
	if not campMap then
		return
	end
	campMap[camp].occupyScore = score
end
function simulatedDrillCtrl:getMyTeamInfo()
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	local teamDef = include("teamDef")
	local teamType = teamDef.teamAreaEnum.ACTIVITY_9001725
	return teamCtrl:getTeamData(teamType)
end
function simulatedDrillCtrl:isHasNewTeamMsg()
	local myTeamInfo = self:getMyTeamInfo()
	return myTeamInfo:isHasNewTeamMsg()
end
function simulatedDrillCtrl:getRoomList()
	if not self.roomList then
		_UPVALUE0_ = self.roomList
	end
	return self.roomList
end
function simulatedDrillCtrl:getRoomInfo(roomId)
	local roomList = self:getRoomList()
	for _, room in ipairs(roomList) do
		if room.roomId == roomId then
			return room
		end
	end
end
return simulatedDrillCtrl
