local contactData = class("contactData")
function contactData:ctor()
	self.data, (nil).inviteMap, (nil).recv, _UPVALUE0_, (nil).send, _UPVALUE0_, _UPVALUE0_, (nil).contactMap, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function contactData:setContactMap(contactMap)
	self.data.contactMap = contactMap
end
function contactData:setInviteMap(inviteMap)
	self.data.inviteMap = inviteMap
end
function contactData:addContact(uid, contact)
	self.data.contactMap[tostring(uid)] = contact
end
function contactData:delContact(uid)
	self.data.contactMap[tostring(uid)] = nil
end
function contactData:getContact(uid)
	return self.data.contactMap[tostring(uid)]
end
function contactData:isContact(uid, contactType)
	local contact = self.data.contactMap[tostring(uid)]
	return contact and true or false
end
function contactData:getContactMap(contactType)
	if contactType then
		local _ENV, contactMap
		for uid, contact in pairs(self.data.contactMap) do
			if contactType == contact.type then
				contactMap[uid] = contact
			end
		end
		return contactMap
	else
		return self.data.contactMap
	end
end
function contactData:setSendInviteMap(inviteMap)
	self.data.inviteMap.send = inviteMap
end
function contactData:addSendInvite(uid, invite)
	self.data.inviteMap.send[tostring(uid)] = invite
end
function contactData:delSendInvite(uid)
	self.data.inviteMap.send[tostring(uid)] = nil
end
function contactData:getSendInvite(uid)
	return self.data.inviteMap.send[tostring(uid)]
end
function contactData:getSendInviteMap()
	return self.data.inviteMap.send
end
function contactData:setRecvInviteMap(inviteMap)
	self.data.inviteMap.recv = inviteMap
end
function contactData:addRecvInvite(uid, invite)
	self.data.inviteMap.recv[tostring(uid)] = invite
end
function contactData:delRecvInvite(uid)
	self.data.inviteMap.recv[tostring(uid)] = nil
end
function contactData:getRecvInvite(uid)
	return self.data.inviteMap.recv[tostring(uid)]
end
function contactData:getRecvInviteMap()
	return self.data.inviteMap.recv
end
return contactData
