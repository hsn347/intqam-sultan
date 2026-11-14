local gamemodulec = include("GameModule")
local kingdomMapCtrl = class("kingdomMapCtrl", gamemodulec)
local kingdomMapCell = include("kingdomMapCell")
local msgCtrl = include("msgCtrl")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local worldMapDefine = include("worldMapDefine")
local queueTimeUtil = include("queueTimeUtil")
local socket = require("socket")
function kingdomMapCtrl:ctor(properties)
	kingdomMapCtrl.super.ctor(self, properties)
	self:initData()
end
gQueueSyncMsgType = _G.gQueueSyncMsgType
gMapSyncMsgType = _G.gMapSyncMsgType
gErrDef = _G.gErrDef
function kingdomMapCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_OBJ_INFO, handler(self, self.reqMapObjInfoRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_RELICS_EVENT, handler(self, self.reqRelicsEventRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_ALLIANCE_MEMBER, handler(self, self.reqAllianceRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_COLLECTING_INFO, handler(self, self.reqGetCollectingInfoRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_CASTLE_MAP_INFO, handler(self, self.reqGetCastleMapInfoRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_SCOUT_FOOD, handler(self, self.reqGetScoutFoodRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_PLACE_OWNER_INFO, handler(self, self.reqGetPlaceOwnerInfoRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_OTHER_KINGDOM_INFO, handler(self, self.reqGetOtherKingdomInfoRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_ALL_QUEUE_ID_IN_SUPER_RES, handler(self, self.reqAllQueueIdInSuperResRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_SUPER_RES_QUEUES_BY_IDS, handler(self, self.reqSuperResQueueByIdsRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_CAN_MOVECITY_IN_TERR, handler(self, self.reqCanMoveCityInTerrRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_PLAYER_CHEST_DAY_RECEIVE_COUNT, handler(self, self.reqPlayerChestDayReceiveRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_EXIT_ALLIANCE_WAR, handler(self, self.reqExitAllianceWarRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_TREASURE_BOWL_DAY_RECEIVE_COUNT, handler(self, self.reqTreasureBowlDayReceiveRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_CLICK_TREASURE_BOWL, handler(self, self.reqClickTreasureBowlRsp))
	msgCtrl.register(gCmd.CMD_ICE_SNOW_WONDER_MODULE, gCmd.REQ_ICE_SNOW_WONDER_INIT, handler(self, self.reqInitSnowWonderRsp))
	msgCtrl.register(gCmd.CMD_ICE_SNOW_WONDER_MODULE, gCmd.REQ_ICE_SNOW_WONDER_BEGIN_BREAK, handler(self, self.reqClickSnowWonderRsp))
	msgCtrl.register(gCmd.CMD_ICE_SNOW_WONDER_MODULE, gCmd.REQ_ICE_SNOW_WONDER_END_BREAK, handler(self, self.reqCancleSnowWonderRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_TERR_LINE, handler(self, self.onRspMapAllAllianceBuilding))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_SYNC, handler(self, self.onRspMapSync))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_MOVE_CITY, handler(self, self.onRspMoveCity))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_SPEED_QUEUE, handler(self, self.reqSpeedQueueRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_ARMY_HELP_NUM, handler(self, self.reqArmyHelpNumRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.ADD_KINGDOM_QUEUE, handler(self, self.addKingdomQueueRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_MAP_DATA, handler(self, self.onRspQueueMapData))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_WATCHTOWER_DATA, handler(self, self.onRspQueueWatchTowerData))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_LOCAL_QUEUE_SYNC, handler(self, self.onRspLocalQueueSync))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_SET_FORBID_SPEED_QUEUE, handler(self, self.onRspSetQueueForbidSpeed))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_BACK_QUEUE, handler(self, self.reqBackQueueRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_BACK_QUEUE_BY_ID, handler(self, self.reqBackQueueByIdRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_EXPLORE_DESERT_METEORITE_EVENT, handler(self, self.onRspExploreDesertMeteoriteEvent))
	msgCtrl.register(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_SET_MASS, handler(self, self.onRspSetMass))
	self.kid = gametop.playertop_:getMapID()
	self.uid = gametop.playertop_:getPlayerID()
	self.kingdomMapCell = kingdomMapCell.new(self.kid, self.uid)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handleWorldNotify = notifyCtrl:register(gNotifyID.WORLD, handler(self, self.updateDataRsp))
	self.treasureBowlNotify = notifyCtrl:register(gNotifyID.TREASURE_BOWL, handler(self, self.treasureBowlRsp))
	notifyCtrl:register(gNotifyID.MAP_DATA, handler(self, self.onNotifyMapData))
	notifyCtrl:register(gNotifyID.MAP_SYNC, handler(self, self.onNotifyMapSyncData))
	notifyCtrl:register(gNotifyID.LOCAL_QUEUE_SYNC, handler(self, self.onNotifyLocalQueueSyncData))
	notifyCtrl:register(gNotifyID.SWITCH_MAP, handler(self, self.onNotifySwitchMapType))
	local linkCtrl = gametop.playertop_:getModule("linkCtrl")
	linkCtrl:addEventListener(linkCtrl.EVENT_SWITCH, handler(self, self.onSwitch))
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:addEventListener(tostring(gQueueTypeDef.king_war_rank_pack), handler(self, self.kingWarRankPackQueueCallback))
	self:reqLocalQueueSync()
end
function kingdomMapCtrl:initData()
	if self.guideTimer then
		SoraDManagerRemoveTimer(self, self.guideTimer)
		self.guideTimerSecond = 0
		self.guideTimer = nil
	end
	self.treasureBowlObj = nil
	self.snowWonderObj = nil
	if self.WLCTimer then
		SoraDManagerRemoveTimer(self, self.WLCTimer)
		self.WLCTimerSecond = 0
		self.WLCTimer = nil
	end
	self.warDamagedReward = nil
	self:resetLocalQueueSyncData()
	self:resetMapObjsSyncData()
	self.isBattleEnd, _ENV, self.mapSyncData, _ENV = self.resetMapObjsSyncData, self.resetMapObjsSyncData, self.resetMapObjsSyncData, self.resetMapObjsSyncData
	self.kingdomStartTime = 0
end
function kingdomMapCtrl:Logout()
	kingdomMapCtrl.super.Logout(self)
	gCollectTempData, kingdomMapCtrl = kingdomMapCtrl.super.Logout, kingdomMapCtrl.super.Logout
	self:initData()
end
function kingdomMapCtrl:reqMapAllAllianceBuilding(mapId, ver, ...)
	local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
	if kingdomCtrl:isFoundKingdomID(mapId) then
		gametop = kingdomCtrl:isFoundKingdomID(mapId)
		kingdomCtrl:isFoundKingdomID(mapId).mapId = mapId
		local kingdomCtrl:isFoundKingdomID(mapId).ver, data = ver, kingdomCtrl:isFoundKingdomID(mapId)
		serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_TERR_LINE, data, ...)
	end
end
function kingdomMapCtrl:reqMapSync(centerKid, centerX, centerY, lod, mapPieceIds, ...)
	serverproxy = nil
	;(nil).centerKid = centerKid
	;(nil).centerX = centerX
	;(nil).centerY = centerY
	;(nil).mapPieceIds = mapPieceIds
	local (nil).lod, data = lod, nil
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_SYNC, data, ...)
	self.lastReqMapSyncData = data
end
function kingdomMapCtrl:reqLocalQueueSync(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_LOCAL_QUEUE_SYNC, nil, ...)
end
function kingdomMapCtrl:reqQueueMapData(kid, queueId, ...)
	serverproxy = nil
	;(nil).kid = kid
	local (nil).queueId, data = queueId, nil
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_MAP_DATA, data, ...)
end
function kingdomMapCtrl:reqQueueWatchTowerData(queueIds, ...)
	serverproxy = nil
	local (nil).queueIds, data = queueIds, nil
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_WATCHTOWER_DATA, data, ...)
end
function kingdomMapCtrl:onSwitchWorldMap(switchWorldMapType, kingdomId, ...)
	print("kingdomMapCtrl:onSwitchWorldMap(switchWorldMapType) switchWorldMapType=", switchWorldMapType, ",kingdomId=", kingdomId)
	if switchWorldMapType == gSwitchWorldMapTypeDef.switchWorldMapType_out and worldMapDefine.currentMapKindomID == kingdomId then
		_ENV = kingdomId
		kingdomId.switchFlag = switchWorldMapType
		serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_SWITCH_WORLD_MAP, kingdomId, ...)
		self.kingdomMapCell:onOutMap()
	end
	if switchWorldMapType == gSwitchWorldMapTypeDef.switchWorldMapType_in and self.kid ~= worldMapDefine.currentMapKindomID then
		local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
		if kingdomCtrl:isFoundKingdomID(kingdomId) and not worldMapDefine.isLegendLordKingdomID(kingdomId) then
			_ENV = ...
			....kid = kingdomId
			serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_OTHER_KINGDOM_INFO, ...)
		end
	end
end
function kingdomMapCtrl:reqMarch(data, ...)
	local kingdomClass = self:getKingdomClass()
	if kingdomClass == gKingdomClassType.pyramid then
		if data.data.to and data.data.to.x and data.data.to.y then
			local allianceWarltCtrl = include("allianceWarltCtrl")
			local allianceBuilding = allianceWarltCtrl.getAllianceWarBuildingByPos(data.data.to.x, data.data.to.y)
			if allianceBuilding then
				data.data.to.x = allianceBuilding.x
				data.data.to.y = allianceBuilding.y
			end
		end
	elseif kingdomClass == gKingdomClassType.legendLord then
		if data.data.to and data.data.to.x and data.data.to.y then
			local legendLordWarltCtrl = include("legendLordWarltCtrl")
			local legendLordBuilding = legendLordWarltCtrl.getLegendLordWarBuildingByPos(data.data.to.x, data.data.to.y, worldMapDefine.currentMapKindomID)
			if legendLordBuilding then
				data.data.to.x = legendLordBuilding.x
				data.data.to.y = legendLordBuilding.y
			end
		end
	elseif kingdomClass == gKingdomClassType.roaringFlame then
		local instanceID = data.data.to.id
		if instanceID then
			local kingdomMapUtil = include("kingdomMapUtil")
			local __, __, mapType, __, __ = kingdomMapUtil.gSplitId(instanceID)
			if mapType == gMapObjTypeDef.roaringFlameWarNpc then
				local roaringFlameWarUtil = include("roaringFlameWarUtil")
				local rate = roaringFlameWarUtil.getMonsterRate()
				data.data.data.rate = rate
			end
		end
	elseif worldMapDefine.isInAtlantis() or self.kid == 376 then
		local buffCtrl = SoraDGetCtrl("buffCtrl")
		local value, list = buffCtrl:getBuffEffectWithList(gBuffEffect.MARCH_LIMIT_BOOST)
		data.marchBuffList = list
		local value, list = buffCtrl:getBuffEffectWithList(gBuffEffect.MARCH_VALUE_LIMIT_BOOST)
		data.marchValueBuffList = list
	end
	dump(data, "addKingdomQueue", 10)
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.ADD_KINGDOM_QUEUE, data, ...)
end
function kingdomMapCtrl:reqMapObjInfo(x, y, id, kingdomId, ...)
	x, y = tonumber(x), tonumber(y)
	kingdomId = kingdomId or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).x = x
	;(nil).y = y
	;(nil).id = id
	;(nil).kingdomId = kingdomId
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_OBJ_INFO, nil, ...)
end
function kingdomMapCtrl:reqRelicsEvent(x, y, id, index, ...)
	serverproxy = nil
	;(nil).x = x
	;(nil).y = y
	;(nil).id = id
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_RELICS_EVENT, nil, ...)
end
function kingdomMapCtrl:reqExploreDesertMeteoriteEvent(x, y, id, index, ...)
	print("kingdomMapCtrl:reqExploreDesertMeteoriteEvent", x, y, id, index, ...)
	_ENV = id
	id.x = x
	id.y = y
	id.id = id
	id.index = index
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_EXPLORE_DESERT_METEORITE_EVENT, id, ...)
end
function kingdomMapCtrl:reqAllianceMember(kid, tid, ...)
	serverproxy = nil
	;(nil).mapId = kid
	;(nil).teamId = tid
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_ALLIANCE_MEMBER, nil, ...)
end
function kingdomMapCtrl:reqBackQueue(x, y, id, uid, ...)
	serverproxy = nil
	;(nil).x = x
	;(nil).y = y
	;(nil).id = id
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_BACK_QUEUE, nil, ...)
end
function kingdomMapCtrl:reqBackQueueById(queueId, ...)
	serverproxy = nil
	;(nil).queueId = queueId
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_BACK_QUEUE_BY_ID, nil, ...)
end
function kingdomMapCtrl:reqBackAllQueue(queueIds, ...)
	serverproxy = nil
	;(nil).queueIds = queueIds
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_BACK_ALL_QUEUE, nil, ...)
end
function kingdomMapCtrl:reqMoveCity(itemId, x, y, mode, kingdomId, ...)
	serverproxy = nil
	;(nil).x = x
	;(nil).y = y
	;(nil).itemId = itemId
	;(nil).mode = mode
	;(nil).kingdomId = kingdomId
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_MOVE_CITY, nil, ...)
end
function kingdomMapCtrl:reqSpeedQueue(itemId, queueId, mode, ...)
	mode = mode or BUILD_EXCHANGE_MODE.TOOLS
	local queue = self.kingdomMapCell.localQueueMgr:getQueue(queueId)
	if queue and queue:getUid() ~= self.uid then
		local mySlaveQueue = self.kingdomMapCell.localUserQueueMgr:getMySalveQueueByMainQueue(queue)
		if mySlaveQueue then
			queueId = mySlaveQueue:getId()
		end
	end
	if queueId then
		_ENV = nil
		;(nil).queueId = queueId
		;(nil).itemId = itemId
		;(nil).mode = mode
		serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_SPEED_QUEUE, nil, ...)
	end
