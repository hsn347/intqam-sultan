local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local escortIntel = include("escortIntel")
local escortIntelCtrl = class("escortIntelCtrl", GameModule)
function escortIntelCtrl:ctor(properties)
	escortIntelCtrl.super.ctor(self, properties)
end
function escortIntelCtrl:EnterGame()
	escortIntelCtrl.super.EnterGame(self)
	self.kingdomIntel = escortIntel.new(gEscortIntelChannel.KINGDOM)
	self.allianceIntel = nil
	msgCtrl.register(gCmd.CMD_ESCORT_INTEL_MODULE, gCmd.REQ_ESCORT_INTEL_GET_KINGDOM_MSG, handler(self, self.onRspGetKingdomMsgs))
	msgCtrl.register(gCmd.CMD_ESCORT_INTEL_MODULE, gCmd.REQ_ESCORT_INTEL_GET_ALLIANCE_MSG, handler(self, self.onRspGetAllianceMsgs))
	self:reqUpdateData()
end
function escortIntelCtrl:Logout()
	escortIntelCtrl.super.Logout(self)
	self.kingdomIntel = nil
	self.allianceIntel = nil
end
function escortIntelCtrl:reqGetKingdomMsgs(iBegin, nCount, ...)
	serverproxy = nil
	;(nil).iBegin = iBegin
	local (nil).nCount, data = nCount, nil
	local earliestMsg = self.kingdomIntel:getEarliestMsg()
	if earliestMsg then
		data.beginMsgId = earliestMsg.msgid - 1
	end
	serverproxy:Request(gCmd.CMD_ESCORT_INTEL_MODULE, gCmd.REQ_ESCORT_INTEL_GET_KINGDOM_MSG, data, ...)
end
function escortIntelCtrl:reqGetAllianceMsgs(iBegin, nCount, ...)
	serverproxy = nil
	;(nil).iBegin = iBegin
	local (nil).nCount, data = nCount, nil
	if self.allianceIntel then
		local earliestMsg = self.allianceIntel:getEarliestMsg()
		if earliestMsg then
			data.beginMsgId = earliestMsg.msgid - 1
		end
	end
	serverproxy:Request(gCmd.CMD_ESCORT_INTEL_MODULE, gCmd.REQ_ESCORT_INTEL_GET_ALLIANCE_MSG, data, ...)
end
function escortIntelCtrl:onRspGetKingdomMsgs(rsp)
	if rsp.err == gErrDef.Err_None then
		self.kingdomIntel:addHistoryMsgs(rsp.data.msgs)
		_ENV = self.kingdomIntel
		self.kingdomIntel.msg = "MESSAGE_SERVER_ESCORT_LOG_GET_MSG_SUCCESS"
		self.kingdomIntel.chatChannel = gChatChannel.ESCORTKINGDOM
		self.kingdomIntel.chatSet = gChatSet.TOTAL
		self.kingdomIntel.iBegin = rsp.data.iBegin
		self.kingdomIntel.nCount = rsp.data.nCount
		SoraDSendMessage(self.kingdomIntel)
	else
		_ENV = self.kingdomIntel
		self.kingdomIntel.msg = "MESSAGE_SERVER_ESCORT_LOG_GET_MSG_SUCCESS"
		self.kingdomIntel.err = rsp.err
		self.kingdomIntel.chatChannel = gChatChannel.ESCORTKINGDOM
		self.kingdomIntel.chatSet = gChatSet.TOTAL
		self.kingdomIntel.iBegin = rsp.data.iBegin
		self.kingdomIntel.nCount = rsp.data.nCount
		SoraDSendMessage(self.kingdomIntel)
	end
