local chatDataParser = include("chatDataParser")
local chatBaseMgr = include("chatBaseMgr")
local chatCoverMgr = class("chatCoverMgr", chatBaseMgr)
local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
local mailCtrl = SoraDGetCtrl("mailCtrl")
function chatCoverMgr:init()
	self.maxNum = 120
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self.chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
	self:reset()
end
function chatCoverMgr:reset()
	self.setTopList, _UPVALUE0_, self.numInfoRoom, _UPVALUE0_, self.numInfo, _UPVALUE0_, self.setCover, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
	self.totalNum = 0
	self.curRoomNum = 0
end
function chatCoverMgr:clean()
	self:reset()
end
function chatCoverMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatCoverMgr:registerMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_REQ_COVER_LIST_BACK", handler(self, self.sMsgGetCoverBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_REQ_DEL_SUCCESS", handler(self, self.sMsgDeleteCoverBack))
	SoraDAddMessage(self, "CHATROOM_DEL_COVER_SUCCESS", handler(self, self.sMsgDeleteCoverBack))
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_NEW_COVER_MESSAGE", handler(self, self.sMsgNewCoverBack))
end
function chatCoverMgr:reqChatCoverList(index, num)
	print("getChatCoverList-1", index, num, self.totalNum, #self.setCover)
	local leftNum = math.min(self.maxNum, #self.setCover) - (index - 1)
	if num <= leftNum then
		_ENV = #self.setCover
		;(#self.setCover).msg = "MESSAGE_MAIL_UI_GET_COVER_BACK"
		SoraDSendMessage(#self.setCover)
		return true
	elseif self.totalNum > #self.setCover then
		mailCtrl:reqCoverList(nil, self.curRoomNum + 1)
		return true
	else
		_ENV = mailCtrl
		mailCtrl.msg = "MESSAGE_MAIL_UI_GET_COVER_BACK"
		SoraDSendMessage(mailCtrl)
		return false
	end
end
function chatCoverMgr:getChatCoverList(index, num)
	self:sortCoverList()
	local maxIndex = math.min(self.maxNum, index + num - 1)
	maxIndex = math.min(#self.setCover, maxIndex)
	local ret = table.new(maxIndex)
	for i = index, maxIndex do
		ret[i] = self.setCover[i]
	end
	return ret
end
function chatCoverMgr:getNumInfoByKey(key)
	if self.numInfo[key] then
		print("getNumInfoByKey-1", key)
		return self.numInfo[key]
	elseif self.numInfoRoom[key] then
		print("getNumInfoByKey-2", key)
		return self.numInfoRoom[key]
	else
		print("getNumInfoByKey-3", key)
		_ENV = print
		return print
	end
end
function chatCoverMgr:getTotalNewNum()
	local retNum = 0
	for i, v in pairs(self.numInfo) do
		v.newNum = v.newNum or 0
		retNum = v.newNum + retNum
	end
	print("chatCoverMgr:getTotalNewNum", retNum, chatroomCtrl:getAllChatRoomUnReadMsgSum())
	return retNum + chatroomCtrl:getAllChatRoomUnReadMsgSum()
end
function chatCoverMgr:setCoverInfo(numInfo)
	self.totalNum = chatroomCtrl:getChatRoomLatestMsgListSize()
	for key, v in pairs(numInfo) do
		if key ~= "key" then
			self.totalNum = self.totalNum + 1
			self.numInfo[key] = v
			print("setCoverInfo", key, v.newNum)
		end
	end
	self.totalNum = math.min(self.maxNum, self.totalNum)
	print("self.totalNum", self.totalNum)
end
function chatCoverMgr:setTopInfo(list)