end
function kingdomMapCtrl:reqRecallQueue(itemId, queueId, mode, ...)
	mode = mode or BUILD_EXCHANGE_MODE.TOOLS
	_ENV = nil
	;(nil).queueId = queueId
	;(nil).itemId = itemId
	;(nil).mode = mode
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_RECALL_QUEUE, nil, ...)
end
function kingdomMapCtrl:reqGetCollectingInfo(x, y, id, ...)
	serverproxy = nil
	;(nil).x = x
	;(nil).y = y
	;(nil).id = id
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_COLLECTING_INFO, nil, ...)
end
function kingdomMapCtrl:reqGetScoutFood(uid, x, y, id, mapType, ...)
	if uid then
		serverproxy = nil
		;(nil).uid = uid
		;(nil).x = x
		;(nil).y = y
		;(nil).id = id
		;(nil).mapType = mapType
		serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_SCOUT_FOOD, nil, ...)
	else
		local placeId = self.kingdomMapCell:getPlaceIdByXY(x, y)
		if placeId then
			local placeOwner = self.kingdomMapCell:getPlaceOwnerInfo(self.kid, placeId)
			if placeOwner and placeOwner.uid then
				serverproxy = ...
				....uid = placeOwner.uid
				....x = x
				....y = y
				....id = id
				....mapType = mapType
				serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_SCOUT_FOOD, ...)
			end
		end
	end
end
function kingdomMapCtrl:reqDismissQueue(queueId, ...)
	serverproxy = nil
	;(nil).queueId = queueId
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_DISMISS_QUEUE, nil, ...)
end
function kingdomMapCtrl:reqGetCastleMapInfo(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_CASTLE_MAP_INFO, nil, ...)
end
function kingdomMapCtrl:reqArmyHelpNum(uid, mapObjId, ...)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).mapObjId = mapObjId
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_ARMY_HELP_NUM, nil, ...)
end
function kingdomMapCtrl:reqSuperResQueuesByIds(x, y, mapObjId, queueIds, ...)
	if queueIds and #queueIds == 0 then
		queueIds = nil
	end
	serverproxy = nil
	;(nil).x = x
	;(nil).y = y
	;(nil).mapObjId = mapObjId
	;(nil).queueIds = queueIds
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_SUPER_RES_QUEUES_BY_IDS, nil, ...)
end
function kingdomMapCtrl:reqRefreshKingdomWarTime(...)
end
function kingdomMapCtrl:reqCanMoveCityInTerr(x, y, ...)
	serverproxy = nil
	;(nil).x = x
	;(nil).y = y
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_CAN_MOVECITY_IN_TERR, nil, ...)
end
function kingdomMapCtrl:reqGetPlayerChestDayReceiveInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_PLAYER_CHEST_DAY_RECEIVE_COUNT, data)
end
function kingdomMapCtrl:reqExitAllianceWar()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_EXIT_ALLIANCE_WAR, data)
end
function kingdomMapCtrl:reqGetTreasureBowlDayReceiveInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_TREASURE_BOWL_DAY_RECEIVE_COUNT, data)
end
function kingdomMapCtrl:reqClickTreasureBowl(x, y, count)
	local serverproxy, data
	data.x = x
	data.y = y
	data.count = count
	if count == 1 or self.treasureBowlObj and self.treasureBowlObj.clickcount == count then
		data.countResult = count * count + 7 * count + 17
		serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_CLICK_TREASURE_BOWL, data)
	end
end
function kingdomMapCtrl:reqInitSnowWonder()
	print("发送 玩家敲击冰锥初信息")
	serverproxy:Request(gCmd.CMD_ICE_SNOW_WONDER_MODULE, gCmd.REQ_ICE_SNOW_WONDER_INIT)
end
function kingdomMapCtrl:reqClickSnowWonder(x, y)
	print("发送 玩家敲击冰锥")
	local _ENV, data = print, print
	data.x = x
	data.y = y
	serverproxy:Request(gCmd.CMD_ICE_SNOW_WONDER_MODULE, gCmd.REQ_ICE_SNOW_WONDER_BEGIN_BREAK, data)
end
function kingdomMapCtrl:reqCancleSnowWonder(x, y, knockcount)
	local serverproxy, data
	data.x = x
	data.y = y
	data.knockcount = knockcount
	serverproxy:Request(gCmd.CMD_ICE_SNOW_WONDER_MODULE, gCmd.REQ_ICE_SNOW_WONDER_END_BREAK, data)
end
function kingdomMapCtrl:onRspMapAllAllianceBuilding(rsp)
	if not (rsp.err == gErrDef.Err_None and rsp.data) or next(rsp.data) then
	end
end
function kingdomMapCtrl:onRspMapSync(rsp)
	if rsp.err == gErrDef.Err_None then
		if rsp.addPieceIds then
			if next(rsp.addPieceIds) then
				self.kingdomMapCell:setAddPieceIds(rsp.addPieceIds)
			elseif self.kingdomMapCell:isReceivedDataEnd() then
				_ENV = self.kingdomMapCell
				self.kingdomMapCell.msg = "MESSAGE_SERVER_WORLD_MAP_GET_RECT_DATA"
				self.kingdomMapCell.data, _ENV, self.kingdomMapCell.dataEnd = rsp.addPieceIds, rsp.addPieceIds, true
				SoraDSendMessage(self.kingdomMapCell, nil)
			end
		end
		if rsp.delPieceIds and next(rsp.delPieceIds) then
			local currViewPieceIds = rsp.data.mapPieceIds
			if not currViewPieceIds then
				local mapSyncUtilClient = include("mapSyncUtilClient")
				local viewPieceIds = mapSyncUtilClient.getViewPieceIds(rsp.data.centerX, rsp.data.centerY, rsp.data.kingdomClass)
				_ENV = rsp.data.centerX
				currViewPieceIds, rsp.data.centerX[rsp.data.centerKid] = rsp.data.centerX, viewPieceIds
			end
			self.kingdomMapCell:delPieceIds(rsp.delPieceIds, currViewPieceIds)
		end
	elseif rsp.err == gErrDef.ERR_REQ_FREQUENTLY then
		local checkSameData = function(data1, data2)
			_UPVALUE3_ = nil
			;(nil)[1] = "centerKid"
			;(nil)[2] = "mapPieceIds"
			local (nil)[3], config = "lod", nil
			for __, key in ipairs(config) do
				if data1[key] ~= data2[key] then
					return false
				end
			end
			if data1.centerX - 1 ~= data2.centerX then
				return false
			end
			if data1.centerY - 1 ~= data2.centerY then
				return false
			end
			return true
		end
		if not rsp.data then
			local _ENV, rspData = rsp.data, rsp.data
		end
		local lastData = self.lastReqMapSyncData
		if lastData and checkSameData(rspData, lastData) then
			serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_KINGDOM_MAP_SYNC, lastData)
			self.lastReqMapSyncData = nil
		end
	end
end
function kingdomMapCtrl:onRspLocalQueueSync(rsp)
	if rsp.err == gErrDef.Err_None then
	end