end
function escortIntelCtrl:onRspGetAllianceMsgs(rsp)
	if rsp.err == gErrDef.Err_None then
		if not self.allianceIntel then
			self.allianceIntel = escortIntel.new(gEscortIntelChannel.ALLIANCE)
		end
		self.allianceIntel:addHistoryMsgs(rsp.data.msgs)
		_ENV = self.allianceIntel
		self.allianceIntel.msg = "MESSAGE_SERVER_ESCORT_LOG_GET_MSG_SUCCESS"
		self.allianceIntel.chatChannel = gChatChannel.ESCORTALLIANCE
		self.allianceIntel.chatSet = gChatSet.TOTAL
		self.allianceIntel.iBegin = rsp.data.iBegin
		self.allianceIntel.nCount = rsp.data.nCount
		SoraDSendMessage(self.allianceIntel)
	else
		_ENV = self.allianceIntel
		self.allianceIntel.msg = "MESSAGE_SERVER_ESCORT_LOG_GET_MSG_SUCCESS"
		self.allianceIntel.chatChannel = gChatChannel.ESCORTALLIANCE
		self.allianceIntel.chatSet = gChatSet.TOTAL
		self.allianceIntel.err = rsp.err
		self.allianceIntel.iBegin = rsp.data.iBegin
		self.allianceIntel.nCount = rsp.data.nCount
		SoraDSendMessage(self.allianceIntel)
	end
end
function escortIntelCtrl:reqUpdateData()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ESCORT_INTEL, handler(self, self.onNotifyMsg))
end
function escortIntelCtrl:onNotifyMsg(notification)
	print("[INFO] escortIntelCtrl:onNotifyMsg")
	local chatChannel
	for i = 1, #notification.data do
		local msg = notification.data[i]
		if msg.channel == gEscortIntelChannel.KINGDOM then
			self.kingdomIntel:addNewMsg(msg)
			chatChannel = gChatChannel.ESCORTKINGDOM
		elseif msg.channel == gEscortIntelChannel.ALLIANCE then
			if not self.allianceIntel then
				self.allianceIntel = escortIntel.new(gEscortIntelChannel.ALLIANCE)
			end
			self.allianceIntel:addNewMsg(msg)
			chatChannel = gChatChannel.ESCORTALLIANCE
		end
	end
	if #notification.data > 0 then
		_ENV = #notification.data
		;(#notification.data).msg = "MESSAGE_SERVER_ESCORT_LOG_NEW_MSG"
		;(#notification.data).chatChannel = chatChannel
		;(#notification.data).chatSet = gChatSet.TOTAL
		;(#notification.data).data = notification.data
		SoraDSendMessage(#notification.data)
	end
end
function escortIntelCtrl:getKingdomMsgs(iBegin, nCount)
	iBegin = iBegin or 1
	local iEnd = iBegin + nCount - 1
	if iEnd > #self.kingdomIntel.msgs then
		self:reqGetKingdomMsgs(iBegin, nCount)
	else
		_ENV = self
		self.msg = "MESSAGE_SERVER_ESCORT_LOG_GET_MSG_SUCCESS"
		self.chatChannel = gChatChannel.ESCORTKINGDOM
		self.chatSet = gChatSet.TOTAL
		self.iBegin = iBegin
		self.nCount = nCount
		SoraDSendMessage(self)
	end
end
function escortIntelCtrl:getAllianceMsgs(iBegin, nCount)
	iBegin = iBegin or 1
	local iEnd = iBegin + nCount - 1
	if not self.allianceIntel or iEnd > #self.allianceIntel.msgs then
		self:reqGetAllianceMsgs(iBegin, nCount)
	else
		_ENV = self
		self.msg = "MESSAGE_SERVER_ESCORT_LOG_GET_MSG_SUCCESS"
		self.chatChannel = gChatChannel.ESCORTALLIANCE
		self.chatSet = gChatSet.TOTAL
		self.iBegin = iBegin
		self.nCount = nCount
		SoraDSendMessage(self)
	end
end
function escortIntelCtrl:quitAlliance()
	self.allianceIntel = nil
end
return escortIntelCtrl
