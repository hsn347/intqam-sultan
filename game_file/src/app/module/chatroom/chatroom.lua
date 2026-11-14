local chatroom = class("chatroom")
function chatroom:ctor()
	self.crid = 0
	self.crName = ""
	self.msgs, _UPVALUE0_, self.members, _UPVALUE0_, self.ownerUid = nil, nil, nil, nil, 0
	self.state = 0
end
function chatroom:addNewMsg(msg)
	table.insert(self.msgs, 1, msg)
end
function chatroom:addHistoryMsgs(msgs)
	if msgs and next(msgs) then
		for i = 1, #msgs do
			table.insert(self.msgs, msgs[i])
		end
	end
end
function chatroom:getLatestMsg()
	if self.msgs and next(self.msgs) then
		return self.msgs[1]
	end
end
function chatroom:getEarliestMsg()
	if self.msgs and next(self.msgs) then
		return self.msgs[#self.msgs]
	end
end
function chatroom:getMsg(msgid)
	if self.msgs and next(self.msgs) then
		for i = 1, #self.msgs do
			if msgid == self.msgs[i].msgid then
				return self.msgs[i]
			end
		end
	end
end
function chatroom:getMsgs(iBegin, nCount)
	if not self.msgs or not next(self.msgs) then
		return
	end
	local iTotal = #self.msgs
	iBegin = iBegin or 1
	if iTotal < iBegin or nCount < 1 then
		return
	end
	local iEnd = iBegin + nCount - 1
	if iTotal < iEnd then
		iEnd = iTotal
	end
	local _ENV, msgs
	for i = iBegin, iEnd do
		if not self.msgs[i].chatroom then
			_ENV = nil
			;(nil).crid = self.crid
			;(nil).crName = self.crName
			;(nil).ownerUid = self.ownerUid
			self.msgs[i].chatroom, (nil).state = nil, self.state
		end
		table.insert(msgs, self.msgs[i])
	end
	return msgs
end
function chatroom:setMembers(members)
	if members and next(members) then
		self.members = members
	end
end
function chatroom:addMember(newMember)
	local member, idx = self:getMember(newMember.uid)
	if not member then
		table.insert(self.members, newMember)
	end
end
function chatroom:addMembers(members)
	if members and next(members) then
		for i = 1, #members do
			self:addMember(members[i])
		end
	end
end
function chatroom:delMember(uid)
	local member, idx = self:getMember(uid)
	if member then
		table.remove(self.members, idx)
	end
end
function chatroom:delMembers(members)
	if members and next(members) then
		for i = 1, #members do
			self:delMember(members[i].uid)
		end
	end
end
function chatroom:getMember(uid)
	if uid then
		for i = 1, #self.members do
			if uid == self.members[i].uid then
				return self.members[i], i
			end
		end
	end
end
return chatroom