end
function kingdomMapCtrl:onRspQueueMapData(rsp)
	dump(rsp, "kingdomMapCtrl:onRspQueueMapData", 10)
	if rsp.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_WORLD_MAP_REQUEST_MOVELINE_INFO"
		gErrDef.Err_None.data = rsp.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function kingdomMapCtrl:onRspQueueWatchTowerData(rsp)
	dump(rsp, "kingdomMapCtrl:onRspQueueWatchTowerData", 10)
	if rsp.err == gErrDef.Err_None and rsp.rspdata and next(rsp.rspdata) then
		for _, queueData in pairs(rsp.rspdata) do
			local orgQueue = self.kingdomMapCell.localQueueMgr:getQueue(queueData.id)
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
function kingdomMapCtrl:updateDataRsp(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			self.kingdomMapCell:noticeMsg(msg)
		end
	end
end
function kingdomMapCtrl:treasureBowlRsp(event)
	local content = event.data[1]
	if content then
		dump(content, "kingdomMapCtrl:treasureBowlRsp")
		if content.treasureBowlInfo then
			self.treasureBowlInfo = content.treasureBowlInfo
		end
		if content.clicktimeout then
			_ENV = content
			content.msg = "MESSAGE_SERVER_WORLD_MAP_TREASURE_BOWL_CLICK"
			content.err = content.err
			SoraDSendMessage(content)
		end
	end
end
function kingdomMapCtrl:reqMapObjInfoRsp(content)
	local retData = content.retData
	dump(retData, "kingdomMapCtrl:reqMapObjInfoRsp", 10)
	if retData then
		_ENV = retData
		retData.msg = "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO"
		retData.data = retData
		SoraDSendMessage(retData, content)
	end
end
function kingdomMapCtrl:reqRelicsEventRsp(content)
	local retData = content.retData
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_REMAINS_LOG"
	;(nil).data = retData
	SoraDSendMessage(nil, content)
end
function kingdomMapCtrl:onRspExploreDesertMeteoriteEvent(content)
	local retData = content.retData
	dump(content, "kingdomMapCtrl:onRspExploreDesertMeteoriteEvent")
	_ENV = content
	content.msg = "MESSAGE_SERVER_WORLD_MAP_DESERT_METEORITE_LOG"
	content.data = retData
	SoraDSendMessage(content, content)
end
function kingdomMapCtrl:reqGetCollectingInfoRsp(content)
	local retData = content.retData
	if retData then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_COLLECTING_INFO"
		;(nil).data = retData
		SoraDSendMessage(nil, content)
	end
end
function kingdomMapCtrl:reqGetScoutFoodRsp(content)
	local retData = content.retData
	if retData then
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_SPYONE_RESCOST"
		;(nil).data = retData
		SoraDSendMessage(nil, content)
	end
end
function kingdomMapCtrl:reqAllianceRsp(content)
	local retData = content.retData
	if retData then
		local _ENV, ret
		for _, v in pairs(retData) do
			table.insert(ret, v)
		end
		_ENV = pairs(retData)
		pairs(retData).msg = "MESSAGE_SERVER_WORLD_RESOURCE_MAP_MEMBERS"
		pairs(retData).data = ret
		SoraDSendMessage(pairs(retData))
	end
end
function kingdomMapCtrl:reqSpeedQueueRsp(content)
	local err = content.err
	if not err and content.data.mode == BUILD_EXCHANGE_MODE.GOLD then
		_ENV = BUILD_EXCHANGE_MODE.GOLD
		BUILD_EXCHANGE_MODE.GOLD.msg = "MESSAGE_MALL_SUCCESS"
		SoraDSendMessage(BUILD_EXCHANGE_MODE.GOLD)
	end
	local rspdata = content.rspdata
	local useSpeedItemCount = rspdata and rspdata.useSpeedItemCount
	if useSpeedItemCount then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		roaringFlameWarCtrl:setUseSpeedItemCount(useSpeedItemCount)
		_ENV = roaringFlameWarCtrl
		roaringFlameWarCtrl.msg = "MESSAGE_ROARINGFLAMEWAR_USESPEEDITEMCOUNT"
		SoraDSendMessage(roaringFlameWarCtrl)
	end
end
function kingdomMapCtrl:reqArmyHelpNumRsp(content)
	local retData = content.retData
	if retData and retData.curNum and retData.maxNum then
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_ARMYHELP_REQDATA"
		;(nil).data = retData
		SoraDSendMessage(nil)
	else
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_ARMYHELP_REQDATA"
		;(nil).err = true
		SoraDSendMessage(nil)
	end
end
function kingdomMapCtrl:reqGetCastleMapInfoRsp(content)
	local retData = content.retData
	if retData and retData.x and retData.y and retData.id then
		_ENV = nil
		;(nil).msg = "MESSAGE_MARKET_GETUSERINFO"
		;(nil).data = retData
		SoraDSendMessage(nil)
	end
end
function kingdomMapCtrl:reqGetInitDataRsp(content)
	local retData = content.retData
	if retData then
		self.kingdomMapCell:setIsSafe(retData.isSafe)
	end
end
function kingdomMapCtrl:reqGetPlaceOwnerInfoRsp(content)
	dump(content, "kingdomMapCtrl:reqGetPlaceOwnerInfoRsp", 10)
	_ENV = content
	content.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK"
	if not content.retData then
		_ENV = content.retData
	end
	content.retdata = content.retData
	SoraDSendMessage(content)
end
function kingdomMapCtrl:onSwitch(event)
	local isForeground = event.data.isForeground
	if isForeground then
		self:reqLocalQueueSync()
	else
		self:removeAllLocalQueue()
		self:resetLocalQueueSyncData()
		self:resetMapObjsSyncData()
	end
end
function kingdomMapCtrl:reLoginFinish()
	self:removeAllLocalQueue()
	self:resetLocalQueueSyncData()
	self:resetMapObjsSyncData()
end
function kingdomMapCtrl:reqGetOtherKingdomInfoRsp(content)
	dump(content, "kingdomMapCtrl:reqGetOtherKingdomInfoRsp", 10)
	local retData = content.retData
	self.kingdomMapCell:setOtherKingdomInfo(content.data.kid, retData)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_WORLDMAP_REFRESH_OTHER_KINGDOMINFO"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:reqAllQueueIdInSuperResRsp(content)
	local retData = content.retData
	self:reqSuperResQueuesByIds(0, 0, "12_3721_1", retData)
end
function kingdomMapCtrl:reqSuperResQueueByIdsRsp(content)
	local retData = content.retData
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_BUILD_INFOLIST_UPDATE"
	;(nil).data = retData
	SoraDSendMessage(nil)
end
function kingdomMapCtrl:addKingdomQueueRsp(content)
	dump(content, "kingdomMapCtrl:addKingdomQueueRsp", 10)
	if content.data and content.data.data and content.data.data.passwdVerify ~= nil then
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		lordInfoCtrl:setPasswdVerify(content.data.data.passwdVerify)
	end
	if content.err == gErrDef.Err_None then
	elseif content.err == gErrDef.Err_MAP_MONSTER_FIESTA_CASTLE_NOT_ENOUGH then
		SoraDShowMsgTip(i18n("Semruk_text_09"))
	elseif content.err == gErrDef.ERR_HUNTFAIR_NUMBER_DAYMAX then
		local totalKill = include("constantRead").getConstValue("HUNTFAIR_DAY_KILLMAX")
		_ENV = i18n("Semruk_text_09")
		i18n("Semruk_text_09").num = totalKill
		SoraDShowMsgTip(i18n("Snow_Monster_text_07", i18n("Semruk_text_09")))
	elseif content.err == gErrDef.Err_ALLIANCE_BUILD_NOT_CONNECT_AREA then
		SoraDShowMsgTip(i18n("alliance_stronghold_text_096"))
		local toPos = cc.p(content.data.data.to.x, content.data.data.to.y)
		SoraDGotoWorldMapPoint(toPos, false)
	elseif content.err == gErrDef.Err_MAP_QUEUE_MASS_ALLIANCE_BUILD_ALREADY then
		SoraDShowMsgTip(i18n("common_text_652"))
	elseif content.err == gErrDef.Err_TEAM_NOT_ASSEMBLER then
		local worldMapWarDef = include("worldMapWarDef")
		worldMapWarDef.showMassErrMsgTip()
	elseif content.err == gErrDef.Err_MAP_MUST_BE_SAME_ALLIANCE_MEMBER then
		SoraDShowMsgTip(i18n("notice_0026"))
	elseif content.err == gErrDef.Err_BUBBLE_LAND_JOIN_ALLIANCE_TIME then
		SoraDShowMsgTip(i18n("Bubble_island_rebuild_text_30"))
	elseif content.err == gErrDef.Err_FANTASY_LAND_JOIN_ALLIANCE_TIME then
		SoraDShowMsgTip(i18n("Bubble_island_rebuild_text_30"))
	elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_NO_SAME_CAMP then
		if worldMapDefine.isInRoaringFlame() then
			local mapType = content.data.data.to.type
			if mapType == gMapObjTypeDef.roaringFlameWarNpc then
				local instanceID = data.data.to.id
				local kingdomMapUtil = include("kingdomMapUtil")
				local __, __, __, __, objId = kingdomMapUtil.gSplitId(instanceID)
				local monster = worldMapDefine.getMonsterName(objId)
				local buildName = i18n("flames_dunes_build_4")
				_ENV = i18n("Bubble_island_rebuild_text_30")
				i18n("Bubble_island_rebuild_text_30").city = buildName
				i18n("Bubble_island_rebuild_text_30").monster = monster
				SoraDShowMsgTip(i18n("flames_dunes_text241", i18n("Bubble_island_rebuild_text_30")))
			end
		end
	elseif content.err == gErrDef.Err_ROARING_FLAME_WAR_OCCUPY_LIMIT then
		SoraDShowMsgTip(i18n("flames_dunes_text287"))
	else
		local msgNotice = include("msgNotice")
		local notice_id = msgNotice.getTipCode(content.err)
		if content.err == gErrDef.Err_RADIANCE_WAR_BUILD_CAN_NOT_OCCUPY then
			local queueToId = content.data.data.to.id
			_ENV = i18n("flames_dunes_text287")
			i18n("flames_dunes_text287").queueToId = queueToId
			msgNotice.notice(notice_id, i18n("flames_dunes_text287"))
		else
			msgNotice.notice(notice_id)
		end
	end
end
function kingdomMapCtrl:onRspMoveCity(rsp)
	dump(rsp, "kingdomMapCtrl:onRspMoveCity", 10)
	if rsp.err == gErrDef.Err_None then
	elseif rsp.err == gErrDef.Err_MAP_MOVE_2_OTHER_KINGDOM_SERVICE_WAR_NOT_OPEN then
		SoraDShowMsgTip(i18n("lbs_text_10"))
	elseif rsp.err == gErrDef.Err_MAP_MOVE_2_OTHER_KINGDOM_FIRE_SERVER then
		SoraDShowMsgTip(i18n("common_text_4410"))
	elseif rsp.err == gErrDef.Err_MAP_MOVE_2_OTHER_KINGDOM_TIMEOUT then
		SoraDShowMsgTip(i18n("common_text_4410"))
	elseif rsp.err == gErrDef.Err_MAP_MOVE_CITY_CD_1 then
		SoraDShowMsgTip(i18n("common_text_4877"))
	elseif rsp.err == gErrDef.ERR_NO_PERMISSION and worldMapDefine.isInAtlantis() then
		local AMBC = require_data("atlantiswar_map_build_config").data
		local atlantisWarUtil = include("atlantisWarUtil")
		local mapSyncUtilClient = include("mapSyncUtilClient")
		local marshalPointList = atlantisWarUtil.getMarshalPointList()
		local tilePoint = mapSyncUtilClient.serverTOClientPos(cc.p(rsp.data.x, rsp.data.y))
		for i, v in ipairs(marshalPointList) do
			if v.tilePoint.x == tilePoint.x and v.tilePoint.y == tilePoint.y then
				_ENV = cc.p(rsp.data.x, rsp.data.y)
				cc.p(rsp.data.x, rsp.data.y).var = i18n(AMBC[v.buildId].name)
				SoraDShowMsgTip(i18n("atlantiswar_text_0093", cc.p(rsp.data.x, rsp.data.y)))
				break
			end
		end
	end
end
function kingdomMapCtrl:reqCanMoveCityInTerrRsp(rsp)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_REQUEST_CAN_MOVE_CITY"
	;(nil).err = rsp.err
	;(nil).canMove = rsp.canMove
	SoraDSendMessage(nil)
end
function kingdomMapCtrl:reqPlayerChestDayReceiveRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		local data = rsp.data
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO"
		;(nil).data = data
		SoraDSendMessage(nil, rsp)
	end
end
function kingdomMapCtrl:reqExitAllianceWarRsp(rsp)
	if rsp.err == gErrDef.Err_None then
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_UI_PYRAMID_REQ_EXIT_RSP"
	SoraDSendMessage(gErrDef.Err_None)
end
function kingdomMapCtrl:reqTreasureBowlDayReceiveRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		local data = rsp.data
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_TREASURE_BOWL_INFO"
		;(nil).data = data
		SoraDSendMessage(nil, rsp)
	end
end
function kingdomMapCtrl:reqClickTreasureBowlRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		if not rsp.data then
			local _ENV, data = rsp.data, rsp.data
		end
		if 1 == data.count then
			self.treasureBowlObj = data.mapObj
			data.cooltime = self.treasureBowlObj.cooltime
			data.maxcount = self.treasureBowlObj.clickcount
		end
		if self.treasureBowlObj and self.treasureBowlObj.clickcount == data.count then
			self.treasureBowlObj = nil
		end
		_ENV = data.count
		data.count.msg = "MESSAGE_SERVER_WORLD_MAP_TREASURE_BOWL_CLICK"
		data.count.err = rsp.err
		data.count.data = rsp.data
		SoraDSendMessage(data.count)
	else
		self.treasureBowlObj = nil
		if rsp.err == gErrDef.Err_ILLEGAL_PARAMS then
		elseif rsp.err == gErrDef.Err_TOOLS_NOT_REACH then
		elseif rsp.err == gErrDef.Err_MAP_TREASUR_BOWL_REACH_LIMIT then
		elseif rsp.err == gErrDef.Err_MAP_TREASUR_BOWL_NOT_FOUND then
		elseif rsp.err == gErrDef.Err_MAP_TREASUR_BOWL_SOMEONE_CLICK then
		end
		_ENV = gErrDef.Err_MAP_TREASUR_BOWL_SOMEONE_CLICK
		gErrDef.Err_MAP_TREASUR_BOWL_SOMEONE_CLICK.msg = "MESSAGE_SERVER_WORLD_MAP_TREASURE_BOWL_CLICK"
		gErrDef.Err_MAP_TREASUR_BOWL_SOMEONE_CLICK.err = rsp.err
		SoraDSendMessage(gErrDef.Err_MAP_TREASUR_BOWL_SOMEONE_CLICK)
	end
end
function kingdomMapCtrl:reqInitSnowWonderRsp(rsp)
	dump(rsp, "敲击冰锥---")
	dump(rsp.rspdata.count)
	self.snowWonderLeftTimes = rsp.rspdata.count
	_ENV = rsp.rspdata.count
	rsp.rspdata.count.msg = "MESSAGE_SNOWWONDER_INIT"
	SoraDSendMessage(rsp.rspdata.count)
end
function kingdomMapCtrl:getSnwoLeftTimeByLv(lv)
	if not self.snowWonderLeftTimes or not self.snowWonderLeftTimes[tostring(lv)] then
		return 0
	end
	if self.snowWonderLeftTimes[tostring(lv)] then
		return self.snowWonderLeftTimes[tostring(lv)]
	end
end
function kingdomMapCtrl:reqClickSnowWonderRsp(rsp)
	dump(rsp, "玩家敲击冰锥 返回")
	if not rsp.err then
		_ENV = rsp
		rsp.msg = "MESSAGE_SERVER_WORLD_MAP_SNOWWONDER_CLICK"
		rsp.err = nil
		SoraDSendMessage(rsp)
		return
	end
	if rsp.err == gErrDef.Err_None then
		local _ENV, data = rsp.err, rsp.err
		if rsp.data then
			data.data = rsp.data
		end
		local endTime = rsp.rspdata.endTime
		data.endTime = endTime
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_SNOWWONDER_CLICK"
		;(nil).err = rsp.err
		;(nil).data = data
		SoraDSendMessage(nil)
	else
		self.snowWonderObj = nil
		_ENV = rsp.rspdata.endTime
		rsp.rspdata.endTime.msg = "MESSAGE_SERVER_WORLD_MAP_SNOWWONDER_CLICK"
		rsp.rspdata.endTime.err = rsp.err
		SoraDSendMessage(rsp.rspdata.endTime)
	end
end
function kingdomMapCtrl:reqCancleSnowWonderRsp(rsp)
	dump(rsp, "结束敲击冰锥")
	if rsp.err == gErrDef.Err_None then
		local _ENV, data = rsp.err, rsp.err
		_ENV = "结束敲击冰锥"
		;("结束敲击冰锥").msg = "MESSAGE_SERVER_WORLD_MAP_SNOWWONDER_END"
		;("结束敲击冰锥").err = rsp.err
		;("结束敲击冰锥").reward = rsp.rspdata.reward
		SoraDSendMessage("结束敲击冰锥")
	else
		self.snowWonderObj = nil
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_WORLD_MAP_SNOWWONDER_END"
		SoraDSendMessage.err = rsp.err
		SoraDSendMessage(SoraDSendMessage)
	end
end
function kingdomMapCtrl:onNotifyMapData(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			if msg.msgType == _G.gMapDataMsgType.ADD_ALLIANCE_BUILDS then
				self.kingdomMapCell:onAddAllianceBuild(msg.data, msg)
			elseif msg.msgType == _G.gMapDataMsgType.ADD_MAPOBJ_BEGIN then
				self.kingdomMapCell:onUpdateAllianceVersion(msg.data, msg)
			elseif msg.msgType == _G.gMapDataMsgType.ADD_MAPOBJ_END then
				self.kingdomMapCell:onAddAllianceBuildEnd(msg.data, msg)
			elseif msg.msgType == _G.gMapDataMsgType.ADD_ALLIANCE_BUILD then
				self.kingdomMapCell:onAllianceSelfAdd(msg.data, msg)
			elseif msg.msgType == _G.gMapDataMsgType.UPDATE_ALLIANCE_BUILD then
				self.kingdomMapCell:onAllianceSelfUpdate(msg.data, msg)
			elseif msg.msgType == _G.gMapDataMsgType.REMOVE_ALLIANCE_BUILD then
				self.kingdomMapCell:onAllianceSelfRemove(msg.data, msg)
			elseif msg.msgType == _G.gMapDataMsgType.ADD_STRONGHOLDS then
				self.kingdomMapCell:onAddStrongHold(msg.data, msg)
			elseif msg.msgType == _G.gMapDataMsgType.UPDATE_STRONGHOLD then
				self.kingdomMapCell:onUpdateStrongHold(msg.data, msg)
			end
		end
	end
end
function kingdomMapCtrl:onNotifyMapSyncData(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			if msg.msgType == gMapSyncMsgType.ADD_PIECE_MAP or msg.msgType == gMapSyncMsgType.ADD_MAPOBJ or msg.msgType == gMapSyncMsgType.REMOVE_MAPOBJ or msg.msgType == gMapSyncMsgType.UPDATE_MAPOBJ or msg.msgType == gMapSyncMsgType.FLASH_ON_MAPOBJ then
				self:onNotifyMapObjsSyncData(msg.data, msg)
			elseif msg.msgType == gMapSyncMsgType.ADD_PIECE_QUEUE then
				self.kingdomMapCell:onAddMapQueues(msg.data, msg)
			elseif msg.msgType == gMapSyncMsgType.ADD_QUEUE then
				self.kingdomMapCell:onAddMapQueue(msg.data, msg)
			elseif msg.msgType == gMapSyncMsgType.REMOVE_QUEUE then
				self.kingdomMapCell:onRemoveMapQueue(msg.data, msg)
			elseif msg.msgType == gMapSyncMsgType.UPDATE_QUEUE then
				self.kingdomMapCell:onUpdateMapQueue(msg.data, msg)
			elseif msg.msgType == gMapSyncMsgType.UPDATE_SUPER_RES then
				self.kingdomMapCell:onSuperResQueueChange(msg.data)
			elseif msg.msgType == gMapSyncMsgType.SYNC_NUM then
				if worldMapDefine.isPyramidKingdomID(msg.mapId) then
					local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
					allianceWarCtrl:setWatchingNum(msg.mapId, msg.data.num)
				elseif worldMapDefine.isLegendLordKingdomID(msg.mapId) then
					local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
					legendLordWarCtrl:setWatchingNum(msg.data.num)
				end
			end
		end
	end
end
function kingdomMapCtrl:onNotifySwitchMapType(event)
	for _, msgData in ipairs(event.data) do
		self:setCurMapInfo(msgData)
	end
end
function kingdomMapCtrl:getCurMapInfo(key)
	return self.curMapInfo
end
function kingdomMapCtrl:resetLocalQueueSyncData()
	if self.localQueueSyncTimer then
		SoraDManagerRemoveTimer(self, self.localQueueSyncTimer)
		self.localQueueSyncTimer = nil
	end
	self.localQueueSyncData, _ENV = SoraDManagerRemoveTimer, SoraDManagerRemoveTimer
	local curTime = socket.gettime()
	self.preClockTimeLocal = curTime
end
function kingdomMapCtrl:resetMapObjsSyncData()
	if self.mapObjsSyncTimer then
		SoraDManagerRemoveTimer(self, self.mapObjsSyncTimer)
		self.mapObjsSyncTimer = nil
	end
	self.mapObjsSyncData, _ENV = SoraDManagerRemoveTimer, SoraDManagerRemoveTimer
	local curTime = socket.gettime()
	self.preClockTimeMap = curTime
end
function kingdomMapCtrl:onNotifyLocalQueueSyncDataMsg(data)
	for _, msg in pairs(data) do
		self:onNotifyLocalQueueSyncData_imp(msg)
	end
end
function kingdomMapCtrl:onNotifyLocalQueueSyncData_imp(msg)
	if msg.msgType == gQueueSyncMsgType.ADD then
		self.kingdomMapCell:onAddLocalQueue(msg.data, msg.teamId, msg.mapId)
		if msg.data and msg.data.orgId then
			_ENV = msg.data.orgId
			local msg.data.orgId.id, data = msg.data.orgId, msg.data.orgId
			self.kingdomMapCell:onRemoveLocalQueue(data, msg.teamId, msg.mapId)
		end
	elseif msg.msgType == gQueueSyncMsgType.REMOVE then
		self.kingdomMapCell:onRemoveLocalQueue(msg.data, msg.teamId, msg.mapId)
	elseif msg.msgType == gQueueSyncMsgType.UPDATE then
		self.kingdomMapCell:onUpdateLocalQueue(msg.data, msg.teamId, msg.mapId)
	elseif msg.msgType == gQueueSyncMsgType.ADD_ALL then
		self.kingdomMapCell:onAddLocalQueues(msg.data, msg.teamId, msg.mapId)
	elseif msg.msgType == gQueueSyncMsgType.REMOVE_ALL then
		self:removeAllLocalQueue(msg.mapId)
	elseif msg.msgType == gQueueSyncMsgType.DEL_WATCH_POS then
		self.kingdomMapCell:onDelWatchPos(msg.x - gPointClientPointPlus, msg.y - gPointClientPointPlus, msg.teamId, msg.mapId)
	elseif msg.msgType == gQueueSyncMsgType.QUEUE_TARGET_STATUS then
		local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
		remainsWarCtrl:setBuildingStatus(msg)
	end
end
function kingdomMapCtrl:updateLocalQueueSyncData()
	if #self.localQueueSyncData <= 0 then
		local curTime = socket.gettime()
		local time = curTime - self.preClockTimeLocal
		if 5.0 < time and self.localQueueSyncTimer then
			SoraDManagerRemoveTimer(self, self.localQueueSyncTimer)
			self.localQueueSyncTimer = nil
		end
		return
	end
	if #self.localQueueSyncData >= 1 then
		local dealCount = 0
		local maxDealValue = worldMapDefine.moveLineAutoHideOption.isMoveLineHideArmy and 60 or 30
		if #self.localQueueSyncData > 200 then
			maxDealValue = #self.localQueueSyncData
		end
		for i = 1, maxDealValue do
			local data = self.localQueueSyncData[i]
			if data then
				self:onNotifyLocalQueueSyncData_imp(data)
			else
				break
			end
			dealCount = dealCount + 1
		end
		local total = #self.localQueueSyncData
		if dealCount >= total then
			self.localQueueSyncData, socket = maxDealValue, maxDealValue
		else
			for i = 1, total - dealCount do
				self.localQueueSyncData[i] = self.localQueueSyncData[i + dealCount]
			end
			for i = total - dealCount + 1, total do
				self.localQueueSyncData[i] = nil
			end
		end
	end
	if #self.localQueueSyncData <= 0 then
		local curTime = socket.gettime()
		self.preClockTimeLocal = curTime
	end
end
function kingdomMapCtrl:onNotifyLocalQueueSyncData_add(data)
	for _, msg in pairs(data) do
		if msg.msgType == gQueueSyncMsgType.ADD_ALL then
			for _, v in ipairs(msg.data) do
				_ENV = nil
				;(nil).msgType = gQueueSyncMsgType.ADD
				;(nil).mapId = msg.mapId
				;(nil).data = v
				local (nil).teamId, queueData = msg.teamId, nil
				table.insert(self.localQueueSyncData, queueData)
			end
		else
			table.insert(self.localQueueSyncData, msg)
		end
	end
end
function kingdomMapCtrl:onNotifyLocalQueueSyncData(event)
	local data = event.data
	if data then
		if #self.localQueueSyncData > 0 or self.localQueueSyncTimer then
			self:onNotifyLocalQueueSyncData_add(data)
		else
			local curTime = socket.gettime()
			local time = curTime - self.preClockTimeLocal
			if 0.1 < time then
				self.preClockTimeLocal = curTime
				self:onNotifyLocalQueueSyncDataMsg(data)
			else
				self:onNotifyLocalQueueSyncData_add(data)
				if not self.localQueueSyncTimer then
					self.localQueueSyncTimer = SoradCreateTimer(self, handler(self, self.updateLocalQueueSyncData), true)
				end
			end
		end
	end
end
function kingdomMapCtrl:updateMapObjsSyncData()
	if #self.mapObjsSyncData <= 0 then
		local curTime = socket.gettime()
		local time = curTime - self.preClockTimeMap
		if 10.0 < time and self.mapObjsSyncTimer then
			SoraDManagerRemoveTimer(self, self.mapObjsSyncTimer)
			self.mapObjsSyncTimer = nil
		end
		return
	end
	if #self.mapObjsSyncData >= 1 then
		local msg = table.remove(self.mapObjsSyncData, 1)
		if msg then
			if msg.msgType == gMapSyncMsgType.ADD_PIECE_MAP then
				self.kingdomMapCell:onAddMapObjs(msg.pieceId, msg.pieceData, msg.msg)
			elseif msg.msgType == gMapSyncMsgType.ADD_MAPOBJ then
				self.kingdomMapCell:onAddMapObj(msg.data, msg)
			elseif msg.msgType == gMapSyncMsgType.REMOVE_MAPOBJ then
				self.kingdomMapCell:onRemoveMapObj(msg.data, msg)
			elseif msg.msgType == gMapSyncMsgType.UPDATE_MAPOBJ then
				self.kingdomMapCell:onUpdateMapObj(msg.data, msg)
			elseif msg.msgType == gMapSyncMsgType.FLASH_ON_MAPOBJ then
				self.kingdomMapCell:onFlashMapObj(msg.data, msg)
			end
		end
	end
	if #self.mapObjsSyncData <= 0 then
		local curTime = socket.gettime()
		self.preClockTimeMap = curTime
	end
end
function kingdomMapCtrl:onNotifyMapObjsSyncData(data, msg)
	if msg.msgType == gMapSyncMsgType.ADD_PIECE_MAP then
		for pieceId, pieceData in pairs(data) do
			_ENV = nil
			;(nil).pieceId = pieceId
			;(nil).pieceData = pieceData
			;(nil).msg = msg
			local (nil).msgType, queueData = msg.msgType, nil
			table.insert(self.mapObjsSyncData, queueData)
		end
	elseif msg.data then
		table.insert(self.mapObjsSyncData, msg)
	end
	if not self.mapObjsSyncTimer then
		self.mapObjsSyncTimer = SoradCreateTimer(self, handler(self, self.updateMapObjsSyncData), true)
	end
end
function kingdomMapCtrl:onAddWhiteList(aid)
	self.kingdomMapCell:onAddWhiteList(aid)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:onDelWhiteList(aid)
	self.kingdomMapCell:onDelWhiteList(aid)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:onAddBlackList(aid)
	self.kingdomMapCell:onAddBlackList(aid)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:onDelBlackList(aid)
	self.kingdomMapCell:onDelBlackList(aid)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:onDismissAlliance()
	self.kingdomMapCell:onDismissAlliance()
end
function kingdomMapCtrl:reqArmyHelpList()
	self.kingdomMapCell:reqArmyHelpList()
end
function kingdomMapCtrl:getArmyWeightPlus()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local ret = 0
	local armyWeightPlus = technologyCtrl:getTechnologyPower(gTechnologyType.FORCE_LOAD)
	ret = ret + armyWeightPlus
	armyWeightPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.FORCE_LOAD)
	ret = ret + armyWeightPlus
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	armyWeightPlus = buffCtrl:getBuffEffect(gBuffEffect.SOLDIER_LOAD_BOOST)
	if armyWeightPlus then
		ret = ret + armyWeightPlus / 1000
	end
	local attributeSystem = include("attributeSystem")
	local attrAdd = attributeSystem.query(gAttributeEnum.TROOP_LOAD_RATE)
	if attrAdd and 0 ~= attrAdd then
		attrAdd = attrAdd / 10000
		ret = ret + attrAdd
	end
	return ret
end
function kingdomMapCtrl:isLockByOtherPlayer(x, y, mapObjType)
	print("kingdomMapCtrl:isLockByOtherPlayer(x, y, mapObjType)", x, y, mapObjType)
	return self.kingdomMapCell:isLockByOtherPlayer(x, y, mapObjType)
end
function kingdomMapCtrl:isLockByDigTreasure(x, y)
	return self.kingdomMapCell:isLockByDigTreasure(x, y)
end
function kingdomMapCtrl:hasMyQueue(queueType, queueStatus, toMapObjId, toObjId)
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, nil, queueType, queueStatus, toMapObjId, toObjId)
end
function kingdomMapCtrl:hasArmyHelpQueue2Player(uid, queueStatus)
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, nil, gMapMoveLineServerType.moveLineTypeArmyHelp, queueStatus, nil, uid)
end
function kingdomMapCtrl:hasArmyHelpQueue2Object(mapObjId)
	return self.kingdomMapCell:hasMyQueue2MapObj(mapObjId, gMapMoveLineType.moveLineTypeArmyHelp)
