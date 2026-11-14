local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local kingdomQueueObjCell = include("kingdomQueueObjCell")
local escortAssistMgr = include("escortAssistMgr")
local escortAssistCtrl = class("escortAssistCtrl", GameModule)
function escortAssistCtrl:ctor(properties)
	escortAssistCtrl.super.ctor(self, properties)
end
function escortAssistCtrl:EnterGame()
	escortAssistCtrl.super.EnterGame(self)
	self.dataMgr = escortAssistMgr.new()
	msgCtrl.register(gCmd.CMD_ESCORT_ASSIST_MODULE, gCmd.REQ_ESCORT_ASSIST_INVITE, handler(self, self.onRspInviteAssist))
	msgCtrl.register(gCmd.CMD_ESCORT_ASSIST_MODULE, gCmd.REQ_ESCORT_ASSIST_ACCEPT, handler(self, self.onRspAcceptAssist))
	msgCtrl.register(gCmd.CMD_ESCORT_ASSIST_MODULE, gCmd.REQ_ESCORT_ASSIST_REJECT, handler(self, self.onRspRejectAssist))
	self:reqUpdateData()
end
function escortAssistCtrl:Logout()
	escortAssistCtrl.super.Logout(self)
	self.dataMgr = nil
end
function escortAssistCtrl:initClientData(data)
	if not data then
		return
	end
	self.dataMgr.data.inviteSend = data.inviteSendMap
	if self.dataMgr.data.inviteSend then
		for uid, invite in pairs(self.dataMgr.data.inviteSend) do
			if invite.status == gEscortInviteStatus.WAIT then
				self:addTimeQueue(gQueueTypeDef.escort_assist_invite_send, invite.uid, invite.t, invite.timeout)
			elseif invite.status == gEscortInviteStatus.ACCEPT then
				self:addTimeQueue(gQueueTypeDef.escort_assist_wait_self_escort, invite.uid, invite.t, invite.timeout)
			end
		end
	end
	self.dataMgr.data.inviteRecv = data.inviteRecvMap
	if self.dataMgr.data.inviteRecv then
		for uid, invite in pairs(self.dataMgr.data.inviteRecv) do
			if invite.watchTowerData then
				local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
				kingdomMapCtrl:getWatchTowerQueue():addQueue(kingdomQueueObjCell.new(invite.watchTowerData))
			end
			if invite.status == gEscortInviteStatus.ACCEPT then
				self:addTimeQueue(gQueueTypeDef.escort_assist_wait_other_escort, invite.uid, invite.t, invite.timeout)
			end
		end
	end
end
function escortAssistCtrl:addTimeQueue(type, uid, starttime, totaltime, lefttime)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	gametop = gametop.playertop_
	gametop.playertop_.uid = uid
	local gametop.playertop_.endtime, queueData = starttime + totaltime, gametop.playertop_
	if not lefttime then
		lefttime = starttime + totaltime - serviceFunctions.systemTime()
		lefttime = math.max(lefttime, 0)
	end
	queueCtrl:addQueue(type, starttime, totaltime, lefttime, queueData)
end
function escortAssistCtrl:rmTimeQueue(type)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:removeQueue(type)
end
function escortAssistCtrl:reqInviteAssist(uids, ...)
	local escortCtrl = gametop.playertop_:getModule("escortCtrl")
	local stat = escortCtrl:getStat()
	gametop = escortCtrl
	escortCtrl.uids = uids
	escortCtrl.stat = stat
	local escortCtrl.systemTime, data = serviceFunctions.systemTime(), escortCtrl
	serverproxy:Request(gCmd.CMD_ESCORT_ASSIST_MODULE, gCmd.REQ_ESCORT_ASSIST_INVITE, data, ...)
end
function escortAssistCtrl:reqAcceptAssist(uid, ...)
	serverproxy = nil
	local (nil).uid, data = uid, nil
	serverproxy:Request(gCmd.CMD_ESCORT_ASSIST_MODULE, gCmd.REQ_ESCORT_ASSIST_ACCEPT, data, ...)
