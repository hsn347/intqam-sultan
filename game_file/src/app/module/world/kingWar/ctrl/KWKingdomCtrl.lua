local gamemodulec = include("GameModule")
local KWKingdomCtrl = class("KWKingdomCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local KWKingdomCell = include("KWKingdomCell")
local KWMapCell = include("KWMapCell")
local KWPacksCell = include("KWPacksCell")
local KWRankCell = include("KWRankCell")
function KWKingdomCtrl:appiontKing(kingUid, ...)
	if self:isProxyKing() then
		serverproxy = nil
		;(nil).kingUid = kingUid
		serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_APPOINT_KING, nil, ...)
	else
		print("KWKingdomCtrl:appiontKing(kingUid, ...) error", worldMapDefine.kingdomStatus)
	end
end
function KWKingdomCtrl:changeName(newName, ...)
	if self:isKing() then
		serverproxy = nil
		;(nil).newName = newName
		serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_CHANGE_NAME, nil, ...)
	else
		print("KWKingdomCtrl:changeName(newName, ...) error", worldMapDefine.kingdomStatus)
	end
end
function KWKingdomCtrl:changeFlag(newFlag, ...)
	if self:isKing() then
		serverproxy = nil
		;(nil).newFlag = newFlag
		serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_CHANGE_FLAG, nil, ...)
	else
		print("KWKingdomCtrl:changeFlag(newFlag, ...) error", worldMapDefine.kingdomStatus)
	end
end
function KWKingdomCtrl:changePlace(newPlace, ...)
	if self:isKing() then
		serverproxy = nil
		;(nil).newPlace = newPlace
		serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_CHANGE_PLACE, nil, ...)
	else
		print("KWKingdomCtrl:changePlace(newPlace, ...) error", worldMapDefine.kingdomStatus)
	end
end
function KWKingdomCtrl:changeResRate(resId, ...)
	if self:isKing() then
		serverproxy = nil
		;(nil).resId = resId
		serverproxy:Request(gCmd.CMD_KW_MAP_MODULE, gCmd.REQ_KW_CHANGE_RES_RATE, nil, ...)
	else
		print("KWKingdomCtrl:changeResRate(resId, ...) error", worldMapDefine.kingdomStatus)
	end
end
function KWKingdomCtrl:givePacks(uid, type, ...)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local myRank = kingdomMapCtrl:getKingWarRank()
	if self:isKing() or myRank and 1 < myRank then
		gametop = nil
		;(nil).uid = uid
		;(nil).type = type
		serverproxy:Request(gCmd.CMD_KW_PACKS_MODULE, gCmd.REQ_KW_GIVE_PACKS, nil, ...)
	else
		print("KWKingdomCtrl:givePacks(uid, type, ...) error", worldMapDefine.kingdomStatus)
	end
end
function KWKingdomCtrl:appointOfficial(uid, type, ...)
	if self:isKing() or self:isQueen() then
		serverproxy = nil
		;(nil).uid = uid
		;(nil).type = type
		serverproxy:Request(gCmd.CMD_KW_RANK_MODULE, gCmd.REQ_KW_APPOINT_OFFICIAL, nil, ...)
	else
		print("KWKingdomCtrl:appointOfficial(uid, type, ...) error", worldMapDefine.kingdomStatus)
	end
end
function KWKingdomCtrl:dismissOfficial(uid, type, ...)
	if self:isKing() or self:isQueen() then
		serverproxy = nil
		;(nil).uid = uid
		;(nil).type = type
		serverproxy:Request(gCmd.CMD_KW_RANK_MODULE, gCmd.REQ_KW_DISMISS_OFFICIAL, nil, ...)
	else
		print("KWKingdomCtrl:dismissOfficial(uid, type, ...) error", worldMapDefine.kingdomStatus)
	end