end
function kingdomMapCtrl:hasQueue2AllianceBuild(mapObjId)
	return self.kingdomMapCell:hasMyQueue2MapObj(mapObjId, gMapMoveLineType.moveLineTypeSuperRes)
end
function kingdomMapCtrl:hasQueue2HoldBuildNpc(mapObjId)
	return self.kingdomMapCell:hasMyQueue2MapObj(mapObjId, gMapMoveLineType.moveLineTypeKillNpc)
end
function kingdomMapCtrl:hasMyWarQueue()
	return self.kingdomMapCell:hasMyWarQueue()
end
function kingdomMapCtrl:hasMyRelicsQueue()
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, gMapMoveLineType.moveLineTypeRelicsExplore)
end
function kingdomMapCtrl:hasDesertMeteoriteQueue()
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, gMapMoveLineType.moveLineTypeDesertMeteorite)
end
function kingdomMapCtrl:hasRomeQueue4SelfAlliance()
	return self.kingdomMapCell.localWarHallQueueMgr:getWarHallActivityCount() > 0
end
function kingdomMapCtrl:getMyMassQueueMap()
	return self.kingdomMapCell.localUserQueueMgr:getMyMassQueueMap(self.uid)
end
function kingdomMapCtrl:isHasMassQueue4Uid(uid)
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(uid, gMapMoveLineType.moveLineTypeMass)
end
function kingdomMapCtrl:isHasQueue4UidToHold(uid)
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueueToMapType(uid, gMapObjTypeDef.stronghold)
end
function kingdomMapCtrl:isHasMassQueue()
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, gMapMoveLineType.moveLineTypeMass)
end
function kingdomMapCtrl:hasKWQueue(uid)
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(uid, nil, gMapMoveLineServerType.moveLineTypeOccupy) or self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(uid, nil, gMapMoveLineServerType.moveLineTypeOccupyMass)
end
function kingdomMapCtrl:hasMyOccupyQueue(isExpect)
	return self.kingdomMapCell:hasOccupyQueue(self.uid, isExpect)
