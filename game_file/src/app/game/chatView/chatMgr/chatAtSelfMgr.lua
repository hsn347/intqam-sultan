local gametop = gModuleMgr.getObject("gametop")
local chatAtSelfMgr = class("chatAtSelfMgr")
function chatAtSelfMgr:ctor(...)
	self.atSelfUserList, _UPVALUE0_ = nil, nil
end
function chatAtSelfMgr:checkUnreadAtSelfChannel(chatChannel)
	local config = self:getChatChannelConfig()
	if config[chatChannel] then
		return true
	else
		return false
	end
end
function chatAtSelfMgr:getChatChannelConfig(...)
	_ENV = nil
	;(nil)[gChatChannel.ALLIANCE] = true
	local (nil)[gChatChannel.CHATROOM], config = true, nil
	if worldMapDefine.isInNebulaAllStar() then
		config[gChatChannel.TEAM] = true
		config[gChatChannel.CAMP] = true
	elseif worldMapDefine.isInRoaringFlame() then
		config[gChatChannel.TEAM] = true
	end
	return config
end
function chatAtSelfMgr:getSelfUid(...)
	if not self.selfUid then
		self.selfUid = gametop.playertop_:getPlayerID()
	end
	return self.selfUid
end
function chatAtSelfMgr:initAllianceMsg(data)
	dump(data, "==chatAtSelfMgr:initAllianceMsg data==", 10)
	local config = self:getChatChannelConfig()
	for chatChannel, __ in pairs(config) do
		self:initChatChannelMsg(data, chatChannel)
	end
	dump(self.atSelfUserList, "==chatAtSelfMgr:initAllianceMsg self.atSelfUserList==")
end
function chatAtSelfMgr:initChatChannelMsg(data, chatChannel)
	if not data.readMsgID then
		local _ENV, readMsgIDList = data.readMsgID, data.readMsgID
	end
	local readMsgID = readMsgIDList[tostring(chatChannel)]
	if not readMsgID or readMsgID == 0 then
		return
	end
	if not data.initSetData then
		local _ENV, setData = data.initSetData, data.initSetData
	end
	if not setData[tostring(chatChannel)] then
		return
	end
	local chatSetType = gChatSet.TOTAL
	if not setData[tostring(chatChannel)][chatSetType] then
		return
	end
	local data = setData[tostring(chatChannel)][chatSetType]
	if data and type(data) ~= "table" then
		return
	end
	if not data or not data.list then
		local _ENV, list = data.list, data.list
	end
	if list and 0 < #list then
		table.sort(list, function(l, r)
			return l.date < r.date
		end)
		local isBegin = false
		local selfUid = self:getSelfUid()
		local _ENV, atSelfUserList = self, self
		for i, v in ipairs(list) do
			if isBegin and v.content then
				local isAtAll = v.content.isAtAll
				if not v.content.atUserMap then
					local _ENV, atUserMap = v.content.atUserMap, v.content.atUserMap
				end
				if isAtAll and v.from ~= selfUid or atUserMap[tostring(selfUid)] then
					_ENV = nil
					;(nil).msgID = v.msgID
					;(nil).nickName = v.nickName
					table.insert(atSelfUserList, nil)
				end
			end
			if v.msgID == readMsgID then
				isBegin = true
			end
		end
		self.atSelfUserList[chatChannel] = atSelfUserList
	end
end
function chatAtSelfMgr:updateAllianceMsg(data)
	dump(data, "==chatAtSelfMgr:updateAllianceMsg data==", 10)
	local config = self:getChatChannelConfig()
	for chatChannel, __ in pairs(config) do
		self:updateChatChannelMsg(data, chatChannel)
	end
	dump(self.atSelfUserList, "==chatAtSelfMgr:updateAllianceMsg self.atSelfUserList==")
end
function chatAtSelfMgr:updateChatChannelMsg(data, chatChannel)
	if not data.initSetData then
		local _ENV, setData = data.initSetData, data.initSetData
	end
	if not setData[chatChannel] then
		return
	end
	local chatSetType = gChatSet.TOTAL
	if not setData[chatChannel][chatSetType] then
		return
	end
	local dataList = setData[chatChannel][chatSetType]
	local list = dataList
	if list and 0 < #list then
		table.sort(list, function(l, r)
			return l.date < r.date
		end)
		local selfUid = self:getSelfUid()
		if not self.atSelfUserList[chatChannel] then
			local _ENV, atSelfUserList = self.atSelfUserList[chatChannel], self.atSelfUserList[chatChannel]
		end
		for i, v in ipairs(list) do
			if v.content then
				local isAtAll = v.content.isAtAll
				if not v.content.atUserMap then
					local _ENV, atUserMap = v.content.atUserMap, v.content.atUserMap
				end
				if isAtAll and v.from ~= selfUid or atUserMap[tostring(selfUid)] then
					_ENV = nil
					;(nil).msgID = v.msgID
					;(nil).nickName = v.nickName
					table.insert(atSelfUserList, nil)
				end
			end
		end
		self.atSelfUserList[chatChannel] = atSelfUserList
	end