end
function KWKingdomCtrl:getGivePackLog(rank, ...)
	print("KWKingdomCtrl:getGivePackLog(rank, ...)", rank)
	_ENV = nil
	;(nil).rank = rank
	serverproxy:Request(gCmd.CMD_KW_PACKS_MODULE, gCmd.REQ_KW_GIVE_PACK_LOG, nil, ...)
end
function KWKingdomCtrl:getPlayerGivePackLog()
	serverproxy:Request(gCmd.CMD_KW_PACKS_MODULE, gCmd.REQ_KW_GIVE_PARTICIPATOR_PACK_LOG)
end
function KWKingdomCtrl:getKingLog(startIndex, ...)
	local kid = worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).kid = kid
	;(nil).startIndex = startIndex
	serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_KING_LOG, nil, ...)
end
function KWKingdomCtrl:getPlaceLog(x, y, startIndex, ...)
	local placeId
	for _, setting in pairs(gPlaceSetting) do
		if setting.x == x and setting.y == y then
			placeId = setting.id
			break
		end
	end
	if placeId then
		local kid = worldMapDefine.currentMapKindomID
		_ENV = setting.y
		setting.y.startIndex = startIndex
		setting.y.placeId = placeId
		setting.y.kid = kid
		serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_GET_PLACE_LOG, setting.y, ...)
	else
		print("KWKingdomCtrl:getPlaceLog(x, y, startIndex, ...) placeId not found", x, y, startIndex)
	end
end
function KWKingdomCtrl:getKingWarScoreRank(...)
	local kid = worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_GET_WAR_SCORE_RANK, nil, ...)
end
function KWKingdomCtrl:getServiceWarOccupyRank(...)
	local kid = worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_GET_OCCUPY_RANK, nil, ...)
end
function KWKingdomCtrl:checkKingdomName(kingdomName)
	return KWKingdomCell.sharedInstance():checkKingdomName(kingdomName)
end
function KWKingdomCtrl:canChangeKingdomName()
	return KWKingdomCell.sharedInstance():canChangeKingdomName()
end
function KWKingdomCtrl:canChangeKingdomFlag()
	return KWKingdomCell.sharedInstance():canChangeKingdomFlag()
end
function KWKingdomCtrl:canChangeKingdomPlace()
	return KWKingdomCell.sharedInstance():canChangeKingdomPlace()
end
function KWKingdomCtrl:getKingdomName(isSelfKingdom)
	local kingdomName = self:getKingdomInfo(isSelfKingdom).kingdomName
	local mapInKid = worldMapDefine.currentMapKindomID
	if not isSelfKingdom and mapInKid and mapInKid ~= self.kid then
		return kingdomName
	else
		return serviceFunctions.getKingdomFormatName(kingdomName, self.kid)
	end
end
function KWKingdomCtrl:getKingdomFlag()
	return KWKingdomCell.sharedInstance():getKingdomFlag()
end
function KWKingdomCtrl:getKingdomPlace()
	return KWKingdomCell.sharedInstance():getKingdomPlace()
end
function KWKingdomCtrl:canChangeResRate()
	return KWMapCell.sharedInstance():canChangeResRate()
end
function KWKingdomCtrl:getPackUid(type)
	return KWPacksCell.sharedInstance():getPackUid(type)
end
function KWKingdomCtrl:canGivePack(uid)
	return KWPacksCell.sharedInstance():canGivePack(uid)
end
function KWKingdomCtrl:getOfficialUid(type)
	return KWRankCell.sharedInstance():getOfficialUid(type)
end
function KWKingdomCtrl:getOfficialTypeByUid(uid)
	return KWRankCell.sharedInstance():getOfficialTypeByUid(uid)
end
function KWKingdomCtrl:getOfficialUser(type)
	return KWRankCell.sharedInstance():getOfficialUser(type)
end
function KWKingdomCtrl:getPackData(isSelfKingdom)
	print("getPackData isSelfKingdom=", isSelfKingdom, self.kid)
	local kid = worldMapDefine.isWarKingdomID(worldMapDefine.currentMapKindomID) and self.kid or worldMapDefine.currentMapKindomID
	_ENV = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_KW_PACKS_MODULE, gCmd.REQ_KW_GET_PACK_DATA, nil)