end
function kingdomMapCtrl:hasMyOccupyQueueToAncientTreasure()
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, nil, gMapMoveLineServerType.moveLineTypeATBuilding) or self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, nil, gMapMoveLineServerType.moveLineTypeMassATBuilding)
end
function kingdomMapCtrl:hasAtkAllianceBuildQueue()
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, nil, gMapMoveLineServerType.moveLineTypeAttackAllianceBuild)
end
function kingdomMapCtrl:hasQueue2MapObj(mapObjId, moveLineType, queueStatus)
	return self.kingdomMapCell:hasMyQueue2MapObj(mapObjId, moveLineType, queueStatus)
end
function kingdomMapCtrl:isHasQueue()
	return self.kingdomMapCell.localUserQueueMgr:getFromUserQueueNum(self.uid, nil, nil, nil, nil, nil, true)
end
function kingdomMapCtrl:hasEscortQueue()
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, gMapMoveLineType.moveLineTypeEscort)
end
function kingdomMapCtrl:hasEscortAssistQueue()
	return self.kingdomMapCell.localUserQueueMgr:hasFromUserQueue(self.uid, gMapMoveLineType.moveLineTypeEscortHelp)
end
function kingdomMapCtrl:getMapEventList(map)
	local mapSelfQueue = self.kingdomMapCell:getMapEventList(map)
	return mapSelfQueue
end
function kingdomMapCtrl:getArmyMoveTime(...)
	return queueTimeUtil.getArmyMoveTime(...)
end
function kingdomMapCtrl:getFromInstanceIDQueue(instanceID)
	return self.kingdomMapCell.localUserQueueMgr:getFromInstanceIDQueue(instanceID, self.uid, gMapMoveLineType.moveLineTypeResourceHelp, gMapMoveLineServerType.moveLineTypeResourceHelp)
