local chatroomMgr = class("chatroomMgr")
function chatroomMgr:ctor()
	self.crList, _UPVALUE0_ = nil, nil
end
function chatroomMgr:getChatRoomList()
	return self.crList
end
function chatroomMgr:getChatRoom(crid)
	if crid then
		for i = 1, #self.crList do
			if crid == self.crList[i].crid then
				return self.crList[i], i
			end
		end
	end
end
function chatroomMgr:addChatRoom(chatroom)
	if chatroom and not self:getChatRoom(chatroom.crid) then
		table.insert(self.crList, chatroom)
	end
end
function chatroomMgr:delChatRoom(crid)
	local chatroom, idx = self:getChatRoom(crid)
	if chatroom then
		table.remove(self.crList, idx)
	end
end
function chatroomMgr:dump()
	print("-------------chatroomList start------------")
	for k, v in pairs(self.crList) do
		v:dump()
	end
	print("-------------chatroomList end------------")
end
return chatroomMgr