end
function KWKingdomCtrl:getOfficialData(isSelfKingdom, isAsk)
	local kid = worldMapDefine.currentMapKindomID
	if not isSelfKingdom and kid and kid ~= self.kid then
		_ENV = nil
		;(nil).kid = kid
		serverproxy:Request(gCmd.CMD_KW_RANK_MODULE, gCmd.REQ_KW_GET_OFFICIAL_DATA, nil)
	elseif (self:isKing() or self:isProxyKing() or self:isQueen()) and not isAsk then
		local retData = KWRankCell.sharedInstance():getRank()
		dump(retData, "getOfficialData() 1")
		_ENV = retData
		retData.msg = "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_GETLIST"
		retData.retdate = retData
		SoraDSendMessage(retData)
	else
		_ENV = nil
		;(nil).kid = kid
		serverproxy:Request(gCmd.CMD_KW_RANK_MODULE, gCmd.REQ_KW_GET_OFFICIAL_DATA, nil)
	end
end
function KWKingdomCtrl:dismissOfficialByUid(uid, oType)
	if self:isKing() or self:isProxyKing() then
		KWRankCell.sharedInstance():dismissOfficial(uid, oType)
		KWRankCell = KWRankCell.sharedInstance()
		KWRankCell, KWRankCell.sharedInstance().msg = uid, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_SUB"
		uid.uid = uid
		KWRankCell.sharedInstance().redata, uid.type = uid, oType
		SoraDSendMessage((KWRankCell.sharedInstance()))
	end
end
function KWKingdomCtrl:ctor(properties)
	KWKingdomCtrl.super.ctor(self, properties)
	self:init()
