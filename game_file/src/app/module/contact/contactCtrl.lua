local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local contactData = include("contactData")
local contactCtrl = class("contactCtrl", GameModule)
function contactCtrl:ctor(properties)
	contactCtrl.super.ctor(self, properties)
end
function contactCtrl:EnterGame()
	contactCtrl.super.EnterGame(self)
	self.dataMgr = contactData.new()
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_DATA, handler(self, self.onRspGetData))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_SEND_FRIEND_INVITE, handler(self, self.onRspSendFriendInvite))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_CANCEL_SEND_FRIEND_INVITE, handler(self, self.onRspCancelSendFriendInvite))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_CANCEL_ALL_SEND_FRIEND_INVITE, handler(self, self.onRspCancelAllSendFriendInvite))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_ACCEPT_FRIEND_INVITE, handler(self, self.onRspAcceptFriendInvite))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_ACCEPT_ALL_FRIEND_INVITE, handler(self, self.onRspAcceptAllFriendInvite))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_REJECT_FRIEND_INVITE, handler(self, self.onRspRejectFriendInvite))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_REJECT_ALL_FRIEND_INVITE, handler(self, self.onRspRejectAllFriendInvite))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_DEL_CONTACT, handler(self, self.onRspDelContact))
	msgCtrl.register(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_REMARKS_CONTACT, handler(self, self.onRspRemarksContact))
	self:reqUpdateData()
end
function contactCtrl:Logout()
	contactCtrl.super.Logout(self)
	self.dataMgr = nil
end
function contactCtrl:initClientData(data)
	dump(data, "contactCtrl:initClientData======", 10)
	if data and next(data) then
		self.dataMgr = self.dataMgr or contactData.new()
		if not data.contactMap then
			_ENV = data.contactMap
		end
		self.dataMgr:setContactMap(data.contactMap)
		if not data.inviteMap then
			_ENV = data.inviteMap
		end
		self.dataMgr:setInviteMap(data.inviteMap)
	end
end
function contactCtrl:reqGetData(reqContacts, reqSendInvites, reqRecvInvites, ...)
	serverproxy = nil
	;(nil).reqContacts = reqContacts
	;(nil).reqSendInvites = reqSendInvites
	;(nil).reqRecvInvites = reqRecvInvites
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_DATA, nil, ...)
end
function contactCtrl:reqSendFriendInvite(uid, text, ...)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).text = text
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_SEND_FRIEND_INVITE, nil, ...)
end
function contactCtrl:reqCancelSendFriendInvite(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_CANCEL_SEND_FRIEND_INVITE, nil, ...)
end
function contactCtrl:reqCancelAllSendFriendInvite(...)
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_CANCEL_ALL_SEND_FRIEND_INVITE, ...)
end
function contactCtrl:reqAcceptFriendInvite(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_ACCEPT_FRIEND_INVITE, nil, ...)
end
function contactCtrl:reqAcceptAllFriendInvite(...)
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_ACCEPT_ALL_FRIEND_INVITE, ...)
end
function contactCtrl:reqRejectFriendInvite(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_REJECT_FRIEND_INVITE, nil, ...)
end
function contactCtrl:reqRejectAllFriendInvite(...)
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_REJECT_ALL_FRIEND_INVITE, ...)
end
function contactCtrl:reqDelContact(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_DEL_CONTACT, nil, ...)
end
function contactCtrl:reqRemarksContact(uid, remarkName)
	print("==reqRemarksContact==", uid, remarkName)
	_ENV = nil
	;(nil).uid = uid
	;(nil).remarkName = remarkName
	serverproxy:Request(gCmd.CMD_CONTACT_MODULE, gCmd.REQ_CONTACT_REMARKS_CONTACT, nil)
end
function contactCtrl:onRspGetData(rsp)
	dump(rsp, "contactCtrl:onRspGetData", 10)
	if rsp.err == gErrDef.Err_None then
		if rsp.data.reqContacts and rsp.rspdata and rsp.rspdata.contactMap then
			self.dataMgr:setContactMap(rsp.rspdata.contactMap)
		end
		if rsp.data.reqSendInvites then
			if rsp.rspdata and rsp.rspdata.inviteMap and rsp.rspdata.inviteMap.send then
				self.dataMgr:setSendInviteMap(rsp.rspdata.inviteMap.send)
			end
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_OPTION_SEARCH_LORD"
			SoraDSendMessage(self.dataMgr)
		end
		if rsp.data.reqRecvInvites then
			if rsp.rspdata and rsp.rspdata.inviteMap and rsp.rspdata.inviteMap.recv then
				self.dataMgr:setRecvInviteMap(rsp.rspdata.inviteMap.recv)
			end
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_INVITELIST_BACK"
			SoraDSendMessage(self.dataMgr)
		end
		_ENV = self.dataMgr
		self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_DATA_BACK"
		SoraDSendMessage(self.dataMgr)
	else
	end