end
function kingdomMapCtrl:getToInstanceIDQueue(instanceID)
	return self.kingdomMapCell.localUserQueueMgr:getToInstanceIDQueue(instanceID, self.uid, gMapMoveLineType.moveLineTypeScout, gMapMoveLineServerType.moveLineTypeSurvey)
end
function kingdomMapCtrl:getLocalUserQueueMgr(...)
	return self.kingdomMapCell.localUserQueueMgr
end
function kingdomMapCtrl:reqIsSafe()
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidShowSafe() then
		return false
	else
		return self.kingdomMapCell:reqIsSafe()
	end
end
function kingdomMapCtrl:reqAddGuideQueue()
	if self.guideTimer then
		return
	end
	self.arrLocalQueueData = self:getGuideLocalQueue()
	do
		local _ENV, event = self:getGuideLocalQueue(), self:getGuideLocalQueue()
		for _, localQueueData in pairs(self.arrLocalQueueData) do
			local _ENV, msg
			msg.msgType = gQueueSyncMsgType.ADD
			msg.data = localQueueData.data
			table.insert(event, msg)
		end
		_ENV = pairs(self.arrLocalQueueData)
		pairs(self.arrLocalQueueData).data = event
		self:onNotifyLocalQueueSyncData(pairs(self.arrLocalQueueData))
	end
	self.arrLocalQueueDataMap = self:getGuideLocalQueue(true)
	do
		local _ENV, event = self:getGuideLocalQueue(true), self:getGuideLocalQueue(true)
		for _, localQueueData in pairs(self.arrLocalQueueDataMap) do
			local _ENV, msg
			msg.msgType = gMapSyncMsgType.ADD_QUEUE
			msg.data = localQueueData.data
			table.insert(event, msg)
		end
		_ENV = pairs(self.arrLocalQueueDataMap)
		pairs(self.arrLocalQueueDataMap).data = event
		self:onNotifyMapSyncData(pairs(self.arrLocalQueueDataMap))
	end
	self.guideTimer = SoradCreateTimer(self, handler(self, self.removeGuideQueue))
	self.guideTimerSecond = gGuideQueueDataTmp.totaltime + 1
end
function kingdomMapCtrl:onJoinAlliance(aid)
	self.kingdomMapCell:onJoinAlliance(aid)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:onQuitAlliance(aid)
	self.kingdomMapCell.localWarHallQueueMgr:clear()
	self.kingdomMapCell:onQuitAlliance(aid)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:getPlaceOwnerInfo(x, y)
	local placeId
	if worldMapDefine.isPyramidKingdomID() then
		local allianceWarltCtrl = include("allianceWarltCtrl")
		local allianceBuilding = allianceWarltCtrl.getAllianceWarBuildingByPos(x, y)
		if allianceBuilding then
			placeId = allianceBuilding.id
		end
	elseif worldMapDefine.isRemainsKingdomID() then
		local remainsWarltCtrl = include("remainsWarltCtrl")
		local remainsWarBuilding = remainsWarltCtrl.getRemainsWarBuildingByPos(x, y)
		if remainsWarBuilding then
			placeId = remainsWarBuilding.id
		end
	elseif worldMapDefine.isInNewTrial() then
		local devilValleyltCtrl = include("devilValleyltCtrl")
		local warBuilding = devilValleyltCtrl.getWarBuildingByPos(x, y)
		if warBuilding then
			placeId = warBuilding.id
		end
	else
		for _, setting in pairs(gPlaceSetting) do
			if setting.x == x and setting.y == y then
				placeId = setting.id
				break
			end
		end
	end
	if placeId then
		local mapInKid = worldMapDefine.currentMapKindomID
		print("{placeId=placeId,kid=kid}", placeId, self.kid, mapInKid)
		if mapInKid then
			self:reqPlaceOwnerInfo(mapInKid, placeId)
		end
	end
end
function kingdomMapCtrl:getPlaceOwnerInfoEx(kid, placeId)
	return self.kingdomMapCell:getPlaceOwnerInfo(kid, placeId)
end
function kingdomMapCtrl:reqPlaceOwnerInfo(kid, placeId, isFrom)
	print("kid=", kid, "placeId=", placeId)
	if kid and 0 < kid then
		_ENV = placeId
		placeId.kid = kid
		placeId.placeId = placeId
		placeId.isFrom = isFrom
		serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_GET_PLACE_OWNER_INFO, placeId)
	end
end
function kingdomMapCtrl:getLordInfoByUid(uid, x, y, id, ...)
	if uid then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		lordInfoCtrl:getLordInfoByUid(uid, nil, ...)
	else
		local placeId = self.kingdomMapCell:getPlaceIdByXY(x, y)
		if placeId then
			local placeOwner = self.kingdomMapCell:getPlaceOwnerInfo(self.kid, placeId)
			if placeOwner and placeOwner.uid then
				local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
				lordInfoCtrl:getLordInfoByUid(placeOwner.uid, nil, ...)
			end
		end
	end
end
function kingdomMapCtrl:getWarStatus()
	local mapInKid = worldMapDefine.currentMapKindomID
	if mapInKid and mapInKid ~= self.kid then
		return self.kingdomMapCell:getOtherKingdomInfo(mapInKid).warStatus or gKingdomWarStatusType.close
	else
		return worldMapDefine.kingWarStatus
	end
end
function kingdomMapCtrl:getWarStatusTime()
	local mapInKid = worldMapDefine.currentMapKindomID
	print("getWarStatusTime mapInKid=", mapInKid)
	if mapInKid and mapInKid ~= self.kid then
		local warStatusTime = self.kingdomMapCell:getOtherKingdomInfo(mapInKid).warStatusTime or 0
		local warStatusStartTime = self.kingdomMapCell:getOtherKingdomInfo(mapInKid).warStatusStartTime
		if 0 < warStatusTime then
			warStatusTime = warStatusTime - (serviceFunctions.systemTime() - warStatusStartTime)
		end
		return warStatusTime
	else
		return self.kingdomMapCell:getWarStatusTime()
	end
end
function kingdomMapCtrl:isShowWarStatusTime()
	local mapInKid = worldMapDefine.currentMapKindomID
	print("isShowWarStatusTime mapInKid=", mapInKid)
	if mapInKid and mapInKid ~= self.kid then
		return self.kingdomMapCell:getOtherKingdomInfo(mapInKid).showWarStatusTime
	else
		return self.kingdomMapCell:isShowWarStatusTime()
	end
end
function kingdomMapCtrl:getOtherKingdomInfo()
	local mapInKid = worldMapDefine.currentMapKindomID or self.kid
	print("getOtherKingdomInfo mapInKid=", mapInKid)
	return self.kingdomMapCell:getOtherKingdomInfo(mapInKid)
end
function kingdomMapCtrl:getMaxCanKillLevel()
	return self.kingdomMapCell:getMaxCanKillLevel()
end
function kingdomMapCtrl:onSuperResBuildTimeChange(bid, iid, superBuildStartTime, superBuildSurplusTime)
	return self.kingdomMapCell:onSuperResBuildTimeChange(bid, iid, superBuildStartTime, superBuildSurplusTime)
end
function kingdomMapCtrl:getMaintProtectTime()
	local protectTime = 0
	if self:reqIsSafe() and self.maintData and self.maintData.startTime and self.maintData.protectTime then
		local endTime = self.maintData.startTime + self.maintData.protectTime
		protectTime = endTime - serviceFunctions.systemTime()
		if protectTime < 0 then
			protectTime = 0
		end
	end
	return protectTime
end
function kingdomMapCtrl:canGetBossAttackRewards(limitType)
	return self.kingdomMapCell:canGetBossAttackRewards(limitType)
end
function kingdomMapCtrl:canGetBossKillRewards(limitType)
	return self.kingdomMapCell:canGetBossKillRewards(limitType)
end
function kingdomMapCtrl:getSuperResCollInfo(id, x, y)
	return self.kingdomMapCell:getSuperResCollInfo(id, x, y)
end
function kingdomMapCtrl:noticeScoutRecordChanged2UI(mapCellId, uid, x, y, hasScoutRecord)
	return self.kingdomMapCell:noticeScoutRecordChanged2UI(mapCellId, uid, x, y, hasScoutRecord)
end
function kingdomMapCtrl:getKingdomClass()
	return self.kingdomMapCell:getKingdomClass()
end
function kingdomMapCtrl:isPyramidMap()
	return self.kingdomMapCell:getKingdomClass() == gKingdomClassType.pyramid
end
function kingdomMapCtrl:getPyramidWarStatusTime()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local coolQueue = queueCtrl:queryQueue(gQueueTypeDef.world_resource_cool, gAllianceWarCoolQueueId)
	if coolQueue then
		return coolQueue.timerNode.timer:getRemainTime()
	else
		return 0
	end
end
function kingdomMapCtrl:getAllianceWarBuildings(kid)
	kid = kid or worldMapDefine.currentMapKindomID
	local allianceWarltCtrl = include("allianceWarltCtrl")
	local allianceBuildings = allianceWarltCtrl.getAllianceWarBuildings()
	local worldMapDefine, ret
	for id, allianceBuild in pairs(allianceBuildings) do
		local worldMapDefine, item
		item.type = allianceBuild.type
		item.x = allianceBuild.x
		item.y = allianceBuild.y
		item.size = allianceBuild.size
		item.id = id
		local placeOwnerInfo = self.kingdomMapCell:getPlaceOwnerInfo(kid, id)
		item.allianceWarCamp = placeOwnerInfo.allianceWarCamp
		item.finishOccupy = placeOwnerInfo.finishOccupy
		table.insert(ret, item)
	end
	return ret
end
function kingdomMapCtrl:getKingWarRank()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local isLeader = allianceMgr:isLeader()
	if not isLeader then
		return
	end
	return self.kingdomMapCell:getKingWarRank()
end
function kingdomMapCtrl:isInKingWarPackAssignPeriod()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local isLeader = allianceMgr:isLeader()
	if not isLeader then
		return false
	end
	local rank = self:getKingWarRank()
	if rank and 1 < rank then
		return true
	else
		return false
	end
end
function kingdomMapCtrl:getKingWarPackLeftTime()
	return self.kingdomMapCell:getKingWarPackLeftTime()
end
function kingdomMapCtrl:onAllianceRelationChanged(aid)
	self.kingdomMapCell:onAllianceRelationChanged(aid)