end
function KWKingdomCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_APPOINT_KING, handler(self, self.appointKingRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_CHANGE_NAME, handler(self, self.changeNameRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_CHANGE_FLAG, handler(self, self.changeFlagRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_CHANGE_PLACE, handler(self, self.changePlaceRSP))
	msgCtrl.register(gCmd.CMD_KW_MAP_MODULE, gCmd.REQ_KW_CHANGE_RES_RATE, handler(self, self.changeResRateRSP))
	msgCtrl.register(gCmd.CMD_KW_PACKS_MODULE, gCmd.REQ_KW_GIVE_PACKS, handler(self, self.givePacksRSP))
	msgCtrl.register(gCmd.CMD_KW_RANK_MODULE, gCmd.REQ_KW_APPOINT_OFFICIAL, handler(self, self.appointOfficialRSP))
	msgCtrl.register(gCmd.CMD_KW_RANK_MODULE, gCmd.REQ_KW_DISMISS_OFFICIAL, handler(self, self.dismissOfficialRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_KING_DATA, handler(self, self.kingDataRSP))
	msgCtrl.register(gCmd.CMD_KW_PACKS_MODULE, gCmd.REQ_KW_GIVE_PACK_LOG, handler(self, self.givePackLogRSP))
	msgCtrl.register(gCmd.CMD_KW_PACKS_MODULE, gCmd.REQ_KW_GIVE_PARTICIPATOR_PACK_LOG, handler(self, self.playerGivePackLogRSP))
	msgCtrl.register(gCmd.CMD_KW_PACKS_MODULE, gCmd.REQ_KW_GET_PACK_DATA, handler(self, self.getPackDataRSP))
	msgCtrl.register(gCmd.CMD_KW_RANK_MODULE, gCmd.REQ_KW_GET_OFFICIAL_DATA, handler(self, self.getOfficialDataRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_KING_LOG, handler(self, self.getKingLogRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_GET_PLACE_LOG, handler(self, self.getPlaceLogRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_GET_KING, handler(self, self.getKingRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_GET_WAR_SCORE_RANK, handler(self, self.getKingWarScoreRankRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_GET_OCCUPY_RANK, handler(self, self.getOccupyRankRSP))
	msgCtrl.register(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_GET_NEW_PLAYER_MOVECITY, handler(self, self.setNewPlayerMoveCityRSP))
	self.kid = gametop.playertop_:getMapID()
	self.uid = gametop.playertop_:getPlayerID()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.KW, handler(self, self.onMsg))
end
function KWKingdomCtrl:Logout()
	KWKingdomCtrl.super.Logout(self)
end
function KWKingdomCtrl:init()
	self.status = gKingStatus.none
end
function KWKingdomCtrl:appointKingRSP(event)
	print("KWKingdomCtrl:appointKingRSP", event.data.errorCode)
	local data = event.data
	if data and data.errorCode == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function KWKingdomCtrl:changeNameRSP(event)
	print("KWKingdomCtrl:changeNameRSP", event.data.errorCode)
	local data = event.data
	if data and data.errorCode == gErrDef.Err_None then
		KWKingdomCell.sharedInstance():changeKingdomName(data.newName)
		_ENV = KWKingdomCell.sharedInstance()
		_ENV, KWKingdomCell.sharedInstance().msg = data.newName, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED"
		KWKingdomCell.sharedInstance().redata, data.newName.name = data.newName, data.newName
		SoraDSendMessage((KWKingdomCell.sharedInstance()))
	end
end
function KWKingdomCtrl:changeFlagRSP(event)
	print("KWKingdomCtrl:changeFlagRSP", event.data.errorCode)
	local data = event.data
	if data and data.errorCode == gErrDef.Err_None then
		KWKingdomCell.sharedInstance():changeKingdomFlag(data.newFlag)
		_ENV = KWKingdomCell.sharedInstance()
		_ENV, KWKingdomCell.sharedInstance().msg = data.newFlag, "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED"
		KWKingdomCell.sharedInstance().redata, data.newFlag.id = data.newFlag, data.newFlag
		SoraDSendMessage((KWKingdomCell.sharedInstance()))
	end
end
function KWKingdomCtrl:changePlaceRSP(event)
	print("KWKingdomCtrl:changePlaceRSP", event.data.errorCode)
	local data = event.data
	if data and data.errorCode == gErrDef.Err_None then
		KWKingdomCell.sharedInstance():changeKingdomPlace(data.newPlace)
		_ENV = KWKingdomCell.sharedInstance()
		_ENV, KWKingdomCell.sharedInstance().msg = data.newPlace, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMPALACE_CHANGED"
		KWKingdomCell.sharedInstance().redata, data.newPlace.id = data.newPlace, data.newPlace
		SoraDSendMessage((KWKingdomCell.sharedInstance()))
	end
end
function KWKingdomCtrl:changeResRateRSP(event)
	print("KWKingdomCtrl:changeResRateRSP", event.data.errorCode)
	local data = event.data
	if data and data.errorCode == gErrDef.Err_None then
		KWMapCell.sharedInstance():changeResRate(data.resId)
		_ENV = KWMapCell.sharedInstance()
		_ENV, KWMapCell.sharedInstance().msg = data.resId, "MESSAGE_SERVER_KINGDOMWAR_RESRATE_CHANGED"
		KWMapCell.sharedInstance().redata, data.resId.id = data.resId, data.resId
		SoraDSendMessage((KWMapCell.sharedInstance()))
	end
end
function KWKingdomCtrl:givePacksRSP(event)
	dump(event, "KWKingdomCtrl:givePacksRSP(event)")
	local data = event.data
	if data then
		if data.errorCode == gErrDef.Err_None then
			KWPacksCell.sharedInstance():givePacks(data.uid, data.type)
			_ENV = KWPacksCell.sharedInstance()
			_ENV, KWPacksCell.sharedInstance().msg = data.uid, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMGIFT_SENDSUCCESS"
			data.uid.uid = data.uid
			KWPacksCell.sharedInstance().redata, data.uid.type = data.uid, data.type
			SoraDSendMessage((KWPacksCell.sharedInstance()))
		elseif data.errorCode == gErrDef.Err_KW_REPEAT_ERROR then
			_ENV = data.type
			data.type.name = event.clientData
			SoraDShowMsgTip(i18n("common_text_1432", data.type))
		elseif data.errorCode == gErrDef.Err_KW_NOT_SAME_ALLIANCE then
			SoraDShowMsgTip(i18n("common_text_3399"))
		elseif data.errorCode == gErrDef.Err_ILLEGAL_PARAMS then
			SoraDShowMsgTip(i18n("notice_0026"))
		end
	end
end
function KWKingdomCtrl:appointOfficialRSP(event)
	print("KWKingdomCtrl:appointOfficialRSP", event.data.errorCode)
	local data = event.data
	if data then
		if data.errorCode == gErrDef.Err_None then
			KWRankCell.sharedInstance():appiontOfficial(data.uid, data.type, data.iconID, data.nickName, data.allianceName, data.allianceAbbr, data.avatar)
			_ENV = KWRankCell.sharedInstance()
			_ENV, KWRankCell.sharedInstance().msg = data.uid, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_ADD"
			data.uid.uid = data.uid
			KWRankCell.sharedInstance().redata, data.uid.type = data.uid, data.type
			SoraDSendMessage((KWRankCell.sharedInstance()))
		elseif data.errorCode == gErrDef.Err_KW_APPOINT_IN_CD then
			_ENV = data.type
			data.type.min = 10
			SoraDShowMsgTip(i18n("common_text_3209", data.type))
		elseif data.errorCode == gErrDef.Err_KW_NOT_KING then
			SoraDShowMsgTip(i18n("common_text_4701"))
		end
	end
end
function KWKingdomCtrl:dismissOfficialRSP(event)
	print("KWKingdomCtrl:dismissOfficialRSP", event.data.errorCode)
	local data = event.data
	if data and data.errorCode == gErrDef.Err_None then
		KWRankCell.sharedInstance():dismissOfficial(data.uid, data.type)
		_ENV = KWRankCell.sharedInstance()
		_ENV, KWRankCell.sharedInstance().msg = data.uid, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_SUB"
		data.uid.uid = data.uid
		KWRankCell.sharedInstance().redata, data.uid.type = data.uid, data.type
		SoraDSendMessage((KWRankCell.sharedInstance()))
		_ENV = KWRankCell.sharedInstance()
		KWRankCell.sharedInstance().msg = "MESSAGE_LORDINFO_DISMISS_TITLE_BACK"
		KWRankCell.sharedInstance().uid = data.uid
		KWRankCell.sharedInstance().officialType = gShowOfficialType.KING
		SoraDSendMessage((KWRankCell.sharedInstance()))
	end
end
function KWKingdomCtrl:kingDataRSP(event)
	dump(event, "KWKingdomCtrl:kingDataRSP", 10)
	local retData = event.retData
	self:setStatus(retData, true)
	self:onKingStatusChange(retData)
	self.newPlayerMoveCitySwitch = retData.newPlayerMoveCitySwitch
end
function KWKingdomCtrl:givePackLogRSP(event)
	local retData = event.retData
	dump(retData, "givePackLogRSP", 10)
	table.sort(retData, function(v1, v2)
		if v1.time and v2.time then
			return v2.time < v1.time
		end
	end)
	_ENV = retData
	retData.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PACK"
	retData.retdate = retData
	SoraDSendMessage(retData)
end
function KWKingdomCtrl:playerGivePackLogRSP(event)
	local retData = event.retData
	local _ENV, data
	for _, ranks in pairs(retData) do
		for _, v in pairs(ranks) do
			table.insert(data, v)
		end
	end
	table.sort(data, function(v1, v2)
		if v1.time and v2.time then
			return v2.time < v1.time
		end
	end)
	_ENV = data
	data.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PACK"
	data.retdate = data
	SoraDSendMessage(data)
end
local getTypeByKingdomLv = function(lv)
	return lv and 50 <= lv and 2 or 1
end
function KWKingdomCtrl:getPackDataRSP(event)
	if event.retData == nil then
		return
	end
	local retData = event.retData.packs
	local kingdomLv = getTypeByKingdomLv(event.retData.kingdomLv)
	dump(retData, "getPackDataRSP", 10)
	getTypeByKingdomLv = retData
	retData.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMGIFT_GETLIST"
	retData.retdate = retData
	retData.kingdomLv = kingdomLv
	SoraDSendMessage(retData)
end
function KWKingdomCtrl:getOfficialDataRSP(event)
	if event and event.retData then
		local retData = event.retData.official
		dump(retData, "getOfficialDataRSP", 10)
		_ENV = retData
		retData.msg = "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_GETLIST"
		retData.retdate = retData
		SoraDSendMessage(retData)
	end
end
function KWKingdomCtrl:getKingLogRSP(event)
	local retData = event.retData
	dump(retData, "getKingLogRSP", 10)
	_ENV = retData
	retData.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_KING"
	retData.retdate = retData
	retData.data = event.data
	SoraDSendMessage(retData)
end
function KWKingdomCtrl:getPlaceLogRSP(event)
	local retData = event.retData
	dump(retData, "getPlaceLogRSP", 10)
	_ENV = retData
	retData.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACE"
	retData.retdate = retData
	SoraDSendMessage(retData)
end
function KWKingdomCtrl:getKingRSP(event)
	local retData = event.retData
	dump(retData, "getKingRSP", 10)
end
function KWKingdomCtrl:getKingWarScoreRankRSP(event)
	local retData = event.retData
	dump(retData, "getKingWarScoreRankRSP", 10)
	_ENV = retData
	retData.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_ALLIANCEINTEGRAL"
	retData.retdate = retData
	SoraDSendMessage(retData)
end
function KWKingdomCtrl:getOccupyRankRSP(event)
	local retData = event.retData
	dump(retData, "getOccupyRankRSP", 10)
	_ENV = retData
	retData.msg = "MESSAGE_SERVER_KINGDOMWAR_GETLOG_OCCUPYTIME"
	retData.retdate = retData
	SoraDSendMessage(retData)
end
function KWKingdomCtrl:reqSetNewPlayerMoveCity(switch)
	print("KWKingdomCtrl:reqSetNewPlayerMoveCity", switch)
	_ENV = nil
	;(nil).switch = switch
	serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_GET_NEW_PLAYER_MOVECITY, nil)
end
function KWKingdomCtrl:setNewPlayerMoveCityRSP(event)
	dump(event, "KWKingdomCtrl:setNewPlayerMoveCityRSP", 10)
	if event.data.errorCode == gErrDef.Err_None then
		self.newPlayerMoveCitySwitch = event.data.switch
	end
end
function KWKingdomCtrl:getNewPlayerMoveCitySwitch()
	return self.newPlayerMoveCitySwitch or false
end
function KWKingdomCtrl:reqKingData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KW_MGR_MODULE, gCmd.REQ_KW_KING_DATA, nil, ...)
end
function KWKingdomCtrl:onMsg(event)
	local data = event.data
	dump(data, "KWKingdomCtrl:onMsg", 10)
	if data then
		for _, msg in pairs(data) do
			local msgType = msg.msgType
			if msgType == gKWMsgType.clientStatusChange then
				local data = msg.data
				self:setStatus(data.kingData)
			elseif msgType == gKWMsgType.warStatusChange then
				self:onWarStatusChange(msg)
			elseif msgType == gKWMsgType.kingStatusChange then
				local data = msg.data
				self:onKingStatusChange(data.kingData)
			elseif msgType == gKWMsgType.kingInfoChange then
				self:onKingInfoChange(msg)
			elseif msgType == gKWMsgType.kingdomInfoChange then
				self:onKingdomInfoChange(msg)
			elseif msgType == gKWMsgType.placeOwnerInfoChange then
				self:onPlaceOwnerInfoChange(msg)
			elseif msgType == gKWMsgType.placeCaptainChange then
				self:onPlaceCaptainChange(msg)
			elseif msgType == gKWMsgType.placeOccupyAllianceChange then
				self:onPlaceOccupyAllianceChange(msg)
			end
		end
	end
end
function KWKingdomCtrl:setStatus(data, isInit)
	print("KWKingdomCtrl:setStatus(data)", data.clientStatus)
	worldMapDefine.kingdomStatus = data.clientStatus
	self.status = data.clientStatus
	if self.status == gKingStatus.notKing then
		self:cancelKing()
	elseif self.status == gKingStatus.proxy or self.status == gKingStatus.king then
		self:becomeKing(data)
	end
	if data.packs then
		dump(data.packs, "data.packs=", 10)
		local KWPacksCell = include("KWPacksCell")
		KWPacksCell.sharedInstance():becomeKing(data.packs)
	end
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onKingWarStatusChange(isInit)
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED"
	SoraDSendMessage(kingdomMapCtrl)
end
function KWKingdomCtrl:onKingStatusChange(data)
	worldMapDefine.kingWarStatus = data.kingWarStatus
	worldMapDefine.kingdomProtectTime = data.kingdomProtectTime
	worldMapDefine.lastKingUid = data.lastKingUid
	local _ENV, kingdomInfo = worldMapDefine, worldMapDefine
	kingdomInfo.kingdomName = data.kingdomName
	kingdomInfo.kingdomFlag = data.kingdomFlag
	kingdomInfo.placeModel = data.placeModel
	KWKingdomCell.sharedInstance():setKingdomInfo(kingdomInfo)
	local _ENV, kingInfo = KWKingdomCell.sharedInstance().setKingdomInfo, KWKingdomCell.sharedInstance().setKingdomInfo
	kingInfo.kingName = data.kName
	kingInfo.kingUid = data.kUid
	kingInfo.kingIcon = data.kIcon
	kingInfo.kingAvatar = data.kAvatar
	kingInfo.kingAid = data.kAid
	kingInfo.kingAbbr = data.kAbbr
	kingInfo.kingFlag = data.kFlag
	worldMapDefine.currentKingdomKing = kingInfo.kingName
	print("当前国王1=", worldMapDefine.currentKingdomKing)
	KWKingdomCell.sharedInstance():setKingInfo(kingInfo)
	print("worldMapDefine.kingdomProtectTime=", worldMapDefine.kingdomProtectTime, "worldMapDefine.kingWarStatus", worldMapDefine.kingWarStatus)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local coolQueue = queueCtrl:queryQueue(gQueueTypeDef.world_resource_cool, gWorldResourceCoolQueueId)
	if not coolQueue then
		_ENV = nil
		queueCtrl:addQueue(gQueueTypeDef.world_resource_cool, serviceFunctions.systemTime(), worldMapDefine.kingdomProtectTime, worldMapDefine.kingdomProtectTime, nil, gWorldResourceCoolQueueId)
	else
		queueCtrl:restartLeftTime(gQueueTypeDef.world_resource_cool, worldMapDefine.kingdomProtectTime, gWorldResourceCoolQueueId)
	end
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onKingWarStatusChange()
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED"
	SoraDSendMessage(kingdomMapCtrl)
	SoradCreateTimer(self, handler(self, self.test))
end
function KWKingdomCtrl:onKingInfoChange(msg)
	KWKingdomCell.sharedInstance():setKingInfo(msg.data)
end
function KWKingdomCtrl:onKingdomInfoChange(msg)
	KWKingdomCell.sharedInstance():setKingdomInfo(msg.data)
end
function KWKingdomCtrl:getKingInfo()
	local mapInKid = worldMapDefine.currentMapKindomID
	if mapInKid and mapInKid ~= self.kid then
		print("KWKingdomCtrl:getKingInfo()")
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		if not kingdomMapCtrl:getOtherKingdomInfo().king then
			_ENV = kingdomMapCtrl:getOtherKingdomInfo().king
		end
		return kingdomMapCtrl:getOtherKingdomInfo().king
	else
		local info = KWKingdomCell.sharedInstance():getKingInfo()
		return info
	end
end
function KWKingdomCtrl:getKingdomInfo(isSelfKingdom)
	local mapInKid = worldMapDefine.currentMapKindomID
	if not isSelfKingdom and mapInKid and mapInKid ~= self.kid then
		print("KWKingdomCtrl:getKingdomInfo()")
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		if not kingdomMapCtrl:getOtherKingdomInfo().kingdom then
			_ENV = kingdomMapCtrl:getOtherKingdomInfo().kingdom
		end
		return kingdomMapCtrl:getOtherKingdomInfo().kingdom
	else
		return KWKingdomCell.sharedInstance():getKingdomInfo()
	end
end
function KWKingdomCtrl:getKingdomCastaleModel()
	return KWKingdomCell.sharedInstance():getKingdomInfo().placeModel or 1
end
function KWKingdomCtrl:onPlaceOccupyAllianceChange(msg)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onPlaceOccupyAllianceChange(msg)
end
function KWKingdomCtrl:onPlaceCaptainChange(msg)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onPlaceCaptainChange(msg)
end
function KWKingdomCtrl:onWarStatusChange(msg)
	worldMapDefine.kingWarStatus = msg.data.status
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onKingWarStatusChange(nil, msg.data.resetCaptainShow)
	_ENV = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED"
	SoraDSendMessage(kingdomMapCtrl)
end
function KWKingdomCtrl:onPlaceOwnerInfoChange(msg)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onPlaceOwnerInfoChange(msg)
end
function KWKingdomCtrl:isProxyKing()
	print("self.status == gKingStatus.proxy", self.status == gKingStatus.proxy)
	return self.status == gKingStatus.proxy
end
function KWKingdomCtrl:isKing()
	return self.status == gKingStatus.king
end
function KWKingdomCtrl:isQueen()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	return lordInfoCtrl:getSelfOfficial() == gKingOfficialType.queen
end
function KWKingdomCtrl:cancelKing()
	local KWKingdomCell = include("KWKingdomCell")
	KWKingdomCell.sharedInstance():cancelKing()
	local KWMapCell = include("KWMapCell")
	KWMapCell.sharedInstance():cancelKing()
	local KWPacksCell = include("KWPacksCell")
	KWPacksCell.sharedInstance():cancelKing()
	local KWRankCell = include("KWRankCell")
	KWRankCell.sharedInstance():cancelKing()
end
function KWKingdomCtrl:becomeKing(data)
	if data.king then
		local KWKingdomCell = include("KWKingdomCell")
		KWKingdomCell.sharedInstance():becomeKing(data.king)
	end
	if data.map then
		local KWMapCell = include("KWMapCell")
		KWMapCell.sharedInstance():becomeKing(data.map)
	end
	if data.packs then
		local KWPacksCell = include("KWPacksCell")
		KWPacksCell.sharedInstance():becomeKing(data.packs)
	end
	if data.rank then
		local KWRankCell = include("KWRankCell")
		KWRankCell.sharedInstance():becomeKing(data.rank)
	end
end
function KWKingdomCtrl:initClientData(data)
	self:reqKingData()
end
function KWKingdomCtrl:setAtlantisTitle(title)
	KWKingdomCell.sharedInstance():setAtlantisTitle(title)
end
function KWKingdomCtrl:getAtlantisTitle()
	return KWKingdomCell.sharedInstance():getAtlantisTitle()
end
local testTimerRunTimes = 0
function KWKingdomCtrl:test()
	do return end
	local uid = self.uid
	if (uid == 4 or uid == 502) and testTimerRunTimes % 10 == 0 then
		self:getPackData()
		self:getOfficialData()
		self:getGivePackLog()
	end
end
return KWKingdomCtrl