end
function contactCtrl:onRspSendFriendInvite(rsp)
	dump(rsp, "contactCtrl:onRspSendFriendInvite", 10)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("alliance_office_btn_02"))
		SoraDCloseLoading()
	elseif rsp.err == gErrDef.Err_CONTACT_FRIEND_INVITE_SEND_REJECTED_PERIOD then
		SoraDShowMsgTip(i18n("friend_text_22"))
	elseif rsp.err == gErrDef.Err_CONTACT_ACCEPT_FRIEND then
		SoraDShowMsgTip(i18n("friend_text_05"))
	elseif rsp.err == gErrDef.Err_CONTACT_OTHER_FRIEND_NUM_REACH_MAX then
		SoraDShowMsgTip(i18n("friend_text_07"))
	elseif rsp.err == gErrDef.Err_CONTACT_OTHER_INVITE_RECV_NUM_REACH_MAX then
		SoraDShowMsgTip(i18n("friend_text_23"))
	elseif rsp.err == gErrDef.Err_MAIL_SENDER_IN_BLACKLIST then
		SoraDShowMsgTip(i18n("notice_0097"))
	end
	_ENV = i18n("notice_0097")
	i18n("notice_0097").msg = "MESSAGE_SERVER_OPTION_SEARCH_LORD"
	SoraDSendMessage(i18n("notice_0097"))
	_ENV = i18n("notice_0097")
	i18n("notice_0097").msg = "MESSAGE_SERVER_FRIEND_STATUS_UPDATE"
	SoraDSendMessage(i18n("notice_0097"))
end
function contactCtrl:onRspCancelSendFriendInvite(rsp)
	dump(rsp, "contactCtrl:onRspCancelSendFriendInvite", 10)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("friend_text_24"))
	else
	end
end
function contactCtrl:onRspCancelAllSendFriendInvite(rsp)
	dump(rsp, "contactCtrl:onRspCancelAllSendFriendInvite", 10)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("friend_text_24"))
	else
	end
	_ENV = i18n("friend_text_24")
	i18n("friend_text_24").msg = "MESSAGE_SERVER_OPTION_SEARCH_LORD"
	SoraDSendMessage(i18n("friend_text_24"))
end
function contactCtrl:onRspAcceptFriendInvite(rsp)
	dump(rsp, "contactCtrl:onRspAcceptFriendInvite", 10)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("friend_text_31"))
	elseif rsp.err == gErrDef.Err_CONTACT_OTHER_FRIEND_NUM_REACH_MAX then
		SoraDShowMsgTip(i18n("friend_text_07"))
		_ENV = i18n("friend_text_07")
		i18n("friend_text_07").msg = "MESSAGE_SERVER_FRIEND_INVITELIST_UPDATE"
		SoraDSendMessage(i18n("friend_text_07"))
	end
	_ENV = i18n("friend_text_07")
	i18n("friend_text_07").msg = "MESSAGE_SERVER_FRIEND_UPDATE_TIP"
	SoraDSendMessage(i18n("friend_text_07"))
end
function contactCtrl:onRspAcceptAllFriendInvite(rsp)
	dump(rsp, "contactCtrl:onRspAcceptAllFriendInvite", 10)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("friend_text_31"))
	elseif rsp.err == gErrDef.Err_CONTACT_OTHER_FRIEND_NUM_REACH_MAX then
		SoraDShowMsgTip(i18n("friend_text_07"))
		_ENV = i18n("friend_text_07")
		i18n("friend_text_07").msg = "MESSAGE_SERVER_FRIEND_INVITELIST_UPDATE"
		SoraDSendMessage(i18n("friend_text_07"))
	end
	_ENV = i18n("friend_text_07")
	i18n("friend_text_07").msg = "MESSAGE_SERVER_FRIEND_UPDATE_TIP"
	SoraDSendMessage(i18n("friend_text_07"))
	_ENV = i18n("friend_text_07")
	i18n("friend_text_07").msg = "MESSAGE_SERVER_FRIEND_INVITELIST_UPDATE"
	SoraDSendMessage(i18n("friend_text_07"))
end
function contactCtrl:onRspRejectFriendInvite(rsp)
	dump(rsp, "contactCtrl:onRspRejectFriendInvite", 10)
	if rsp.err == gErrDef.Err_None then
	else
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SERVER_FRIEND_UPDATE_TIP"
	SoraDSendMessage(gErrDef.Err_None)
end
function contactCtrl:onRspRejectAllFriendInvite(rsp)
	dump(rsp, "contactCtrl:onRspRejectAllFriendInvite", 10)
	if rsp.err == gErrDef.Err_None then
	else
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SERVER_FRIEND_UPDATE_TIP"
	SoraDSendMessage(gErrDef.Err_None)
end
function contactCtrl:onRspDelContact(rsp)
	dump(rsp, "contactCtrl:onRspDelContact", 10)
	if rsp.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_FRIEND_DELETE"
		SoraDSendMessage(gErrDef.Err_None)
	else
		SoraDShowMsgTip(i18n("friend_text_29"))
		_ENV = i18n("friend_text_29")
		i18n("friend_text_29").msg = "MESSAGE_SERVER_FRIEND_DATA_BACK"
		SoraDSendMessage(i18n("friend_text_29"))
	end