end
function kingdomMapCtrl:getGuideLocalQueue(map)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local selfPoint = cityCtrl:getCurCityPos()
	selfPoint.x = tonumber(selfPoint.x)
	selfPoint.y = tonumber(selfPoint.y)
	local gametop, result = tonumber(selfPoint.y), tonumber(selfPoint.y)
	for _, guideLocalQueueSetting in pairs(gGuideLocalQueueSetting) do
		local queueData = clone(gGuideQueueDataTmp)
		queueData.data.uid = self.uid
		queueData.data.id = guideLocalQueueSetting.id
		queueData.data.to.x = selfPoint.x
		queueData.data.to.y = selfPoint.y
		queueData.data.from.x = queueData.data.to.x + guideLocalQueueSetting.from.plusX
		queueData.data.from.y = queueData.data.to.y + guideLocalQueueSetting.from.plusY
		if map then
			gametop, _ENV = guideLocalQueueSetting.from.plusY, queueData.data.to.y + guideLocalQueueSetting.from.plusY
			guideLocalQueueSetting.from.plusY.armyList = guideLocalQueueSetting.from.army
			queueData.data.from.army, (queueData.data.to.y + guideLocalQueueSetting.from.plusY)[1] = queueData.data.to.y + guideLocalQueueSetting.from.plusY, guideLocalQueueSetting.from.plusY
			local myKindomID = gametop.playertop_:getMapID()
			queueData.data.kingdomId = myKindomID
			queueData.data.playerID = self.uid
		else
			queueData.data.from.army = guideLocalQueueSetting.from.army
		end
		local startTime = serviceFunctions.systemTime()
		queueData.data.statusStartTime = startTime
		queueData.data.statusEndTime = startTime + gGuideQueueDataTmp.totaltime
		table.insert(result, queueData)
	end
	return result
end
function kingdomMapCtrl:removeGuideQueue()
	self.guideTimerSecond = self.guideTimerSecond - 1
	if self.guideTimerSecond <= 0 then
		do
			local _ENV, event = self.guideTimerSecond, self.guideTimerSecond
			for _, localQueueData in pairs(self.arrLocalQueueData) do
				local _ENV, msg
				msg.msgType = gQueueSyncMsgType.REMOVE
				msg.data = localQueueData.data
				table.insert(event, msg)
			end
			_ENV = pairs(self.arrLocalQueueData)
			pairs(self.arrLocalQueueData).data = event
			self:onNotifyLocalQueueSyncData(pairs(self.arrLocalQueueData))
		end
		do
			local _ENV, event = event, self.guideTimerSecond
			for _, localQueueData in pairs(self.arrLocalQueueDataMap) do
				local _ENV, msg
				msg.msgType = gMapSyncMsgType.REMOVE_QUEUE
				msg.data = localQueueData.data
				table.insert(event, msg)
			end
			_ENV = pairs(self.arrLocalQueueDataMap)
			pairs(self.arrLocalQueueDataMap).data = event
			self:onNotifyMapSyncData(pairs(self.arrLocalQueueDataMap))
		end
		if self.guideTimer then
			SoraDManagerRemoveTimer(self, self.guideTimer)
			self.guideTimerSecond = 0
			self.guideTimer = nil
		end
	end
end
function kingdomMapCtrl:reqAddWarLossCompensateQueue(reward, mid)
	if not self.warDamagedReward then
		self.warDamagedReward, _UPVALUE0_ = self.warDamagedReward, self.warDamagedReward
	end
	_UPVALUE0_ = nil
	;(nil).reward = reward
	self.warDamagedReward[#self.warDamagedReward + 1], (nil).mid = nil, mid
	self:reqAddWarLossCompensateQueueSingle()
end
function kingdomMapCtrl:reqAddWarLossCompensateQueueSingle()
	if self.WLCTimer then
		return
	end
	self.arrWLCQueueData = self:getWarLossCompensateLocalQueue()
	for k, localQueueData in pairs(self.arrWLCQueueData) do
		self.kingdomMapCell:onAddLocalQueue(localQueueData, localQueueData.leagueID)
		self.kingdomMapCell:onAddMapQueue(localQueueData)
		local kingdomQueueObjCell = include("kingdomQueueObjCell")
	end
	self.WLCTimer = SoradCreateTimer(self, handler(self, self.removeWarLossCompensateQueue))
	self.WLCTimerSecond = gWLCQueueTime
end
function kingdomMapCtrl:removeWarLossCompensateQueue()
	self.WLCTimerSecond = self.WLCTimerSecond - 1
	if self.WLCTimerSecond == 0 then
		for _, localQueueData in pairs(self.arrWLCQueueData) do
			self.kingdomMapCell:onRemoveLocalQueue(localQueueData, localQueueData.leagueID)
			self.kingdomMapCell:onRemoveMapQueue(localQueueData)
		end
		local mid = self.warDamagedReward[1].mid
		local mailMgr = gModuleMgr.sharedMgr("mailMgr")
		local mail = mailMgr:queryMail(mid)
		if mail and mail:hasExtra() then
			if mail:isGetExtra() then
				SoraDShowMsgTip(i18n("common_text_1892"))
			else
				local mailCtrl = gametop.playertop_:getModule("mailCtrl")
				mailCtrl:getExtraOfMail(mid)
			end
		end
		table.remove(self.warDamagedReward, 1)
	end
	if self.WLCTimerSecond < 0 then
		if self.WLCTimer then
			SoraDManagerRemoveTimer(self, self.WLCTimer)
			self.WLCTimer = nil
		end
		if 0 < #self.warDamagedReward then
			self:reqAddWarLossCompensateQueueSingle()
			self.WLCTimerSecond = self.WLCTimerSecond - 1
		end
	end
end
function kingdomMapCtrl:getWarLossCompensateLocalQueue()
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local selfUid = gametop.playertop_:getPlayerID()
	local selfPoint = cityCtrl:getCurCityPos()
	selfPoint.x = tonumber(selfPoint.x)
	selfPoint.y = tonumber(selfPoint.y)
	local reward = self.warDamagedReward[1].reward
	local gametop, resources = selfPoint.y, selfPoint.y
	for k, v in pairs(reward) do
		gametop = nil
		;(nil).id = v.id
		local (nil).num, data = math.floor(v.count / 5), nil
		table.insert(resources, data)
	end
	local gametop, result = (for generator), pairs(reward)
	local timeOffset = serviceFunctions.systemTime() % 1000000
	local nickName = i18n("compensation_text_01")
	local myKindomID = gametop.playertop_:getKingdomID()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local selfAlliance = allianceMgr:getOwnAid() or 1
	local selfAbbr = allianceMgr:getAllianceProperty("abbr")
	for _, guideLocalQueueSetting in pairs(gWLCLocalQueueSetting) do
		local queueData = clone(gWLCQueueDataTmp)
		queueData.createTime = serviceFunctions.systemTime()
		queueData.data.resourceList = resources
		queueData.endTime = queueData.createTime + gWLCQueueTime
		queueData.to.x = selfPoint.x + 1
		queueData.to.y = selfPoint.y + 1
		queueData.from.x = queueData.to.x + guideLocalQueueSetting.from.plusX
		queueData.from.y = queueData.to.y + guideLocalQueueSetting.from.plusY
		queueData.id = string.format("%d%s", timeOffset, guideLocalQueueSetting.id)
		queueData.data.kingdomId = myKindomID
		queueData.from.allianceAbb = selfAbbr
		queueData.from.name = nickName
		queueData.lordName = nickName
		queueData.startTime = queueData.createTime
		queueData.statusEndTime = queueData.endTime
		queueData.statusStartTime = queueData.createTime
		queueData.targetUid = selfUid
		queueData.toAlliance = selfAlliance
		queueData.from.aid = selfAlliance
		queueData.to.aid = selfAlliance
		queueData.leagueID = selfAlliance
		queueData.alliance = selfAlliance
		queueData.uid = 10086
		table.insert(result, queueData)
	end
	return result
end
function kingdomMapCtrl:onPlaceOwnerInfoChange(msg)
	self.kingdomMapCell:onPlaceOwnerInfoChange(msg)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACECHANGE"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:onPlaceOccupyAllianceChange(msg, isLLW)
	self.kingdomMapCell:onPlaceOccupyAllianceChange(msg, isLLW)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACECHANGE"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:onPlaceCaptainChange(msg)
	self.kingdomMapCell:onPlaceCaptainChange(msg)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACECHANGE"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:setWarBuildingOwner(kid, buildId, owner)
	self.kingdomMapCell:setWarBuildingOwner(kid, buildId, owner)
	_ENV = self.kingdomMapCell
	self.kingdomMapCell.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACECHANGE"
	SoraDSendMessage(self.kingdomMapCell)
end
function kingdomMapCtrl:getWarBuildingOwner(kid, buildId)
	return self.kingdomMapCell:getWarBuildingOwner(kid, buildId)
end
function kingdomMapCtrl:getAllWarBuildingOwner(...)
	return self.kingdomMapCell:getAllWarBuildingOwner(...)
end
function kingdomMapCtrl:onKingWarStatusChange(isInit, resetCaptainShow)
	self.kingdomMapCell:onKingWarStatusChange(isInit, resetCaptainShow)
end
function kingdomMapCtrl:onAllianceWarStatusChange(kid, isInit)
	self.kingdomMapCell:onAllianceWarStatusChange(kid, isInit)
end
function kingdomMapCtrl:getHallWarCount(isWar)
	return self.kingdomMapCell:getHallWarCount(isWar)
end
function kingdomMapCtrl:noticeMsg(msg)
	self.kingdomMapCell:noticeMsg(msg)
end
function kingdomMapCtrl:kingWarRankPackQueueCallback(event)
	self.kingdomMapCell:setKingWarRankAndPackEndTime()
end
function kingdomMapCtrl:isInAllianceBuild(mapObjId)
	return self:hasMyQueue(gMapMoveLineServerType.moveLineTypeGuardAllianceBuild, gMapMoveLineStatusType.moveLineStatusTypeWorking, mapObjId)
end
function kingdomMapCtrl:initClientData(data)
	dump(data, "kingdomMapCtrl:initClientData", 10)
	SoraDFabricLog("initClientData setMapID" .. data.mapId)
	gametop.playertop_:setMapID(data.mapId)
	self.kid = gametop.playertop_:getMapID()
	self.kingdomMapCell.kid = self.kid
	self.kingdomMapCell:setIsSafe(data.isSafe)
	self.kingdomMapCell:setMaxNpcLevel(data.maxNpcLevel)
	self.kingdomMapCell:setMaxMapNpcLevel(data.maxMapNpcLevel)
	local mapId = gametop.playertop_:getMapID()
	local kingdomClass = worldMapDefine.getKingdomMapClassByKingdomId(mapId)
	self.kingdomMapCell:setKingdomClass(kingdomClass)
	self.kingdomMapCell:setForbitWarTime(data.forbitWarTime)
	self.kingdomMapCell:setForbidMapObjWarTime(data.forbidMapObjWarTime)
	self.kingdomMapCell:setWarBuildingOwnerMap(data.mapId or data.kingdomId, data.warBuildingOwnerMap)
	self.kingdomMapCell:setInWarStateData(data.kingdomMarchSpeed)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if worldMapDefine.isWarKingdomID(self.kid) then
		local teamID = data.teamId
		allianceMgr:setOwnTeamID(teamID)
	else
		allianceMgr:setOwnTeamID(nil)
	end
	local worldMapWarDef = include("worldMapWarDef")
	worldMapWarDef.initArmyWarType()
	self:setCurMapInfo(data.curMapInfo, true)
	local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
	allianceWarCtrl:setAllianceWarCampData(data.mapId or data.kingdomId, data.allianceWarCampData)
	allianceWarCtrl:setRemainFreeMoveTimesByTransPoints(data.mapId or data.kingdomId, data.remainFreeMoveTimesByTransPoints)
	self.maintData = data.maintData
	if data.treasureBowlInfo then
		self.treasureBowlInfo = data.treasureBowlInfo
	end
	self.kingdomMapCell:setBossRewardsStatus(data.bossTypeRewardLimit)
	self.kingdomMapCell:setKingWarRankAndPackEndTime(data.kingWarRank, data.kingWarPackEndTime)
	self:setNormalFogData(data.fog)
	self.kingdomStartTime = data.kingdomStartTime
end
function kingdomMapCtrl:setNormalFogData(fogData)
	self.fogData = fogData
end
function kingdomMapCtrl:getNormalFogData(...)
	return self.fogData
end
function kingdomMapCtrl:checkIsInNormalFog(clientPos, kingdomID)
	if worldMapDefine.inInCrossWar() then
		return false
	end
	local fogData
	if kingdomID == self.kid then
		fogData = self:getNormalFogData()
	else
		fogData = self:getOtherKingdomInfo().fog
	end
	if not fogData or not next(fogData) then
		return false
	end
	local rect = fogData.rect
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local serverPos = mapSyncUtilClient.clientTOServerPos(clientPos)
	if serverPos.x >= rect.ltX and serverPos.x <= rect.rbX and serverPos.y >= rect.ltY and serverPos.y <= rect.rbY then
		return true
	end
	return false
end
function kingdomMapCtrl:checkFogLv(fogLv)
	if not fogLv or not (0 < fogLv) then
		return true
	end
	local info = self:getNormalFogData()
	if info and info.lv then
		return fogLv < info.lv
	else
		return true
	end
end
function kingdomMapCtrl:setKingdomClass(kingdomClass)
	self.kingdomMapCell:setKingdomClass(kingdomClass or gKingdomClassType.normal)
end
function kingdomMapCtrl:setCurMapInfo(mapInfo, isLogin)
	local curType = gKingdomClassType.normal
	if self.curMapInfo then
		curType = self.curMapInfo.kingdomMapClass
	end
	local newType = gKingdomClassType.normal
	if mapInfo then
		newType = mapInfo.kingdomMapClass
	end
	self.curMapInfo = mapInfo
	if curType ~= newType then
		if isLogin then
			SoraDDelayCallOnce("loing_switch_world_map_type", function()
				_ENV = nil
				;(nil).msg = "MESSAGE_WORLD_MAP_SWITCH_MAP_TYPE"
				;(nil).mapType = newType
				SoraDSendMessage(nil)
			end)
		else
			_ENV = "loing_switch_world_map_type"
			;("loing_switch_world_map_type").msg = "MESSAGE_WORLD_MAP_SWITCH_MAP_TYPE"
			;("loing_switch_world_map_type").mapType = newType
			SoraDSendMessage("loing_switch_world_map_type")
		end
	end
end
function kingdomMapCtrl:getForbitWarTime()
	return self.kingdomMapCell:getForbitWarTime()
end
function kingdomMapCtrl:getForbitWarBeginTime()
	local forbidWarTime = self.kingdomMapCell:getForbitWarTime()
	if forbidWarTime and forbidWarTime.beginTime and forbidWarTime.beginTime > 0 then
		return forbidWarTime.beginTime - serviceFunctions.systemTime()
	end
	return 0
end
function kingdomMapCtrl:getForbitWarLeftTime()
	local forbidWarTime = self.kingdomMapCell:getForbitWarTime()
	if forbidWarTime and forbidWarTime.endTime and forbidWarTime.endTime > 0 then
		return forbidWarTime.endTime - serviceFunctions.systemTime()
	end
	return 0
end
function kingdomMapCtrl:isForbitWar()
	local forbid = self:getForbitWarBeginTime() <= 0 and 0 < self:getForbitWarLeftTime()
	if forbid then
		if worldMapDefine.isInRemains() then
			return false
		end
		if worldMapDefine.isInPyramid() then
			return false
		end
	end
	return forbid
end
function kingdomMapCtrl:getForbidMapObjWarTime(instanceType)
	return self.kingdomMapCell:getForbidMapObjWarTime(instanceType)
end
function kingdomMapCtrl:getForbidMapObjWarBeginTime(instanceType)
	local forbidMapObjWarTime = self.kingdomMapCell:getForbidMapObjWarTime(instanceType)
	if forbidMapObjWarTime and forbidMapObjWarTime.beginTime and forbidMapObjWarTime.beginTime > 0 then
		return forbidMapObjWarTime.beginTime - serviceFunctions.systemTime()
	end
	return 0
end
function kingdomMapCtrl:getForbidMapObjWarLeftTime(instanceType)
	local forbidMapObjWarTime = self.kingdomMapCell:getForbidMapObjWarTime(instanceType)
	if forbidMapObjWarTime and forbidMapObjWarTime.endTime and forbidMapObjWarTime.endTime > 0 then
		return forbidMapObjWarTime.endTime - serviceFunctions.systemTime()
	end
	return 0
end
function kingdomMapCtrl:isForbidMapObjWar(instanceType)
	local forbid = self:getForbidMapObjWarBeginTime(instanceType) <= 0 and 0 < self:getForbidMapObjWarLeftTime(instanceType)
	return forbid
end
function kingdomMapCtrl:getTreasureBowlInfo()
	return self.treasureBowlInfo
end
function kingdomMapCtrl:setViewPieceIds(viewPieceIDs)
	self.kingdomMapCell:setViewPieceIds(viewPieceIDs)
end
function kingdomMapCtrl:removeAllLocalQueue(mapId)
	if self.kingdomMapCell:onRemoveAllLocalQueue(mapId) then
		self:refreshLocalQueueUI()
	end
end
function kingdomMapCtrl:getQueueByID(queueID)
	return self.kingdomMapCell:getQueueByID(queueID)
end
function kingdomMapCtrl:refreshLocalQueueUI()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_PANDECT_MARCH"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_PANDECT_CAR"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW"
	;(nil).removeAll = true
	SoraDSendMessage(nil)
end
function kingdomMapCtrl:refreshShowHideMoveLine()
	serverproxy = nil
	;(nil).switchFlag = gSwitchWorldMapTypeDef.switchWorldMapType_out
	serverproxy:Request(gCmd.CMD_KINGDOM_MAP_MODULE, gCmd.REQ_SWITCH_WORLD_MAP, nil)
end
function kingdomMapCtrl:refreshKingdomID()
	self.kid = gametop.playertop_:getMapID()
end
function kingdomMapCtrl:getWatchTowerQueue(isWar)
	return self.kingdomMapCell:getWatchTowerQueue(isWar)
end
function kingdomMapCtrl:getQueueRootByWar(isWar)
	return self.kingdomMapCell:getQueueRootByWar(isWar)
end
function kingdomMapCtrl:getWatchTowerLightInfo()
	return self.kingdomMapCell:getWatchTowerLightInfo()
end
function kingdomMapCtrl:reqSetQueueForbidSpeed(queueId, isForbid, ...)
	print(queueId)
	print(isForbid)
	_ENV = print
	print.queueId = queueId
	local print.isForbid, data = isForbid, print
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_SET_FORBID_SPEED_QUEUE, data, ...)
end
function kingdomMapCtrl:onRspSetQueueForbidSpeed(rsp)
	dump(rsp)
	if rsp.err == gErrDef.Err_None then
	end