end
function chatAtSelfMgr:initChatRoomMsg(crid, msgs)
	_ENV = nil
	;(nil).crid = crid
	;(nil).msgs = msgs
	dump(nil, "==chatAtSelfMgr:initChatRoomMsg==", 5)
	if not msgs then
		msgs, _ENV = dump, dump
	end
	local chatroomKey = include("chatFunctions"):getChatMailKey(crid, gChatChannel.CHATROOM)
	local chatCoverMgr = gChatMgrs:getMgr("chatCoverMgr")
	local newNum = chatCoverMgr:getNewNumByKey(chatroomKey)
	local selfUid = self:getSelfUid()
	local _ENV, atSelfUserList = self, self
	local numMax = math.min(newNum, #msgs)
	for i = 1, numMax do
		local msg = msgs[i]
		local isAtAll = msg.data.isAtAll
		if not msg.data.atUserMap then
			local _ENV, atUserMap = msg.data.atUserMap, msg.data.atUserMap
		end
		if isAtAll and msg.user.uid ~= selfUid or atUserMap[tostring(selfUid)] then
			_ENV = nil
			;(nil).msgID = msg.msgid
			;(nil).nickName = msg.user.nickName
			table.insert(atSelfUserList, nil)
		end
	end
	self.atSelfUserList[crid] = atSelfUserList
	dump(self.atSelfUserList, "==chatAtSelfMgr self.atSelfUserList==")
end
function chatAtSelfMgr:updateChatRoomMsg(msg)
	dump(msg, "==chatAtSelfMgr:updateChatRoomMsg==", 5)
	local selfUid = self:getSelfUid()
	local crid = msg.chatroom.crid
	if not self.atSelfUserList[crid] then
		local _ENV, atSelfUserList = self.atSelfUserList[crid], self.atSelfUserList[crid]
	end
	local isAtAll = msg.data.isAtAll
	if not msg.data.atUserMap then
		local _ENV, atUserMap = msg.data.atUserMap, msg.data.atUserMap
	end
	if isAtAll and msg.user.uid ~= selfUid or atUserMap[tostring(selfUid)] then
		_ENV = nil
		;(nil).msgID = msg.msgid
		;(nil).nickName = msg.user.nickName
		table.insert(atSelfUserList, nil)
	end
	self.atSelfUserList[crid] = atSelfUserList
	dump(self.atSelfUserList, "==chatAtSelfMgr self.atSelfUserList==")
end
function chatAtSelfMgr:getUnreadAtSelfMsg(chatChannel, crid)
	local list = self:getUnreadAtSelfUserList(chatChannel, crid)
	return #list
end
function chatAtSelfMgr:getUnreadAtSelfUserList(chatChannel, crid, needReset)
	if not self:checkUnreadAtSelfChannel(chatChannel) then
		_ENV = self:checkUnreadAtSelfChannel(chatChannel)
		return (self:checkUnreadAtSelfChannel(chatChannel))
	end
	local _ENV, ret = self:checkUnreadAtSelfChannel(chatChannel), self:checkUnreadAtSelfChannel(chatChannel)
	if chatChannel == gChatChannel.CHATROOM then
		ret, _ENV = self.atSelfUserList[crid], self.atSelfUserList[crid]
		ret = crid and self.atSelfUserList[crid] or self:checkUnreadAtSelfChannel(chatChannel)
	else
		ret, _ENV = self.atSelfUserList[chatChannel], self.atSelfUserList[chatChannel]
		ret = self.atSelfUserList[chatChannel] or self:checkUnreadAtSelfChannel(chatChannel)
	end
	if needReset then
		self:cleanAtSelfUserList(chatChannel, crid)
	end
	return ret
end
function chatAtSelfMgr:cleanAtSelfUserList(chatChannel, crid)
	if chatChannel == gChatChannel.CHATROOM then
		if crid then
			self.atSelfUserList[crid], _ENV = nil, nil
		end
	else
		self.atSelfUserList[chatChannel], _ENV = nil, nil
	end
end
return chatAtSelfMgr
