local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local warShelterCtrl = class("warShelterCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function warShelterCtrl:ctor(properties)
	warShelterCtrl.super.ctor(self, properties)
	self:resetData()
end
function warShelterCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RECV_INVITE_MAP, handler(self, self.reqRecvInviteMapRsp))
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_SEND_INVITE, handler(self, self.reqSendInviteRsp))
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RECV_INVITE_ENABLE, handler(self, self.reqRecvInviteEnableRsp))
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RECV_INVITE_ACCEPT, handler(self, self.reqRecvInviteAcceptRsp))
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RECV_INVITE_REJECT, handler(self, self.reqRecvInviteRejectRsp))
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RELEASE_FROM, handler(self, self.reqReleaseFromRsp))
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RELEASE_TO, handler(self, self.reqReleaseToRsp))
	msgCtrl.register(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_OPEN, handler(self, self.reqOpenRsp))
	self:registerNotify()
end
function warShelterCtrl:Logout()
	warShelterCtrl.super.Logout(self)
	self:resetData()
end
function warShelterCtrl:resetData()
	;(nil).shelter, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	;(nil).recvInviteMap, _UPVALUE0_, (nil).recvInviteEnable = nil, nil, false
	self.data, (nil).hasNewInviteRecv = nil, false
end
function warShelterCtrl:initClientData(hasNewInviteRecv)
	dump(hasNewInviteRecv, "warShelterCtrl:initClientData===")
	if hasNewInviteRecv ~= nil then
		self.data.hasNewInviteRecv = hasNewInviteRecv
	end
