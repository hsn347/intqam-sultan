local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local shieldedWordsltCtrl = gModuleMgr.sharedMgr("shieldedWordsltCtrl")
local msgCtrl = include("msgCtrl")
local chatroomMgr = include("chatroomMgr")
local chatroomClass = include("chatroom")
local chatAtSelfMgr = include("chatAtSelfMgr")
local chatroomCtrl = class("chatroomCtrl", GameModule)
_ENV = "chatroomCtrl"
;("chatroomCtrl").max = 20
local ("chatroomCtrl").min, CHATROOM_NAME_LENGTH_RANGE = 1, "chatroomCtrl"
function chatroomCtrl:ctor(properties)
	chatroomCtrl.super.ctor(self, properties)
end
function chatroomCtrl:EnterGame()
	chatroomCtrl.super.EnterGame(self)
	self.chatroomMgr = chatroomMgr.new()
	self.allChatRoomUnReadMsgSum = 0
	self.latestMsgListSize = 0
	self.chatAtSelfMgr = chatAtSelfMgr.new()
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_GET_MSG, handler(self, self.onRspChatRoomGetMsg))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_SEND_MSG, handler(self, self.onRspChatRoomSendMsg))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_CREATE, handler(self, self.onRspChatRoomCreate))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_GET_MEMBERS, handler(self, self.onRspChatRoomGetMembers))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_ADD_MEMBERS, handler(self, self.onRspChatRoomAddMembers))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_DEL_MEMBERS, handler(self, self.onRspChatRoomDelMembers))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_QUIT, handler(self, self.onRspChatRoomQuit))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_MODIFY_NAME, handler(self, self.onRspChatRoomModifyName))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_MSG_BEEN_READ, handler(self, self.onRspChatRoomMsgBeenRead))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_ALL_CHATROOM_MSG_BEEN_READ, handler(self, self.onRspAllChatRoomMsgBeenRead))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_DEL_COVER, handler(self, self.onRspChatRoomDelCover))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_REPORT_CHAT_MSG_STATUS, handler(self, self.onRspChatRoomReportChatMsgStatus))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_ALL_CHATROOM_INFO, handler(self, self.onRspAllChatRoomInfo))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_SET_TOP, handler(self, self.onRspSetChatTop))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_CANCEL_TOP, handler(self, self.onRspCancelChatTop))
	msgCtrl.register(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_DISMISS, handler(self, self.onRspDismissChat))
	self:reqUpdateChatRoomData()
end
function chatroomCtrl:Logout()
	chatroomCtrl.super.Logout(self)
	self.chatroomMgr = nil
	self.allChatRoomUnReadMsgSum = 0
	self.latestMsgListSize = 0
	self.allChatRoomInfo = nil
	self.chatAtSelfMgr = nil
end
function chatroomCtrl:initClientData(data)
	dump(data, "chatroomCtrl:initClientData")
	if not data then
		return
	end
	self.allChatRoomUnReadMsgSum = data.allChatRoomUnReadMsgSum
	self.latestMsgListSize = data.latestMsgListSize
