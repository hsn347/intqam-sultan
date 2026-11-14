local allianceRelation = class("allianceRelation")
function allianceRelation:ctor(data)
	self.data = data
	if not self.data then
		self.data, self.data.inviteMap, _UPVALUE0_, self.data.relationMap, _UPVALUE0_, _UPVALUE0_ = self.data, nil, nil, nil, nil, self.data
	end
	self.allyInviteNum = 0
end
function allianceRelation:addRelation(aid, relation)
	if not self.data.relationMap then
		self.data.relationMap, _ENV = nil, nil
	end
	self.data.relationMap[tostring(aid)] = relation
end
function allianceRelation:delRelation(aid)
	if self.data.relationMap then
		self.data.relationMap[tostring(aid)] = nil
	end
end
function allianceRelation:getRelation(aid)
	if self.data.relationMap then
		return self.data.relationMap[tostring(aid)]
	end
end
function allianceRelation:getRelationType(aid)
	local relation = self:getRelation(aid)
	if relation then
		return relation.type
	end
end
function allianceRelation:getRelationNum(type)
	local n = 0
	if self.data.relationMap then
		for _, relation in pairs(self.data.relationMap) do
			if relation.type and relation.type == type then
				n = n + 1
			end
		end
	end
	return n
end
function allianceRelation:getRelations()
	if self.data.relationMap then
		local _ENV, relationMap = self.data.relationMap, self.data.relationMap
		for aid, relation in pairs(self.data.relationMap) do
			if relation.type then
				relationMap[aid] = relation
			end
		end
		return relationMap
	end
end
function allianceRelation:getAlterCount(aid)
	local n = 0
	if aid then
		local relation = self:getRelation(aid)
		if relation then
			n = relation.alterCount or 0
		end
	elseif self.data.relationMap then
		for _, relation in pairs(self.data.relationMap) do
			n = n + (relation.alterCount or 0)
		end
	end
	return n
end
function allianceRelation:updateTerrScore(aid, score)
	local relation = self:getRelation(aid)
	if relation then
		if not relation.aInfo then
			relation.aInfo, _UPVALUE0_ = relation.aInfo, relation.aInfo
		end
		relation.aInfo.score = score
	end
end
function allianceRelation:addSendInvite(aid, invite)
	if not self.data.inviteMap then
		self.data.inviteMap, _ENV = nil, nil
	end
	if not self.data.inviteMap.send then
		self.data.inviteMap.send, _ENV = nil, nil
	end
	self.data.inviteMap.send[tostring(aid)] = invite
end
function allianceRelation:delSendInvite(aid)
	if aid then
		local invite = self:getSendInvite(aid)
		if not invite then
			return false
		end
		self.data.inviteMap.send[tostring(aid)] = nil
		return true, invite
	else
		self.data.inviteMap.send, _ENV = true, true
		return true
	end
end
function allianceRelation:setSendInviteRejected(aid)
	local invite = self:getSendInvite(aid)
	if not invite then
		return false
	end
	invite.isRejected = true
	invite.t = serviceFunctions.systemTime()
	return true, invite
end
function allianceRelation:getSendInvite(aid)
	if self.data.inviteMap and self.data.inviteMap.send then
		return self.data.inviteMap.send[tostring(aid)]
	end
end
function allianceRelation:getSendInvites()
	if self.data.inviteMap and self.data.inviteMap.send then
		local _ENV, inviteMap = self.data.inviteMap.send, self.data.inviteMap.send
		for aid, invite in pairs(self.data.inviteMap.send) do
			if not invite.isRejected then
				inviteMap[aid] = invite
			end
		end
		return inviteMap
	end
end
function allianceRelation:getSendInviteNum()
	local invites = self:getSendInvites()
	if invites then
		return table.nums(invites)
	end
	return 0
end
function allianceRelation:addRecvInvite(aid, invite)
	if not self.data.inviteMap then
		self.data.inviteMap, _ENV = nil, nil
	end
	if not self.data.inviteMap.recv then
		self.data.inviteMap.recv, _ENV = nil, nil
	end
	self.data.inviteMap.recv[tostring(aid)] = invite
end
function allianceRelation:delRecvInvite(aid)
	if aid then
		local invite = self:getRecvInvite(aid)
		if not invite then
			return false
		end
		self.data.inviteMap.recv[tostring(aid)] = nil
		return true, invite
	else
		self.data.inviteMap.recv, _ENV = true, true
		return true
	end
end
function allianceRelation:getRecvInvite(aid)
	if self.data.inviteMap and self.data.inviteMap.recv then
		return self.data.inviteMap.recv[tostring(aid)]
	end
end
function allianceRelation:getRecvInvites()
	if self.data.inviteMap and self.data.inviteMap.recv then
		return self.data.inviteMap.recv
	end
end
function allianceRelation:getRecvInviteNum()
	local n = 0
	if self.data.inviteMap and self.data.inviteMap.recv then
		n = table.nums(self.data.inviteMap.recv)
	end
	return n
end
return allianceRelation