end
function warShelterCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAR_SHELTER, handler(self, self.notifyHandler))
end
function warShelterCtrl:notifyHandler(event)
	dump(event, "warShelterCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.hasNewInviteRecv ~= nil then
			self.data.hasNewInviteRecv = v.hasNewInviteRecv
		end
		if v.shelter then
			self.data.shelter = v.shelter
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER"
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_MAINCITYVIEW_ADD_SHELTER_TOP_TIP"
	SoraDSendMessage(ipairs(event.data))
end
function warShelterCtrl:reqData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_DATA, nil)
end
function warShelterCtrl:reqDataRsp(content)
	dump(content, "warShelterCtrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.shelter = content.rspdata.shelter
		self.data.recvInviteEnable = content.rspdata.recvInviteEnable
		_ENV = content.rspdata.recvInviteEnable
		content.rspdata.recvInviteEnable.msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER"
		SoraDSendMessage(content.rspdata.recvInviteEnable)
	end
end
function warShelterCtrl:reqRecvInviteMap()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RECV_INVITE_MAP, nil)
end
function warShelterCtrl:reqRecvInviteMapRsp(content)
	dump(content, "warShelterCtrl:reqRecvInviteMapRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.recvInviteMap = content.rspdata.recvInviteMap
		self.data.hasNewInviteRecv = content.rspdata.hasNewInviteRecv
		_ENV = content.rspdata.hasNewInviteRecv
		content.rspdata.hasNewInviteRecv.msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER"
		SoraDSendMessage(content.rspdata.hasNewInviteRecv)
		_ENV = content.rspdata.hasNewInviteRecv
		content.rspdata.hasNewInviteRecv.msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER_INVIEMAP"
		SoraDSendMessage(content.rspdata.hasNewInviteRecv)
		_ENV = content.rspdata.hasNewInviteRecv
		content.rspdata.hasNewInviteRecv.msg = "MESSAGE_MAINCITYVIEW_REMOVE_SHELTER_TOP_TIP"
		SoraDSendMessage(content.rspdata.hasNewInviteRecv)
	end
end
function warShelterCtrl:reqSendInvite(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_SEND_INVITE, nil)
end
function warShelterCtrl:reqSendInviteRsp(content)
	dump(content, "warShelterCtrl:reqSendInviteRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	elseif content.err == gErrDef.Err_WAR_SHELTER_RECV_INVITE_DISABLE then
		SoraDShowMsgTip(i18n("war_shelter_015"))
	elseif content.err == gErrDef.Err_WAR_SHELTER_ALREADY_RECV_INVITE then
		SoraDShowMsgTip(i18n("war_shelter_027"))
	elseif content.err == gErrDef.Err_WAR_SHELTER_RECV_INVITE_REACH_MAX then
		SoraDShowMsgTip(i18n("war_shelter_028"))
	elseif content.err == gErrDef.Err_WAR_SHELTER_ALREADY_SHELTER_SOMEONE then
		SoraDShowMsgTip(i18n("war_shelter_016"))
	elseif content.err == gErrDef.Err_WAR_SHELTER_NOT_IN_NORMAL_KINGDOM then
		SoraDShowMsgTip(i18n("war_shelter_029"))
	elseif content.err == gErrDef.Err_WAR_SHELTER_ALREADY_SHELTER_BY_SOMEONE then
		SoraDShowMsgTip(i18n("war_shelter_032"))
	end
end
function warShelterCtrl:reqRecvInviteEnable(recvInviteEnable)
	serverproxy = nil
	;(nil).recvInviteEnable = recvInviteEnable
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RECV_INVITE_ENABLE, nil)
end
function warShelterCtrl:reqRecvInviteEnableRsp(content)
	dump(content, "warShelterCtrl:reqRecvInviteEnableRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.recvInviteEnable = content.data.recvInviteEnable
	end
end
function warShelterCtrl:reqRecvInviteAccept(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RECV_INVITE_ACCEPT, nil)
end
function warShelterCtrl:reqRecvInviteAcceptRsp(content)
	dump(content, "warShelterCtrl:reqRecvInviteAcceptRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.shelter.from = content.rspdata.from
		_ENV = content.rspdata.from
		content.rspdata.from.msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER"
		SoraDSendMessage(content.rspdata.from)
	end
end
function warShelterCtrl:reqRecvInviteReject(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RECV_INVITE_REJECT, nil)
end
function warShelterCtrl:reqRecvInviteRejectRsp(content)
	dump(content, "warShelterCtrl:reqRecvInviteRejectRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.recvInviteMap[tostring(content.data.uid)] = nil
		_ENV = tostring(content.data.uid)
		tostring(content.data.uid).msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER_INVIEMAP"
		SoraDSendMessage((tostring(content.data.uid)))
	end
end
function warShelterCtrl:reqReleaseFrom()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RELEASE_FROM, nil)
end
function warShelterCtrl:reqReleaseFromRsp(content)
	dump(content, "warShelterCtrl:reqReleaseFromRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.shelter = content.rspdata
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER"
		SoraDSendMessage(content.rspdata)
	end
end
function warShelterCtrl:reqReleaseTo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_RELEASE_TO, nil)
end
function warShelterCtrl:reqReleaseToRsp(content)
	dump(content, "warShelterCtrl:reqReleaseToRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.shelter = content.rspdata
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER"
		SoraDSendMessage(content.rspdata)
	end
end
function warShelterCtrl:reqOpen(itemId, mode)
	serverproxy = nil
	;(nil).itemId = itemId
	;(nil).mode = mode
	serverproxy:Request(gCmd.CMD_WAR_SHELTER_MODULE, gCmd.REQ_WAR_SHELTER_OPEN, nil)
end
function warShelterCtrl:reqOpenRsp(content)
	dump(content, "warShelterCtrl:reqOpenRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.shelter = content.rspdata
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_SERVER_WATCHTOWER_SHELTER"
		SoraDSendMessage(content.rspdata)
	elseif content.err == gErrDef.Err_WAR_SHELTER_HAS_WAR_QUEUE then
		SoraDShowMsgTip(i18n("war_shelter_033"))
	elseif content.err == gErrDef.Err_WAR_SHELTER_NOT_IN_NORMAL_KINGDOM then
		SoraDShowMsgTip(i18n("war_shelter_008"))
	end
end
function warShelterCtrl:getShelterTo()
	return self.data.shelter.to
end
function warShelterCtrl:isInSpecialMap()
	local mapId = self.data.shelter.to and self.data.shelter.to.mapId
	return mapId and mapId ~= gKingdomClassType.normal
end
function warShelterCtrl:getShelterToLeftTime()
	local shelterEndTime = self.data.shelter.to and self.data.shelter.to.shelterEndTime or -1
	if 0 < shelterEndTime then
		return shelterEndTime - serviceFunctions.systemTime()
	else
		return 0
	end
end
function warShelterCtrl:getShelterFrom()
	return self.data.shelter.from
end
function warShelterCtrl:getShelterFromLeftTime()
	local shelterEndTime = self.data.shelter.from and self.data.shelter.from.shelterEndTime or -1
	if 0 < shelterEndTime then
		return shelterEndTime - serviceFunctions.systemTime()
	else
		return 0
	end
end
function warShelterCtrl:getRecvInviteEnable()
	return self.data.recvInviteEnable
end
function warShelterCtrl:getRecvInviteList()
	local _ENV, list
	if not self.data.recvInviteMap then
		_ENV = self.data.recvInviteMap
	end
	for _, v in pairs(self.data.recvInviteMap) do
		table.insert(list, v)
	end
	table.sort(list, function(a, b)
		return a.totalFc < b.totalFc
	end)
	return list
end
function warShelterCtrl:hasNewInviteRecvRed()
	return self.data.hasNewInviteRecv
end
return warShelterCtrl