end
function chatroomCtrl:reqChatRoomGetMsg(crid, iBegin, nCount, ...)
	serverproxy = nil
	;(nil).crid = crid
	;(nil).iBegin = iBegin
	local (nil).nCount, data = nCount, nil
	local chatroom = self.chatroomMgr:getChatRoom(crid)
	if chatroom then
		local earliestMsg = chatroom:getEarliestMsg()
		if earliestMsg then
			data.beginMsgId = earliestMsg.msgid - 1
		end
	end
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_GET_MSG, data, ...)
end
function chatroomCtrl:reqChatRoomSendMsg(crid, msgData, ...)
	local chatDataParser = include("chatDataParser")
	chatDataParser.wrapOfficialData(msgData)
	_ENV = chatDataParser.wrapOfficialData
	_ENV, chatDataParser.wrapOfficialData.crid = msgData, crid
	msgData.msgType = gChatRoomMsgType.CHAT
	chatDataParser.wrapOfficialData.msg, msgData.data = msgData, msgData
	local data = chatDataParser.wrapOfficialData
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_SEND_MSG, data, ...)
end
function chatroomCtrl:reqChatRoomCreate(crName, aid, members, msgData, ...)
	serverproxy = nil
	;(nil).crName = crName
	;(nil).aid = aid
	local (nil).members, data = members, nil
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_CREATE, data, ...)
end
function chatroomCtrl:reqChatRoomGetMembers(crid, ...)
	serverproxy = nil
	local (nil).crid, data = crid, nil
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_GET_MEMBERS, data, ...)
end
function chatroomCtrl:reqChatRoomAddMembers(crid, aid, members, ...)
	serverproxy = nil
	;(nil).crid = crid
	;(nil).aid = aid
	local (nil).members, data = members, nil
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_ADD_MEMBERS, data, ...)
end
function chatroomCtrl:reqChatRoomDelMembers(crid, members, ...)
	serverproxy = nil
	;(nil).crid = crid
	local (nil).members, data = members, nil
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_DEL_MEMBERS, data, ...)
end
function chatroomCtrl:reqChatRoomQuit(crid, ...)
	serverproxy = nil
	local (nil).crid, data = crid, nil
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_QUIT, data, ...)
end
function chatroomCtrl:reqChatRoomModifyName(crid, newName, ...)
	serverproxy = nil
	;(nil).crid = crid
	local (nil).newName, data = newName, nil
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_MODIFY_NAME, data, ...)
end
function chatroomCtrl:reqChatRoomMsgBeenRead(crid, unReadCount, ...)
	serverproxy = nil
	local (nil).crid, data = crid, nil
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_MSG_BEEN_READ, data, ...)
	self.allChatRoomUnReadMsgSum = self.allChatRoomUnReadMsgSum - unReadCount
	print("unReadCount", unReadCount)
	serverproxy = "unReadCount"
	;("unReadCount").msg = "MESSAGE_SERVER_MAIL_VIEW_MAIL_SUCCESS"
	;("unReadCount").key = include("chatFunctions"):getChatMailKey(crid, gChatChannel.CHATROOM)
	SoraDSendMessage("unReadCount")
end
function chatroomCtrl:reqAllChatRoomMsgBeenRead(...)
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_ALL_CHATROOM_MSG_BEEN_READ, nil, ...)
	self.allChatRoomUnReadMsgSum = 0
end
function chatroomCtrl:reqChatRoomDelCover(msgs, ...)
	local _ENV, cridList
	local unReadCountTotal = 0
	for i = 1, #msgs do
		table.insert(cridList, msgs[i].chatroom.crid)
		unReadCountTotal = unReadCountTotal + msgs[i].chatroom.unReadCount
	end
	_ENV = (for index)
	local (1).cridList, data = cridList, 1
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_DEL_COVER, data, ...)
	self.allChatRoomUnReadMsgSum = self.allChatRoomUnReadMsgSum - unReadCountTotal
end
function chatroomCtrl:reqChatRoomReportChatMsgStatus(crid, msg, status, ...)
	serverproxy = nil
	;(nil).crid = crid
	local (nil).msg, data = msg, nil
	msg.status = status
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_REPORT_CHAT_MSG_STATUS, data, ...)
end
function chatroomCtrl:reqChatRoomAllInfo(num)
	serverproxy = nil
	local (nil).num, data = num, nil
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_ALL_CHATROOM_INFO, data)
end
function chatroomCtrl:reqSetChatTop(data)
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_SET_TOP, data)
end
function chatroomCtrl:reqCancelChatTop(data)
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_CANCEL_TOP, data)
end
function chatroomCtrl:reqDismissChat(data)
	serverproxy:Request(gCmd.CMD_CHATROOM_MODULE, gCmd.REQ_CHATROOM_DISMISS, data)
end
function chatroomCtrl:onRspChatRoomGetMsg(rsp)
