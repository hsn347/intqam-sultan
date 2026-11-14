local escortIntel = class("escortIntel")
function escortIntel:ctor(channelType)
	self.msgs, _UPVALUE0_, self.channelType = nil, nil, channelType
end
function escortIntel:getChannelType()
	return self.channelType
end
function escortIntel:addNewMsg(msg)
	table.insert(self.msgs, 1, msg)
end
function escortIntel:addHistoryMsgs(msgs)
	if msgs and next(msgs) then
		for i, msg in ipairs(msgs) do
			table.insert(self.msgs, msg)
		end
	end
end
function escortIntel:getLatestMsg()
	if self.msgs and next(self.msgs) then
		return self.msgs[1]
	end
end
function escortIntel:getEarliestMsg()
	if self.msgs and next(self.msgs) then
		return self.msgs[#self.msgs]
	end
end
function escortIntel:getMsg(msgid)
	if self.msgs and next(self.msgs) then
		for i, msg in ipairs(self.msgs) do
			if msgid == msg.msgid then
				return msg
			end
		end
	end
end
function escortIntel:getMsgs(iBegin, nCount)
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
		table.insert(msgs, self.msgs[i])
	end
	return msgs
end
return escortIntel
