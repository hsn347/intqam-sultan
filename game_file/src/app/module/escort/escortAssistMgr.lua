local escortAssistMgr = class("escortAssistMgr")
function escortAssistMgr:ctor()
	self.data, _UPVALUE0_ = nil, nil
end
function escortAssistMgr:checkInvalidInvite()
	self:checkInviteSend()
	self:checkInviteRecv()
end
function escortAssistMgr:checkInviteSend()
	if self.data.inviteSend and next(self.data.inviteSend) then
		for uid, invite in pairs(self.data.inviteSend) do
			if not self:isInviteValid(invite.status, invite.t) then
				self.data.inviteSend[uid] = nil
			end
		end
		if not next(self.data.inviteSend) then
			self.data.inviteSend = nil
		end
	end
end
function escortAssistMgr:checkInviteRecv()
	if self.data.inviteRecv and next(self.data.inviteRecv) then
		for uid, invite in pairs(self.data.inviteRecv) do
			if not self:isInviteValid(invite.status, invite.t) then
				self.data.inviteRecv[uid] = nil
			end
		end
		if not next(self.data.inviteRecv) then
			self.data.inviteRecv = nil
		end
	end
end
function escortAssistMgr:isInviteValid(status, t)
	if not t then
		return false
	end
	local nowTime = serviceFunctions.systemTime()
	if status == gEscortInviteStatus.ACCEPT then
		if nowTime > t + ESCORT_ASSIST_ACCEPT_WAIT_ESCORT_TIMEOUT then
			return false
		end
	elseif nowTime > t + ESCORT_ASSIST_INVITE_MSG_TIMEOUT then
		return false
	end
	return true
end
function escortAssistMgr:getInviteSendMap()
	self:checkInviteSend()
	return self.data.inviteSend
end
function escortAssistMgr:delInviteSendMap()
	self.data.inviteSend = nil
end
function escortAssistMgr:getInviteSend(uid)
	if self.data.inviteSend then
		local invite = self.data.inviteSend[tostring(uid)]
		if invite and self:isInviteValid(invite.status, invite.t) then
			return invite
		else
			self.data.inviteSend[tostring(uid)] = nil
		end
	end
end
function escortAssistMgr:addInviteSend(invite)
	if not self.data.inviteSend then
		self.data.inviteSend, _ENV = nil, nil
	end
	self.data.inviteSend[tostring(invite.uid)] = invite
end
function escortAssistMgr:setInviteSend(uid, status, t, queueInfo)
	if not self.data.inviteSend then
		self.data.inviteSend, _ENV = nil, nil
	end
	if not self.data.inviteSend[tostring(uid)] then
		self.data.inviteSend[tostring(uid)], _ENV = uid, uid
	end
	local inviteSend = self.data.inviteSend[tostring(uid)]
	inviteSend.status = status
	inviteSend.t = t
	inviteSend.queueInfo = queueInfo
end
function escortAssistMgr:delInviteSend(uid)
	if self.data.inviteSend then
		self.data.inviteSend[tostring(uid)] = nil
	end
end
function escortAssistMgr:getInviteRecvMap()
	self:checkInviteRecv()
	return self.data.inviteRecv
end
function escortAssistMgr:delInviteRecvMap()
	self.data.inviteRecv = nil
end
function escortAssistMgr:getInviteRecv(uid)
	if self.data.inviteRecv then
		local invite = self.data.inviteRecv[tostring(uid)]
		if invite and self:isInviteValid(invite.status, invite.t) then
			return invite
		else
			self.data.inviteRecv[tostring(uid)] = nil
		end
	end
end
function escortAssistMgr:addInviteRecv(uid, t)
	self:setInviteRecv(uid, gEscortInviteStatus.WAIT, t)
end
function escortAssistMgr:setInviteRecv(uid, status, t)
	if not self.data.inviteRecv then
		self.data.inviteRecv, _ENV = nil, nil
	end
	_ENV = uid
	uid.status = status
	self.data.inviteRecv[tostring(uid)], uid.t = uid, t
end
function escortAssistMgr:delInviteRecv(uid)
	if self.data.inviteRecv then
		self.data.inviteRecv[tostring(uid)] = nil
	end
end
return escortAssistMgr