end
function kingdomMapCtrl:reqSetMass(queueId, massSlaveForbidArmyClass, massSlaveArmyMinLv, massSlaveArmyMaxNum, massSlaveArmyMinNum, isForbidSpeed)
	_ENV = nil
	;(nil).queueId = queueId
	;(nil).massSlaveForbidArmyClass = massSlaveForbidArmyClass
	;(nil).massSlaveArmyMinLv = massSlaveArmyMinLv
	;(nil).massSlaveArmyMaxNum = massSlaveArmyMaxNum
	;(nil).massSlaveArmyMinNum = massSlaveArmyMinNum
	local (nil).isForbidSpeed, data = isForbidSpeed, nil
	dump(data, "kingdomMapCtrl:reqSetMass", 10)
	serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.REQ_KINGDOM_QUEUE_SET_MASS, data)
end
function kingdomMapCtrl:onRspSetMass(content)
	dump(content, "kingdomMapCtrl:onRspSetMass", 10)
end
function kingdomMapCtrl:reqBackQueueRsp(content)
	dump(content, "kingdomMapCtrl:reqBackQueueRsp", 10)
	local queueId = content.clientData and content.clientData.queueId
	if queueId and _G._returnQueueIdList then
		_G._returnQueueIdList[queueId] = nil
	end
	if not content.data.uid then
		return
	end
	if content.err == gErrDef.Err_MAP_QUEUE_PLAYER_IS_NOT_OCCUPIER then
		SoraDShowMsgTip(i18n("notice_0026"))
		local panel = SoraDSearchPanelFromManagerByName("worldMapTroopsDetailsView")
		if panel then
			panel:removeFromParent()
		end
		return
	end
	if content.err == gErrDef.Err_None or not content.err then
		SoraDShowMsgTip(i18n("common_text_4527"))
	end
	SoraDDelayCallOnce("reqBackQueueRsp", function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_REQBACKQUEUE"
		SoraDSendMessage(nil)
	end)
end
function kingdomMapCtrl:reqBackQueueByIdRsp(content)
	dump(content, "kingdomMapCtrl:reqBackQueueByIdRsp", 10)
	local queueId = content.data.queueId
	if queueId and _G._returnQueueIdList then
		_G._returnQueueIdList[queueId] = nil
	end
end
function kingdomMapCtrl:getMoveLineData(queueId)
	return self.kingdomMapCell:getMoveLineData(queueId)
end
function kingdomMapCtrl:getMapInstanceData(instanceID)
	return self.kingdomMapCell:getMapInstanceData(instanceID)
end
function kingdomMapCtrl:getAndRequestAllAllianceBuild(kid)
	local version = self.kingdomMapCell:getVersion(kid)
	if not version or kid ~= self.kid then
		self:reqMapAllAllianceBuilding(kid, version)
	end
	self.kingdomMapCell:sendAllianceBuildData(kid)
end
function kingdomMapCtrl:onRemoeeAllianceBuild(kid)
	self.kingdomMapCell:onRemoeeAllianceBuild(kid)
end
function kingdomMapCtrl:getAllMapObj()
	return self.kingdomMapCell:getAllMapObj()
end
function kingdomMapCtrl:getKingdomMapCell(...)
	return self.kingdomMapCell
end
function kingdomMapCtrl:getAllQueue()
	return self.kingdomMapCell:getAllQueue()
end
function kingdomMapCtrl:getIsBattleEnd(mapClassType)
	return self.isBattleEnd[mapClassType] or false
end
function kingdomMapCtrl:setIsBattleEnd(mapClassType, isBattleEnd)
	if isBattleEnd then
		local worldMapWarDef = include("worldMapWarDef")
		if worldMapWarDef.isInMapClassType(mapClassType) then
			self.isBattleEnd[mapClassType] = isBattleEnd
		end
	else
		self.isBattleEnd[mapClassType] = isBattleEnd
	end
end
function kingdomMapCtrl:getKingdomPassTime()
	local startTime = self.kingdomStartTime or 0
	if 0 < startTime then
		local curTime = serviceFunctions.systemTime()
		local passTime = math.max(0, curTime - startTime)
		return passTime
	end
	return 0
end
return kingdomMapCtrl