end
function contactCtrl:onRspRemarksContact(rsp)
	dump(rsp, "contactCtrl:onRspRemarksContact", 10)
	if rsp.err == gErrDef.Err_None then
		local contact = self.dataMgr:getContact(rsp.data.uid)
		contact.remarkName = rsp.data.remarkName
		self.dataMgr:addContact(rsp.data.uid, contact)
		_ENV = self.dataMgr
		self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_DATA_BACK"
		SoraDSendMessage(self.dataMgr)
		if contact.remarkName then
			SoraDShowMsgTip(i18n("privilege_text_82"))
		else
			SoraDShowMsgTip(i18n("privilege_text_81"))
		end
	end
end
function contactCtrl:reqUpdateData()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.CONTACT, handler(self, self.onNotifyMsg))
end
function contactCtrl:onNotifyMsg(notification)
	dump(notification.data, "contactCtrl:onNotifyMsg notification", 10)
	for _, msg in ipairs(notification.data) do
		if msg.type == gContactMsgType.ADD_CONTACT then
			self.dataMgr:addContact(msg.data.uid, msg.data.contact)
			_ENV = msg.data.contact
			msg.data.contact.name = msg.data.contact.name
			SoraDShowMsgTip(i18n("friend_text_30", msg.data.contact))
			_ENV = i18n("friend_text_30", msg.data.contact)
			i18n("friend_text_30", msg.data.contact).msg = "MESSAGE_SERVER_FRIEND_DATA_BACK"
			SoraDSendMessage(i18n("friend_text_30", msg.data.contact))
			_ENV = i18n("friend_text_30", msg.data.contact)
			i18n("friend_text_30", msg.data.contact).msg = "MESSAGE_SERVER_FRIEND_INVITELIST_UPDATE"
			SoraDSendMessage(i18n("friend_text_30", msg.data.contact))
			_ENV = i18n("friend_text_30", msg.data.contact)
			i18n("friend_text_30", msg.data.contact).msg = "MESSAGE_SERVER_OPTION_SEARCH_LORD"
			SoraDSendMessage(i18n("friend_text_30", msg.data.contact))
			_ENV = i18n("friend_text_30", msg.data.contact)
			i18n("friend_text_30", msg.data.contact).msg = "MESSAGE_SERVER_FRIEND_UPDATE_TIP"
			SoraDSendMessage(i18n("friend_text_30", msg.data.contact))
			_ENV = i18n("friend_text_30", msg.data.contact)
			i18n("friend_text_30", msg.data.contact).msg = "MESSAGE_SERVER_FRIEND_ADD"
			i18n("friend_text_30", msg.data.contact).uid = msg.data.uid
			SoraDSendMessage(i18n("friend_text_30", msg.data.contact))
		elseif msg.type == gContactMsgType.DEL_CONTACT then
			self.dataMgr:delContact(msg.data.uid)
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_DATA_BACK"
			SoraDSendMessage(self.dataMgr)
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_STATUS_UPDATE"
			SoraDSendMessage(self.dataMgr)
		elseif msg.type == gContactMsgType.ADD_RECV_INVITE then
			self.dataMgr:addRecvInvite(msg.data.uid, msg.data.invite)
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_UPDATE_TIP"
			SoraDSendMessage(self.dataMgr)
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_INVITELIST_BACK"
			SoraDSendMessage(self.dataMgr)
		elseif msg.type == gContactMsgType.DEL_RECV_INVITE then
			self.dataMgr:delRecvInvite(msg.data.uid)
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_UPDATE_TIP"
			SoraDSendMessage(self.dataMgr)
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_INVITELIST_BACK"
			SoraDSendMessage(self.dataMgr)
		elseif msg.type == gContactMsgType.ADD_SEND_INVITE then
			self.dataMgr:addSendInvite(msg.data.uid, msg.data.invite)
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_OPTION_SEARCH_LORD"
			SoraDSendMessage(self.dataMgr)
		elseif msg.type == gContactMsgType.DEL_SEND_INVITE then
			self.dataMgr:delSendInvite(msg.data.uid)
			_ENV = self.dataMgr
			self.dataMgr.msg = "MESSAGE_SERVER_FRIEND_SENDLIST_UPDATE"
			SoraDSendMessage(self.dataMgr)
		end
	end
	dump(self.dataMgr.data, "contactCtrl:onNotifyMsg", 10)
end
function contactCtrl:isFriend(uid)
	return self.dataMgr:isContact(uid, gContactType.FRIEND)
end
function contactCtrl:isOwnFriendMaxLimit()
	local contactMax = self:getContactFriendMax()
	return contactMax <= self:getContactNum()
end
function contactCtrl:isSendInvite(uid)
	return self.dataMgr:getSendInvite(uid)
end
function contactCtrl:getContact(uid)
	return self.dataMgr:getContact(uid)
end
function contactCtrl:getAllianceContactList()