end
function escortAssistCtrl:reqRejectAssist(uid, ...)
	serverproxy = nil
	local (nil).uid, data = uid, nil
	serverproxy:Request(gCmd.CMD_ESCORT_ASSIST_MODULE, gCmd.REQ_ESCORT_ASSIST_REJECT, data, ...)
end
function escortAssistCtrl:onRspInviteAssist(rsp)
	local hasAddTimeQueue = false
	if rsp.err == gErrDef.Err_None then
		if rsp.data.inviteMap and next(rsp.data.inviteMap) then
			for _, invite in pairs(rsp.data.inviteMap) do
				self.dataMgr:addInviteSend(invite)
				if not hasAddTimeQueue then
					self:addTimeQueue(gQueueTypeDef.escort_assist_invite_send, invite.uid, invite.t, invite.timeout, invite.timeout)
					hasAddTimeQueue = true
				end
			end
		end
		_ENV = pairs(rsp.data.inviteMap)
		pairs(rsp.data.inviteMap).msg = "MESSAGE_SERVER_ESCORT_INVITE_SUCCESS"
		pairs(rsp.data.inviteMap).data = rsp.data
		SoraDSendMessage(pairs(rsp.data.inviteMap))
	else
		_ENV = pairs(rsp.data.inviteMap)
		pairs(rsp.data.inviteMap).msg = "MESSAGE_SERVER_ESCORT_INVITE_FAILED"
		pairs(rsp.data.inviteMap).err = rsp.err
		pairs(rsp.data.inviteMap).data = rsp.data
		SoraDSendMessage(pairs(rsp.data.inviteMap))
	end
end
function escortAssistCtrl:onRspAcceptAssist(rsp)
	if rsp.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_ESCORT_WATCHTOWER_INVITE_ACCEPTED"
		gErrDef.Err_None.data = rsp.data
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "ESCORT_REQ_ASSIST_ACCEPT_FAILED"
		gErrDef.Err_None.err = rsp.err
		gErrDef.Err_None.data = rsp.data
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function escortAssistCtrl:onRspRejectAssist(rsp)
	if rsp.err == gErrDef.Err_None then
		self.dataMgr:delInviteRecv(rsp.data.uid)
		if rsp.data.watchTowerData then
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			kingdomMapCtrl:getWatchTowerQueue():removeQueue(kingdomQueueObjCell.new(rsp.data.watchTowerData))
		end
		_ENV = kingdomMapCtrl:getWatchTowerQueue().removeQueue
		kingdomMapCtrl:getWatchTowerQueue().removeQueue.msg = "ESCORT_REQ_ASSIST_REJECT_SUCCESS"
		kingdomMapCtrl:getWatchTowerQueue().removeQueue.data = rsp.data
		SoraDSendMessage(kingdomMapCtrl:getWatchTowerQueue().removeQueue)
	else
		_ENV = kingdomMapCtrl:getWatchTowerQueue().removeQueue
		kingdomMapCtrl:getWatchTowerQueue().removeQueue.msg = "ESCORT_REQ_ASSIST_REJECT_FAILED"
		kingdomMapCtrl:getWatchTowerQueue().removeQueue.err = rsp.err
		kingdomMapCtrl:getWatchTowerQueue().removeQueue.data = rsp.data
		SoraDSendMessage(kingdomMapCtrl:getWatchTowerQueue().removeQueue)
	end
