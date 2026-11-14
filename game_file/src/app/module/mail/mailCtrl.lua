local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local msgNotice = include("msgNotice")
local mailLogic = include("mailLogic")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailCtrl = class("mailCtrl", gameModule)
local reqPageNum = 20
local reqPageNumOfView = 10
local version = "1"
local _ENV, RSP
function mailCtrl:ctor(properties)
	mailCtrl.super.ctor(self, properties)
end
function mailCtrl:EnterGame()
	mailCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_INIT_MAILDATA, handler(self, RSP.initDataRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_REMOVE_MAIL, handler(self, RSP.removeMailRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_REMOVE_MAIL_LIST, handler(self, RSP.removeMailListRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_REMOVE_MAIL_SET_LIST, handler(self, RSP.removeMailSetsRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_VIEW_MAIL_SET_LIST, handler(self, RSP.viewMailSetRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_VIEW_MAIL_AND_GET_EXTRA, handler(self, RSP.viewMailSetRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_VIEW_MAIL, handler(self, RSP.viewMailRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_VIEW_MAIL_LIST, handler(self, RSP.viewMailRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_LOCK_MAIL, handler(self, RSP.collectMailRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_SHARE_MAIL, handler(self, RSP.shareMailRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_EXTRA_OF_MAIL, handler(self, RSP.getExtraOfMailRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_MORE_LIST, handler(self, RSP.getMoreMailsRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_MAIL_WITH_STATUS, handler(self, RSP.getMailWithStatusRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_MAIL_WITHOUT_STATUS, handler(self, RSP.getMailWithoutStatusRsp))
	msgCtrl.register(gCmd.CMD_CARRIER_PIGEON_MODUL, gCmd.REQ_GET_GIVE_RECORD, handler(self, RSP.getGiveHistoryRsp))
	msgCtrl.register(gCmd.CMD_CARRIER_PIGEON_MODUL, gCmd.REQ_GET_GIVE_RECORD_NEW, handler(self, RSP.getGiveHistoryNewRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_SEND_CHAT_MAIL, handler(self, RSP.sendChatMailRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_SEN_MULTIPLE_CHAT_MAIL, handler(self, RSP.sendMultipleChatMailRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_MORE_SET_COVER, handler(self, RSP.getMoreMailSetCoverRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_MAIL_CHAT_SET_TOP, handler(self, RSP.setChatTopRsp))
	msgCtrl.register(gCmd.CMD_MAIL_MODULE, gCmd.REQ_MAIL_CHAT_CANCEL_TOP, handler(self, RSP.cancelChatTopRsp))
	self:reqInitData()
end
function mailCtrl:resetData()
	self.tblShareMail, mailMgr = nil, nil
	self.lastShareMid = 0
	self.lastShareTime = 0
	mailMgr:clean()
end
function mailCtrl:Logout()
	mailCtrl.super.Logout(self)
	self:resetData()
end
function mailCtrl:reqInitData()
	serverproxy = nil
	;(nil).num = reqPageNum
	;(nil).version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_INIT_MAILDATA, nil)
end
function mailCtrl:sendChatMail(uid, content)
	local version, data
	data.receiver = uid
	data.content = content
	data.version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_SEND_CHAT_MAIL, data)
	return true
end
function mailCtrl:sendMultipleChatMail(uids, content)
	local version, data
	data.receivers = uids
	data.content = content
	data.version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_SEN_MULTIPLE_CHAT_MAIL, data)
	return true
end
function mailCtrl:sendChatMailByName(nickname, content)
	if "string" ~= type(nickname) or not content then
		print("mailCtrl:sendChatMailByName:nickname is not string")
		return false
	end
	if nil == content then
		print("mailCtrl:sendChatMailByName:content is nil")
		return false
	end
	local _ENV, data = false, false
	data.nickname = nickname
	data.content = content
	data.version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_SEND_CHAT_MAIL_BY_NICKNAME, data)
	return true
end
function mailCtrl:removeMail(mailSetType, mid)
	local err = mailMgr:removeMail(mid)
	if gErrDef.Err_None ~= err then
		return err
	end
	mailMgr = mid
	mid.msg = "MESSAGE_GREEN_POINT_UPDATE"
	mid.type = GREEN_POINT_NOTICE_TYPE.MAIL
	SoraDSendMessage(mid)
	local _ENV, mailMgr, data = mid, SoraDSendMessage, SoraDSendMessage
	data.midArray, mid[1] = mid, mid
	data.setType = mailSetType
	data.version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_REMOVE_MAIL, data)
	return gErrDef.Err_None
end
function mailCtrl:removeMailList(mailSetType, key)
	key = key or "key"
	mailMgr:removeMailList(mailSetType, key)
	local mailMgr, data = mailMgr.removeMailList, mailMgr.removeMailList
	data.version = version
	if tolua.type(mailSetType) == "table" then
		data.key = key
		data.setTypes = mailSetType
		serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_REMOVE_MAIL_SET_LIST, data)
	else
		version, data.midArray, mailMgr = serverproxy.Request, serverproxy.Request, serverproxy.Request
		data.keys, serverproxy.Request[1] = serverproxy.Request, key
		data.setType = mailSetType
		serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_REMOVE_MAIL_LIST, data)
	end
	return true
end
function mailCtrl:viewMail(mid)
	if not mid then
		return false
	end
	local mail = mailMgr:queryMail(mid)
	if not mail then
		print("mailCtrl.viewMail: not found mail!")
		return false
	end
	local mailType = mail:getProperty("mailType")
	local mailSetType = mail:getProperty("mailSetType")
	if not mailSetType then
		print("mailCtrl.viewMail: mailSetType is failed! mailSetType = ", mailSetType)
		return false
	end
	print("mailCtrl:viewMail( mid )", mid)
	if gErrDef.Err_None ~= mailMgr:viewMail(mid) then
		return
	end
	mailMgr = mailMgr:viewMail(mid)
	mailMgr:viewMail(mid).msg = "MESSAGE_SERVER_MAIL_VIEW_MAIL_SUCCESS"
	SoraDSendMessage((mailMgr:viewMail(mid)))
	mailMgr = mailMgr:viewMail(mid)
	mailMgr:viewMail(mid).msg = "MESSAGE_GREEN_POINT_UPDATE"
	mailMgr:viewMail(mid).type = GREEN_POINT_NOTICE_TYPE.MAIL
	SoraDSendMessage((mailMgr:viewMail(mid)))
	local mailMgr, data = SoraDSendMessage, SoraDSendMessage
	data.setType = mailSetType
	data.mid = mid
	data.version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_VIEW_MAIL, data)
	return true
end
function mailCtrl:viewMailSet(mailSetType, key)
	print("mailCtrl:viewMailSet", mailSetType, key)
	key = key or "key"
	if not mailSetType then
		print("mailCtrl.viewMailList: mailSetType is failed! mailSetType = ", mailSetType)
		return false
	end
	local err = mailMgr:viewAllMail(mailSetType, key)
	if err ~= gErrDef.Err_None then
		print("err", err)
		return false
	end
	_ENV = "err"
	;("err").msg = "MESSAGE_GREEN_POINT_UPDATE"
	;("err").type = GREEN_POINT_NOTICE_TYPE.MAIL
	SoraDSendMessage("err")
	local _ENV, data = SoraDSendMessage, SoraDSendMessage
	data.version = version
	if tolua.type(mailSetType) ~= "table" then
		mailMgr, data.midArray, _ENV = tolua.type(mailSetType), tolua.type(mailSetType), tolua.type(mailSetType)
		data.keys, tolua.type(mailSetType)[1] = tolua.type(mailSetType), key
		data.setType = mailSetType
		serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_VIEW_MAIL_AND_GET_EXTRA, data)
	else
		data.key = key
		data.setTypes = mailSetType
		serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_VIEW_MAIL_SET_LIST, data)
	end
	return true
end
function mailCtrl:viewMailList(mailSetType, key)
	key = key or "key"
	if not mailSetType then
		print("mailCtrl.viewMailList: mailSetType is failed! mailSetType = ", mailSetType)
		return false
	end
	local _ENV, data = false, false
	data.setType = mailSetType
	data.key = key
	data.version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_VIEW_MAIL_LIST, data)
	return true
end
function mailCtrl:getExtraOfMail(mid)
	local mail = mailMgr:queryMail(mid)
	if not mail then
		print("mailCtrl.getExtraOfMail: not found mail!")
		return false
	end
	if not mail:hasExtra() or mail:isGetExtra() then
		print("mailCtrl.getExtraOfMail: hasExtra, isGetExtra() =", mail:hasExtra(), mail:isGetExtra())
		return false
	end
	local mailType = mail:getProperty("mailType")
	local mailSetType = mail:getProperty("mailSetType")
	if not mailSetType then
		print("mailCtrl.getExtraOfMail: mailSetType is failed! mailSetType = ", mailSetType)
		return false
	end
	local mailMgr, data = false, false
	data.setType = mailSetType
	data.mid = mid
	data.version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_EXTRA_OF_MAIL, data)
	return true
end
function mailCtrl:getMailList(mid, num, mailSetType, key)
	print("mailCtrl:getMailList()", mid, num, mailSetType, key)
	key = key or "key"
	local ret, mailArray = mailMgr:getMailList(mid, num, mailSetType, key)
	local size = mailArray and #mailArray or 0
	if size == num or tolua.type(mailSetType) == "table" then
		print("mailCtrl:getMailList", mailSetType)
		_ENV = "mailCtrl:getMailList"
		;("mailCtrl:getMailList").msg = "MESSAGE_SERVER_MAIL_REQ_MAIL_TYPE_LIST_BACK"
		;("mailCtrl:getMailList").mailSetType = mailSetType
		;("mailCtrl:getMailList").key = key
		;("mailCtrl:getMailList").flag = mid
		;("mailCtrl:getMailList").num = num
		SoraDSendMessage("mailCtrl:getMailList")
		return
	end
	print("mailMgr:hasMoreMail(mid,mailSetType)", mailMgr:hasMoreMail(mid, mailSetType))
	if mailMgr:hasMoreMail(nil, mailSetType, key) then
		_ENV = nil
		;(nil).setType = mailSetType
		;(nil).flag = mid
		;(nil).key = key
		self:reqMoreMail(nil)
	else
		_ENV = self
		self.msg = "MESSAGE_SERVER_MAIL_REQ_MAIL_TYPE_LIST_BACK"
		self.mailSetType = mailSetType
		self.key = key
		self.flag = mid
		self.num = size
		SoraDSendMessage(self)
	end
end
function mailCtrl:reqMoreMail(data)
	data.version = "1"
	data.num = reqPageNum
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_MORE_LIST, data)
end
function mailCtrl:shareMail(mid, channel, receiver, crid)
	if not mid then
		print("EXCEPTION: mailCtrl.shareMail: mid = ", mid)
		return false
	end
	local mail = mailMgr:queryMail(mid)
	if not mail then
		print("EXCEPTION: mailCtrl.shareMail: not found mail ")
		return false
	end
	local mailType = mail:getProperty("mailType")
	if mailType == gMailType.BATTLE_REPORT or mailType == gMailType.SCOUT_REPORT then
		local source = mail:getProperty("source")
		if source == gMailSource.OCCUPY or source == gMailSource.SCOUT_CITY_FAILED or source == gMailSource.SCOUT_TROOP_FAILED or source == gMailSource.BE_SCOUTED_CITY_SUCCESS or source == gMailSource.BE_SCOUTED_CITY_FAILED or source == gMailSource.BE_SCOUTED_TROOP_SUCCESS or source == gMailSource.BE_SCOUTED_TROOP_FAILED then
			print("EXCEPTION: mailCtrl.shareMail: mailType is error!")
		else
			local mailSetType = mail:getProperty("mailSetType")
			local _ENV, data = mail, mail
			data.mid = mid
			data.channel = channel or gChatChannel.ALLIANCE
			data.setType = mailSetType
			data.version = version
			data.receiver = receiver
			data.crid = crid
			serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_SHARE_MAIL, data)
		end
	end
end
function mailCtrl:collectMail(mid)
	if not mid then
		return false
	end
	local mail = mailMgr:queryMail(mid)
	if not mail then
		print("mailCtrl.lockMail: not found mail!")
		return false
	end
	local mailSetType = mail:getProperty("mailSetType")
	if mailSetType == gMailSetType.COLLECT then
		SoraDShowMsgTip(i18n("mail_2_text_15"))
		return false
	end
	local mailMgr, data = false, false
	data.setType = mailSetType
	data.mid = mid
	data.version = version
	serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_LOCK_MAIL, data)
	return true
end
function mailCtrl:getMailDetailWithStatus(mid, needView)
	local mail = mailMgr:queryMail(mid)
	local data = mail and mail:getProperty("data")
	if data and next(data) then
		mailMgr = data
		data.msg = "MESSAGE_SERVER_MAIL_REQ_SINGLE_MAIL_BACK"
		data.mail = mail
		SoraDSendMessage(data)
		if needView then
			mailMgr = data
			data.msg = "MESSAGE_SERVER_MAIL_REQ_SINGLE_MAIL_BACK_REPORT"
			data.mail = mail
			SoraDSendMessage(data)
		end
	else
		local mailMgr, data = SoraDSendMessage, SoraDSendMessage
		data.mid = mid
		data.needView = needView
		data.version = version
		serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_MAIL_WITH_STATUS, data)
	end
end
function mailCtrl:getMailDetailWithoutStatus(mid, senderId)
	local mail = mailMgr:queryMail(mid)
	local data = mail and mail:getProperty("data")
	if data and next(data) then
		mailMgr = data
		data.msg = "MESSAGE_SERVER_MAIL_REQ_BATTLE_REPORT_BACK"
		data.mail = mail
		data.senderId = senderId
		SoraDSendMessage(data)
	else
		local mailMgr, data = SoraDSendMessage, SoraDSendMessage
		data.mid = mid
		data.senderId = senderId
		data.version = version
		serverproxy:Request(gCmd.CMD_MAIL_MODULE, gCmd.REQ_GET_MAIL_WITHOUT_STATUS, data)
	end
end
function mailCtrl:getGiveHistory(data)
	serverproxy:Request(gCmd.CMD_CARRIER_PIGEON_MODUL, gCmd.REQ_GET_GIVE_RECORD, data)
end
function mailCtrl:getGiveHistoryNew(data)