end
function escortAssistCtrl:reqUpdateData()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ESCORT_ASSIST, handler(self, self.onNotifyMsg))
end
function escortAssistCtrl:onNotifyMsg(notification)
	print("[INFO] escortAssistCtrl:onNotifyMsg")
	for i = 1, #notification.data do
		local msg = notification.data[i]
		if msg.type == gEscortAssistNotifyType.INVITE_RECEIVED then
			self:onNotifyInviteReceived(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_ACCEPTED then
			self:onNotifyInviteAccepted(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_ACCEPTED_AND_SEND_TROOP then
			self:onNotifyInviteAcceptedAndSendTroop(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_REJECTED then
			self:onNotifyInviteRejected(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_SEND_TIMEOUT then
			self:onNotifyInviteSendTimeout(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_RECV_TIMEOUT then
			self:onNotifyInviteRecvTimeout(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_SEND_WAIT_SELF_ESCORT_TIMEOUT then
			self:onNotifyInviteSendWaitSelfEscortTimeout(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_RECV_WAIT_OTHER_ESCORT_TIMEOUT then
			self:onNotifyInviteRecvWaitOtherEscortTimeout(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_RECV_INVALID_OTHER_ESCORT_ALREADY then
			self:onNotifyInviteRecvInvalidOtherEscortAlready(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_SEND_DEL_FOR_SELF_ESCORT then
			self:onNotifyInviteSendDelForSelfEscort(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_RECV_DEL_FOR_SELF_ASSIST then
			self:onNotifyInviteRecvDelForSelfAssist(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_RECV_REJECT then
			self:onNotifyInviteRecvReject(msg)
		elseif msg.type == gEscortAssistNotifyType.INVITE_SEND_WAIT_SELF_ESCORT_INVALID then
			self:onNotifyInviteSendWaitSelfEsocrtInvalid(msg)
		end
		if msg.watchTowerData then
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			if msg.type == gEscortAssistNotifyType.INVITE_RECEIVED then
				kingdomMapCtrl:getWatchTowerQueue():addQueue(kingdomQueueObjCell.new(msg.watchTowerData))
			elseif msg.type == gEscortAssistNotifyType.INVITE_ACCEPTED_AND_SEND_TROOP or msg.type == gEscortAssistNotifyType.INVITE_RECV_TIMEOUT or msg.type == gEscortAssistNotifyType.INVITE_RECV_INVALID_OTHER_ESCORT_ALREADY or msg.type == gEscortAssistNotifyType.INVITE_RECV_REJECT then
				kingdomMapCtrl:getWatchTowerQueue():removeQueue(kingdomQueueObjCell.new(msg.watchTowerData))
			end
		end
	end
end
function escortAssistCtrl:onNotifyInviteReceived(msg)
	self.dataMgr:addInviteRecv(msg.uid, msg.t)
	_ENV = self.dataMgr
	self.dataMgr.msg = "MESSAGE_ESCORT_ASSIST_INVITE_RECEIVED"
	self.dataMgr.uid = msg.uid
	self.dataMgr.t = msg.t
	SoraDSendMessage(self.dataMgr)
end
function escortAssistCtrl:onNotifyInviteAccepted(msg)
	self.dataMgr:setInviteSend(msg.uid, gEscortInviteStatus.ACCEPT, msg.t, msg.queueInfo)
	self:rmTimeQueue(gQueueTypeDef.escort_assist_invite_send)
	self:addTimeQueue(gQueueTypeDef.escort_assist_wait_self_escort, msg.uid, msg.t, msg.timeout, msg.timeout)
	_ENV = self
	self.msg = "MESSAGE_SERVER_ESCORT_ASSIST_INVITE_ACCEPTED"
	self.uid = msg.uid
	self.t = msg.t
	self.queueInfo = msg.queueInfo
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteRejected(msg)
	self.dataMgr:delInviteSend(msg.uid)
	if not self.dataMgr:getInviteSendMap() or not next(self.dataMgr:getInviteSendMap()) then
		self:rmTimeQueue(gQueueTypeDef.escort_assist_invite_send)
	end
	_ENV = self
	self.msg = "MESSAGE_SERVER_ESCORT_ASSIST_INVITE_REJECTED"
	self.uid = msg.uid
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteSendTimeout(msg)
	self.dataMgr:delInviteSend(msg.uid)
	if not self.dataMgr:getInviteSendMap() or not next(self.dataMgr:getInviteSendMap()) then
		self:rmTimeQueue(gQueueTypeDef.escort_assist_invite_send)
	end
	_ENV = self
	self.msg = "MESSAGE_SERVER_ESCORT_SEND_INVITE_TIME_OUT"
	self.uid = msg.uid
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteAcceptedAndSendTroop(msg)
	self.dataMgr:setInviteRecv(msg.uid, gEscortInviteStatus.ACCEPT, msg.t)
	self:addTimeQueue(gQueueTypeDef.escort_assist_wait_other_escort, msg.uid, msg.t, msg.timeout, msg.timeout)
	_ENV = self
	self.msg = "MESSAGE_SERVER_ESCORT_ASSIST_ACCEPT_AND_SEND_TROOP"
	self.uid = msg.uid
	self.t = msg.t
	self.queueInfo = msg.queueInfo
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteRecvTimeout(msg)
	self.dataMgr:delInviteRecv(msg.uid)
	_ENV = self.dataMgr
	self.dataMgr.msg = "MESSAGE_ESCORT_ASSIST_INVITE_RECV_TIMEOUT"
	self.dataMgr.uid = msg.uid
	SoraDSendMessage(self.dataMgr)
end
function escortAssistCtrl:onNotifyInviteSendWaitSelfEscortTimeout(msg)
	self.dataMgr:delInviteSend(msg.uid)
	self:rmTimeQueue(gQueueTypeDef.escort_assist_wait_self_escort)
	_ENV = self
	self.msg = "MESSAGE_SERVER_ESCORT_SELF_ESCORT_TIMEOUT"
	self.uid = msg.uid
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteRecvWaitOtherEscortTimeout(msg)
	self.dataMgr:delInviteRecv(msg.uid)
	self:rmTimeQueue(gQueueTypeDef.escort_assist_wait_other_escort)
	_ENV = self
	self.msg = "MESSAGE_ESCORT_ASSIST_INVITE_RECV_WAIT_OTHER_ESCORT_TIMEOUT"
	self.uid = msg.uid
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteRecvInvalidOtherEscortAlready(msg)
	self.dataMgr:delInviteRecv(msg.uid)
	self:rmTimeQueue(gQueueTypeDef.escort_assist_wait_other_escort)
	_ENV = self
	self.msg = "MESSAGE_ESCORT_ASSIST_INVITE_RECV_INVALID_OTHER_EACORT_ALREADY"
	self.uid = msg.uid
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteSendDelForSelfEscort(msg)
	self.dataMgr:delInviteSend(msg.uid)
	self:rmTimeQueue(gQueueTypeDef.escort_assist_wait_self_escort)
	_ENV = self
	self.msg = "MESSAGE_ESCORT_ASSIST_INVITE_SEND_DEL"
	self.uid = msg.uid
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteRecvDelForSelfAssist(msg)
	self.dataMgr:delInviteRecv(msg.uid)
	self:rmTimeQueue(gQueueTypeDef.escort_assist_wait_other_escort)
	_ENV = self
	self.msg = "MESSAGE_ESCORT_ASSIST_INVITE_RECV_DEL"
	self.uid = msg.uid
	SoraDSendMessage(self)
end
function escortAssistCtrl:onNotifyInviteRecvReject(msg)
	self.dataMgr:delInviteRecv(msg.uid)
	_ENV = self.dataMgr
	self.dataMgr.msg = "MESSAGE_ESCORT_ASSIST_INVITE_RECV_REJECT"
	self.dataMgr.uid = msg.uid
	SoraDSendMessage(self.dataMgr)
end
function escortAssistCtrl:onNotifyInviteSendWaitSelfEsocrtInvalid(msg)
	self.dataMgr:delInviteSend(msg.uid)
	self:rmTimeQueue(gQueueTypeDef.escort_assist_wait_self_escort)
	_ENV = self
	self.msg = "MESSAGE_SERVER_ESCORT_SELF_ESCORT_TIMEOUT"
	self.uid = msg.uid
	SoraDSendMessage(self)
end
function escortAssistCtrl:getInviteSendMap()
	return self.dataMgr:getInviteSendMap()
end
function escortAssistCtrl:getInviteSend()
	return self.dataMgr:getInviteSendMap()
end
function escortAssistCtrl:getInviteRecvMap()
	return self.dataMgr:getInviteRecvMap()
end
return escortAssistCtrl
