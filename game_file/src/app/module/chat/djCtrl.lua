local GameModule = include("GameModule")
local djCtrl = class("djCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local djRead = include("djRead")
_ENV = "djRead"
;("djRead").UPDATE = "0"
;("djRead").JOIN = "1"
;("djRead").EXIT = "2"
;("djRead").KICK = "3"
;("djRead").DISMISS = "4"
;("djRead").MSG = "5"
;("djRead").MODE = "6"
;("djRead").SPEAK = "7"
;("djRead").INVITE = "8"
;("djRead").APPLY = "9"
;("djRead").MODE_CD = "10"
;("djRead").MSG_CASTLE_LV = "11"
;("djRead").FORBID_TEXT = "12"
local ("djRead").REFUSE_INVITE, ANCHOR_ROOM_OPTYPE = "13", "djRead"
function djCtrl:ctor(properties)
	djCtrl.super.ctor(self, properties)
	self:resetData()
end
function djCtrl:resetData()
	self.attentionList, _UPVALUE0_, self.kidList, _UPVALUE0_, self.chatData, _UPVALUE0_, self.rankSelfInfoList, _UPVALUE0_, self.rankList, _UPVALUE0_, self.curDJInfo, _UPVALUE0_, self.djList, _UPVALUE0_, self.baseData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.isDJ = false
	self.ownDJInfo, _UPVALUE0_, self.isBroadcastDJ = nil, nil, false
	self.isBroadcast = false
	self.isListen = false
	self.curListenUid = nil
	self.topic = nil
	self.screenPoint = 0
	self.uniqueChannel = 0
	self.prizeList, _UPVALUE0_, self.djuniqueChannel = nil, nil, 0
	self.privilegeDebutTime = 0
	self.applyInfo, _UPVALUE0_, self.blacklist, _UPVALUE0_, self.speakList, _UPVALUE0_, self.roomData, _UPVALUE0_, self.freePropTime = nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.beInvite = false
end
function djCtrl:Logout()
	djCtrl.super.Logout(self)
	self.handle_chat_notify = nil
	self:resetData()
end
function djCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_INIT, handler(self, self.getChatDJDataRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_OPEN, handler(self, self.getChatDJOpenRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CLOSE, handler(self, self.getChatDJOpenRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_SEND_TEXT_TO_ANCHOR, handler(self, self.getChatDJSendRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_SEND_GIFT_TO_ANCHOR, handler(self, self.getChatDJSendRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_ATTENTION, handler(self, self.getChatDJAttentionRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CANCEL_ATTENTION, handler(self, self.getChatDJAttentionRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_LISTEN, handler(self, self.getChatDJListenRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_RANK, handler(self, self.getChatDJRankRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_OPEN_TOPIC, handler(self, self.getChatDJOpenTopicRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CLOSE_TOPIC, handler(self, self.getChatDJCloseTopicRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_PRIVILEGE_DEBUT, handler(self, self.getPrivilegeDebutRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_RECEIVE_FREE_PROP, handler(self, self.receiveFreePropRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_EXIT_SPEAK, handler(self, self.exitSpeakRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_KICK_SPEAK, handler(self, self.kickSpeakRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_INVITE_SPEAK, handler(self, self.inviteSpeakRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_AGREE_INVITE, handler(self, self.agreeInviteRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_APPLY_SPEAK, handler(self, self.applySpeakRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_AGREE_APPLY, handler(self, self.agreeApplyRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CHANGE_SPEAK, handler(self, self.changeSpeakRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_SET_USER_BLACK, handler(self, self.setUserBlackRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_USER_BLACK_LIST, handler(self, self.getUserBlackListRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_SET_USERS_BLACK, handler(self, self.setUsersBlackRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_APPLY_LIST, handler(self, self.getApplyListRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_ANCHOR_INFO, handler(self, self.getAnchorInfoRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_SELF_INFO, handler(self, self.getSelfInfoRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_CONTRIBUTE_RECORD, handler(self, self.getContributeRecordRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_SWITCH_TITLE, handler(self, self.switchTitleRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CLEAR_APPLY_LIST, handler(self, self.clearApplyListRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_ROOM_SET, handler(self, self.roomSetRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_AUDIENCE_LIST, handler(self, self.getAudienceListRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_AUDIENCE_INFO, handler(self, self.getAudienceInfoRsp))
	msgCtrl.register(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_IN_IDLE, handler(self, self.inIdleRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.CHAT_ANCHOR, handler(self, self.notifyDJData))
	self:initDJData()
end
function djCtrl:notifyDJData(rep)
	dump(rep.data, "djCtrl:notifyDJData", 10)
	local data = rep.data
	local needUpdate = false
	for i, v in ipairs(data) do
		if v.anchorInfo then
			self:updateDJList(v.anchorInfo)
			needUpdate = true
		end
		if v.kingdomMessage then
		end
		if v.anchorMessage then
		end
		if v.anchorList then
			self.djList = v.anchorList
			needUpdate = true
		end
		if v.isDJ ~= nil then
			self.isDJ = v.isDJ
		end
		if v.isBroadcastDJ ~= nil then
			self.isBroadcastDJ = v.isBroadcastDJ
			needUpdate = true
		end
		if v[ANCHOR_ROOM_OPTYPE.UPDATE] then
		end
		if v[ANCHOR_ROOM_OPTYPE.JOIN] then
		end
		if v[ANCHOR_ROOM_OPTYPE.EXIT] then
		end
		if v[ANCHOR_ROOM_OPTYPE.KICK] and v[ANCHOR_ROOM_OPTYPE.KICK].uid == SoraDGetPlayerID() then
			self.curListenUid = nil
			_ENV = SoraDGetPlayerID()
			SoraDGetPlayerID().msg = "MESSAGE_CHAT_DJ_ROOM_DISMISS"
			SoraDSendMessage((SoraDGetPlayerID()))
			SoraDShowMsgTip(i18n("Anchor_text_199"))
			needUpdate = true
		end
		if v[ANCHOR_ROOM_OPTYPE.DISMISS] then
			_ENV = i18n("Anchor_text_199")
			i18n("Anchor_text_199").msg = "MESSAGE_CHAT_DJ_ROOM_DISMISS"
			SoraDSendMessage(i18n("Anchor_text_199"))
			self.applyInfo, _ENV = SoraDSendMessage, SoraDSendMessage
			self.curListenUid = nil
			needUpdate = true
		end
		if v[ANCHOR_ROOM_OPTYPE.MSG] then
			local msg = v[ANCHOR_ROOM_OPTYPE.MSG].msg
			if msg.isShield then
				if msg.uid == SoraDGetPlayerID() then
					_ENV = SoraDGetPlayerID()
					SoraDGetPlayerID().msg = "MESSAGE_CHAT_DJ_ROOM_MSG"
					SoraDGetPlayerID().info = msg
					SoraDSendMessage((SoraDGetPlayerID()))
				end
			else
				_ENV = SoraDGetPlayerID()
				SoraDGetPlayerID().msg = "MESSAGE_CHAT_DJ_ROOM_MSG"
				SoraDGetPlayerID().info = msg
				SoraDSendMessage((SoraDGetPlayerID()))
			end
		end
		if v[ANCHOR_ROOM_OPTYPE.MODE] then
			self.roomData.msgModeIndex = v[ANCHOR_ROOM_OPTYPE.MODE].msgModeIndex
			if self:isInSpeak() and self.roomData.msgModeIndex == 1 then
				VoiceChatSDKManager:getInstance():end2Speak()
			end
		end
		if v[ANCHOR_ROOM_OPTYPE.SPEAK] then
			local isInSpeak = self:isInSpeak()
			self.speakList = v[ANCHOR_ROOM_OPTYPE.SPEAK].speakList
			local uid = tonumber(v[ANCHOR_ROOM_OPTYPE.SPEAK].speakUid)
			if uid and uid == SoraDGetPlayerID() then
				_ENV = i18n("Anchor_text_199")
				i18n("Anchor_text_199").msg = "MESSAGE_CHAT_DJ_AUDIENCE_BEINVITE"
				SoraDSendMessage(i18n("Anchor_text_199"))
			end
			if isInSpeak and not self:isInSpeak() then
				VoiceChatSDKManager:getInstance():end2Speak()
				_ENV = VoiceChatSDKManager:getInstance()
				VoiceChatSDKManager:getInstance().msg = "MESSAGE_CHAT_DJ_EXIT_SPEAK"
				SoraDSendMessage((VoiceChatSDKManager:getInstance()))
			end
			if self.applyInfo[uid] then
				self.applyInfo[uid] = nil
			end
			needUpdate = true
		end
		if v[ANCHOR_ROOM_OPTYPE.INVITE] then
			self.beInvite = true
			_ENV = tonumber(v[ANCHOR_ROOM_OPTYPE.SPEAK].speakUid)
			tonumber(v[ANCHOR_ROOM_OPTYPE.SPEAK].speakUid).msg = "MESSAGE_CHAT_DJ_AUDIENCE_BEINVITE"
			tonumber(v[ANCHOR_ROOM_OPTYPE.SPEAK].speakUid).isInvite = true
			SoraDSendMessage((tonumber(v[ANCHOR_ROOM_OPTYPE.SPEAK].speakUid)))
		end
		if v[ANCHOR_ROOM_OPTYPE.APPLY] then
			local uInfo = v[ANCHOR_ROOM_OPTYPE.APPLY].uInfo
			self.applyInfo[uInfo.uid] = uInfo
		end
		if v[ANCHOR_ROOM_OPTYPE.MODE_CD] then
			self.roomData.msgCDModeIndex = v[ANCHOR_ROOM_OPTYPE.MODE_CD].msgCDModeIndex
			local speedCfg = djRead.getBlacklistCfg(1, 1)
			local val = speedCfg[self.roomData.msgCDModeIndex]
			_ENV = VoiceChatSDKManager:getInstance()
			_ENV, VoiceChatSDKManager:getInstance().msg = i18n("Anchor_text_199")
			_ENV = i18n("Anchor_text_199")
			if val ~= 0 or not i18n("flames_dunes_text275") then
				_ENV = i18n("Anchor_text_199")
				i18n("Anchor_text_199").sec = val
			end
			i18n("Anchor_text_199").time = i18n("common_text_666", i18n("Anchor_text_199"))
			VoiceChatSDKManager:getInstance().info, i18n("Anchor_text_199").text = i18n("Anchor_text_199")
			SoraDSendMessage((VoiceChatSDKManager:getInstance()))
		end
		if v[ANCHOR_ROOM_OPTYPE.MSG_CASTLE_LV] then
			local msgCastleLvModeIndex = v[ANCHOR_ROOM_OPTYPE.MSG_CASTLE_LV].msgCastleLvModeIndex
			self.roomData.msgCastleLvModeIndex = msgCastleLvModeIndex
			if not self:isDJAnchor() then
				local lvCfg = djRead.getBlacklistCfg(1, 2)
				local val = lvCfg[msgCastleLvModeIndex]
				_ENV = i18n("Anchor_text_199")
				_ENV, i18n("Anchor_text_199").msg = i18n("Anchor_text_99", i18n("Anchor_text_199")), "MESSAGE_CHAT_DJ_ROOM_MSG"
				_ENV = i18n("common_text_666", i18n("Anchor_text_199"))
				i18n("common_text_666", i18n("Anchor_text_199")).Lv = val
				i18n("Anchor_text_199").info, i18n("Anchor_text_99", i18n("Anchor_text_199")).text = i18n("Anchor_text_99", i18n("Anchor_text_199")), i18n("Anchor_text_196", (i18n("common_text_666", i18n("Anchor_text_199"))))
				SoraDSendMessage(i18n("Anchor_text_199"))
			end
		end
		if v[ANCHOR_ROOM_OPTYPE.FORBID_TEXT] then
			local nikeName = v[ANCHOR_ROOM_OPTYPE.FORBID_TEXT].nikeName
			local forbidTime = v[ANCHOR_ROOM_OPTYPE.FORBID_TEXT].forbidTime
			if forbidTime > serviceFunctions.systemTime() then
				_ENV = SoraDSendMessage
				_ENV, SoraDSendMessage.msg = i18n("Anchor_text_199")
				_ENV = "Anchor_text_196"
				;("Anchor_text_196").name = nikeName
				SoraDSendMessage.info, i18n("Anchor_text_199").text = i18n("Anchor_text_199")
				SoraDSendMessage(SoraDSendMessage)
			end
		end
		if v[ANCHOR_ROOM_OPTYPE.REFUSE_INVITE] then
			local uInfo = v[ANCHOR_ROOM_OPTYPE.REFUSE_INVITE].uInfo
			if self:isDJAnchor() then
				_ENV = self
				_ENV, self.msg = SoraDSendMessage, "MESSAGE_CHAT_DJ_ROOM_MSG"
				_ENV = "Anchor_text_98"
				;("Anchor_text_98").name = uInfo.nikeName
				self.info, SoraDSendMessage.text = SoraDSendMessage, i18n("Anchor_text_187", "Anchor_text_98")
				SoraDSendMessage(self)
			end
		end
	end
	if needUpdate then
		self:updateDJInfo()
	end
	_ENV = self
	self.msg = "MESSAGE_CHAT_DJ_INFO_UPDATE"
	SoraDSendMessage(self)
end
function djCtrl:updateDJList(data)
	if next(data) and data.uid then
		for i, v in ipairs(self.djList) do
			if v.uid == data.uid then
				self.djList[i] = data
				break
			end
		end
		if data.uid == self.selfId then
			self.ownDJInfo = data
			self.djuniqueChannel = self.ownDJInfo.uniqueChannel
		else
			self.curDJInfo = data
			self.uniqueChannel = self.curDJInfo.uniqueChannel
		end
	else
		self.ownDJInfo, _ENV = self.curDJInfo.uniqueChannel, self.curDJInfo.uniqueChannel
		self.curDJInfo, _ENV, self.djuniqueChannel = self.curDJInfo.uniqueChannel, self.curDJInfo.uniqueChannel, 0
		self.speakList, _ENV, self.applyInfo, _ENV, self.uniqueChannel = self.curDJInfo.uniqueChannel, self.curDJInfo.uniqueChannel, self.curDJInfo.uniqueChannel, self.curDJInfo.uniqueChannel, 0
		self.beInvite = false
		_ENV = self.selfId
		self.selfId.msg = "MESSAGE_CHAT_DJ_ROOM_DISMISS"
		SoraDSendMessage(self.selfId)
	end
	print("[debug djCtrl:updateDJList] self.djuniqueChannel=", self.djuniqueChannel, data.uniqueChannel)
	print("[debug djCtrl:updateDJList] self.uniqueChannel=", self.uniqueChannel, data.uniqueChannel)
end
function djCtrl:insertData(content)
	if content.anchorList then
		self.djList = content.anchorList
	end
	self.ownDJInfo, _UPVALUE0_, self.curDJInfo, _UPVALUE0_ = content.anchorList, content.anchorList, content.anchorList, content.anchorList
	if content.anchorInfo then
		if content.anchorInfo.uid == self.selfId then
			self.ownDJInfo = content.anchorInfo
		else
			self.curDJInfo = content.anchorInfo
		end
	end
	if content.attentionList then
		self.attentionList = content.attentionList
	end
	if content.isDJ ~= nil then
		self.isDJ = content.isDJ
	end
	if content.roomData then
		self.roomData = content.roomData
	end
	if content.isBroadcastDJ ~= nil then
		self.isBroadcastDJ = content.isBroadcastDJ
	end
	if content.privilegeDebutTime then
		self.privilegeDebutTime = content.privilegeDebutTime
	end
	if content.freePropTime then
		self.freePropTime = content.freePropTime
	end
	self:updateDJInfo()
end
function djCtrl:updateDJInfo()
	local isDJ = self.isDJ or self.isBroadcastDJ
	if isDJ then
		if self.ownDJInfo and next(self.ownDJInfo) then
			self.isBroadcast = self.ownDJInfo.anchorLiving
			self.topic = self.ownDJInfo.topic
			self.djuniqueChannel = self.ownDJInfo.uniqueChannel
		else
			self.isBroadcast = false
			self.topic = nil
		end
	end
	if not (not isDJ or self.isBroadcast) or not isDJ then
		if self.curDJInfo and next(self.curDJInfo) then
			self.isBroadcast = self.curDJInfo.anchorLiving
			self.topic = self.curDJInfo.topic
			self.uniqueChannel = self.curDJInfo.uniqueChannel
		else
			self.isBroadcast = false
			self.topic = nil
		end
		if not self.isBroadcast then
			self.curListenUid = nil
		end
	end
	self:updateListenType()
end
function djCtrl:checkIsDjChannel(channel)
	channel = tostring(channel)
	if self.curDJInfo and self.curDJInfo.uniqueChannel then
		return self.curDJInfo.uniqueChannel == channel
	end
	return false
end
function djCtrl:updateListenType()
	local oldListen = self.isListen
	self.isListen = self.isBroadcast and self.curListenUid and self.curListenUid == self.curDJInfo.uid
	print("self.curListenUid====", self.curListenUid, self.isBroadcast, self.curDJInfo.uid, self.isListen)
	if self.isListen and oldListen ~= self.isListen then
		gChatMgrs:getMgr("chatDataMgr"):cleanDJData()
		_ENV = gChatMgrs:getMgr("chatDataMgr")
		gChatMgrs:getMgr("chatDataMgr").msg = "MESSAGE_CHAT_DJ_SCROLL_RELOAD"
		SoraDSendMessage((gChatMgrs:getMgr("chatDataMgr")))
	end
	self:updateChatRoom()
end
function djCtrl:updateChatRoom()
	local ret = 0
	if (self.isListen == true or self.isBroadcastDJ == true or self:isInSpeak()) and not VoiceChatSDKManager:getInstance().isInDJ then
		ret = 1
	elseif (not (self.isListen or self.isDJ) or self.isDJ and not self.isBroadcastDJ and not self.isListen) and VoiceChatSDKManager:getInstance().isInDJ then
		ret = 2
	end
	if ret == 1 then
		print("djCtrl:self.djuniqueChannel,self.uniqueChannel=====--加入", self.djuniqueChannel, self.uniqueChannel, VoiceChatSDKManager:getInstance().isInDJ)
		if VoiceChatSDKManager:getInstance().vociePermission then
			if VoiceChatSDKManager:getInstance().voiceState == gVoiceState.onLine then
				if self.isBroadcastDJ and self.djuniqueChannel and self.djuniqueChannel ~= 0 then
					VoiceChatSDKManager:getInstance():joinChannel(self.djuniqueChannel, true)
				elseif not self.isBroadcastDJ and self.uniqueChannel and self.uniqueChannel ~= 0 then
					VoiceChatSDKManager:getInstance():joinChannel(self.uniqueChannel, true)
				end
			end
		else
			print("[debug djCtrl:updateChatRoom] 没有权限")
			SoraDShowMsgTip(i18n("chat_text_55"))
			_ENV = i18n("chat_text_55")
			i18n("chat_text_55").msg = "MESSAGE_CHAT_DJ_ROOM_BACK"
			SoraDSendMessage(i18n("chat_text_55"))
		end
	elseif ret == 2 then
		print("djCtrl:self.djuniqueChannel,self.uniqueChannel=====--退出", self.djuniqueChannel, self.uniqueChannel, VoiceChatSDKManager:getInstance().isInDJ)
		if self.uniqueChannel and self.uniqueChannel ~= 0 then
			VoiceChatSDKManager:getInstance():leaveChannel(self.uniqueChannel)
			self.uniqueChannel = 0
		end
		if self.djuniqueChannel and self.djuniqueChannel ~= 0 then
			VoiceChatSDKManager:getInstance():leaveChannel(self.djuniqueChannel)
			self.djuniqueChannel = 0
		end
	end
end
function djCtrl:getChatDJDataRsp(data)
	self.selfId = include("chatFunctions"):getSelfId()
	dump(data, "djCtrl:initClientData", 10)
	if data.err == gErrDef.Err_None then
		self:insertData(data.rspdata.initData)
	end
	_ENV = self
	self.msg = "MESSAGE_CHAT_DJ_INFO_UPDATE"
	SoraDSendMessage(self)
end
function djCtrl:initDJData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_INIT, nil)
end
function djCtrl:sendDJListen(status)
	serverproxy = nil
	;(nil).status = status
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_LISTEN, nil)
end
function djCtrl:getChatDJListenRsp(data)
	dump(data, "djCtrl:getChatDJListenRsp", 10)
	if data.err == gErrDef.Err_None then
		self.curListenUid = data.rspdata and data.rspdata.curListenUid
		if not data.rspdata or not data.rspdata.roomData then
			_ENV = data.rspdata.roomData
		end
		self.roomData = data.rspdata.roomData
		if not self.roomData.speakList then
			_ENV = self.roomData.speakList
		end
		self.speakList = self.roomData.speakList
	end
	self:updateListenType()
	_ENV = self
	self.msg = "MESSAGE_CHAT_DJ_LISTEN_UPDATE"
	SoraDSendMessage(self)
end
function djCtrl:sendDJOpen(param)
	if self.isDJ then
		if self.isBroadcastDJ then
			serverproxy = nil
			serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CLOSE, nil)
		else
			serverproxy = nil
			;(nil).param = param
			serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_OPEN, nil)
		end
	end
end
function djCtrl:getChatDJOpenRsp(data)
	dump(data, "djCtrl:getChatDJOpenRsp", 10)
	if data.err == gErrDef.Err_None then
		self.screenPoint = 0
		if data.subcmd == gCmd.REQ_CHAT_ANCHOR_CLOSE and self.selfId == data.pid then
			self.ownDJInfo, _ENV = self.selfId, self.selfId
			self:updateDJInfo()
			_ENV = self
			self.msg = "MESSAGE_CHAT_DJ_INFO_UPDATE"
			SoraDSendMessage(self)
		else
			self.roomData = data.data.param
			self:updateDJInfo()
			uiManager:show("DjView")
		end
	elseif data.err == gErrDef.Err_CHAT_ANCHOR_IS_NOT_ANCHOR then
		SoraDShowMsgTip(i18n("Anchor_text_18"))
	elseif data.err == gErrDef.Err_CHAT_ANCHOR_ANCHOR_STATUS_ERROR then
	elseif data.err == gErrDef.Err_CMD_OPTING then
	else
		SoraDShowMsgTip(i18n("broadcasting_ui_test_9"))
	end
	SoraDCloseLoading()
end
function djCtrl:sendDJAttention(anchorUid)
	serverproxy = nil
	;(nil).anchorUid = anchorUid
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_ATTENTION, nil)
end
function djCtrl:sendDJAttentionCancel(anchorUid)
	serverproxy = nil
	;(nil).anchorUid = anchorUid
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CANCEL_ATTENTION, nil)
end
function djCtrl:getChatDJAttentionRsp(data)
	if data.err == gErrDef.Err_None then
		self.attentionList = data.rspdata.attentionList
		if data.subcmd == gCmd.REQ_CHAT_ANCHOR_ATTENTION then
			SoraDShowMsgTip(i18n("Anchor_text_40"))
		end
	end
	_ENV = i18n("Anchor_text_40")
	i18n("Anchor_text_40").msg = "MESSAGE_CHAT_DJ_ATTENTION_UPDATE"
	SoraDSendMessage(i18n("Anchor_text_40"))
end
function djCtrl:sendMessage(message, messageType)
	local msg = ""
	local _ENV, msgData
	msgData.chatIndex = message.chatIndex
	msgData.messageType = message.messageType
	if messageType == gChatTypeDef.chat_content_dj_text then
		msgData.text = message.content
		msg = gCmd.REQ_CHAT_ANCHOR_SEND_TEXT_TO_ANCHOR
	elseif messageType == gChatTypeDef.chat_content_dj_gift then
		msgData.costItemID = message.costItemID
		msgData.itemID = message.itemID
		msgData.count = message.count
		msgData.shopItemID = message.shopItemID
		msg = gCmd.REQ_CHAT_ANCHOR_SEND_GIFT_TO_ANCHOR
	end
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, msg, msgData)
	print("发送完毕")
end
function djCtrl:getChatDJSendRsp(data)
	dump(data, "djCtrl:getChatDJSendRsp", 10)
	if data.err == gErrDef.Err_None then
		if data.subcmd == gCmd.REQ_CHAT_ANCHOR_SEND_TEXT_TO_ANCHOR then
		elseif data.subcmd == gCmd.REQ_CHAT_ANCHOR_SEND_GIFT_TO_ANCHOR then
		end
	elseif data.err == gErrDef.Err_CHAT_ANCHOR_SHUTUP then
		SoraDShowMsgTip(i18n("Anchor_text_100"))
	elseif data.err == gErrDef.Err_VOICE_ROOM_TEXT_CD then
		_ENV = i18n("Anchor_text_100")
		i18n("Anchor_text_100").time = data.rspdata.nextTime
		SoraDShowMsgTip(i18n("Anchor_text_101", i18n("Anchor_text_100")))
	elseif data.err == gErrDef.Err_VOICE_ROOM_MSG_CASTLE_LV then
		_ENV = i18n("Anchor_text_101", i18n("Anchor_text_100"))
		i18n("Anchor_text_101", i18n("Anchor_text_100")).lv = data.rspdata.needCastleLv
		SoraDShowMsgTip(i18n("Anchor_text_102", i18n("Anchor_text_101", i18n("Anchor_text_100"))))
	elseif data.err == gErrDef.Err_CHAT_ANCHOR_NO_FOUND_ANCHOR then
		SoraDShowMsgTip(i18n("Anchor_text_197"))
	end
end
function djCtrl:addNewChatMsg(data)
end
function djCtrl:sendChatDJOpenTopic(topic, title)
	print("djCtrl:sendChatDJOpenTopic", topic)
	_ENV = nil
	;(nil).topic = topic
	;(nil).title = title
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_OPEN_TOPIC, nil)
end
function djCtrl:sendChatDJCloseTopic()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CLOSE_TOPIC, nil)
end
function djCtrl:getChatDJOpenTopicRsp(data)
	dump(data, "djCtrl:getChatDJOpenTopicRsp", 10)
	if data.err == gErrDef.Err_None then
		if self.ownDJInfo then
			self.ownDJInfo.topic = data.data.topic
			self.ownDJInfo.topic = data.data.title
		end
		self:updateDJInfo()
		_ENV = self
		self.msg = "MESSAGE_CHAT_DJ_INFO_UPDATE"
		SoraDSendMessage(self)
	end
end
function djCtrl:getChatDJCloseTopicRsp(data)
	dump(data, "djCtrl:getChatDJCloseTopicRsp", 10)
	if data.err == gErrDef.Err_None then
		if self.ownDJInfo then
			self.ownDJInfo.topic = data.data.topic
			self.ownDJInfo.topic = data.data.title
		end
		self:updateDJInfo()
		_ENV = self
		self.msg = "MESSAGE_CHAT_DJ_INFO_UPDATE"
		SoraDSendMessage(self)
	end
end
function djCtrl:initChatDJRank(anchorUid, rankType)
	if self.rankList[anchorUid] and self.rankList[anchorUid][rankType] then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_DJ_RANK_UPDATE"
		SoraDSendMessage(nil)
		return false
	else
		_ENV = nil
		;(nil).anchorUid = anchorUid
		;(nil).rankType = rankType
		serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_RANK, nil)
		return true
	end
end
function djCtrl:cleanRankList()
	self.rankList, _UPVALUE0_ = nil, nil
end
function djCtrl:getChatDJRankRsp(data)
	dump(data, "djCtrl:getChatDJRankRsp", 10)
	if data.err == gErrDef.Err_None then
		local uid = data.data.anchorUid
		if uid ~= nil then
			local rankType = data.data.rankType
			if self.rankList[uid] == nil then
				self.rankList[uid], _ENV = 10, 10
				self.rankSelfInfoList[uid], _ENV = 10, 10
			end
			self.rankList[uid][rankType] = data.rspdata.rankInfo
			self.rankSelfInfoList[uid][rankType] = data.rspdata.selfInfo
		end
		_ENV = self.rankSelfInfoList[uid]
		self.rankSelfInfoList[uid].msg = "MESSAGE_CHAT_DJ_RANK_UPDATE"
		self.rankSelfInfoList[uid].rankInfo = data.rspdata.rankInfo
		self.rankSelfInfoList[uid].selfInfo = data.rspdata.selfInfo
		SoraDSendMessage(self.rankSelfInfoList[uid])
	end
end
function djCtrl:isChatDJChannelOpen()
	local ret = true
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		ret = false
	end
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if lordInfoCtrl:getSourceKid() > 0 or worldMapDefine.isInRadiance() then
		ret = false
	end
	if worldMapDefine.isInWar() or worldMapDefine.isInGardenCity() then
		ret = false
	end
	return ret
end
function djCtrl:getDJName()
	local str = ""
	local curdata = self:getCurDJInfo()
	if curdata and next(curdata) then
		str = curdata.nick_name
	end
	return str
end
function djCtrl:getCurDJInfo()
	if self.isBroadcastDJ then
		local selfId = include("chatFunctions"):getSelfId()
		return self:getDJInfo(selfId)
	else
		return self.curDJInfo
	end
end
function djCtrl:getCurDJLiveBeginTime()
	local curdata = self:getCurDJInfo()
	if curdata and curdata.liveBeginTime then
		return serviceFunctions.systemTime() - curdata.liveBeginTime
	else
		return 0
	end
end
function djCtrl:getChatDJRank()
	return self.rankList
end
function djCtrl:getChatDJRankSelfInfo()
	return self.rankSelfInfoList
end
function djCtrl:getScreenPoint()
	return self.screenPoint
end
function djCtrl:setScreenPoint(screenPoint)
	self.screenPoint = screenPoint
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_DJ_SCREEN_UPDATE"
	SoraDSendMessage(nil)
end
function djCtrl:getDJTimeList()
	local _ENV, ret
	for i, v in ipairs(self.djList) do
		for j = 1, #v.dayshowtime / 2 do
			table.insert(ret, clone(v))
			local index = #ret
			ret[index].liveBTime = v.dayshowtime[j * 2 - 1]
			ret[index].liveETime = v.dayshowtime[j * 2]
		end
	end
	table.sort(ret, function(l, r)
		return l.liveBTime < r.liveBTime
	end)
	return ret
end
function djCtrl:getKidListStr(uid)
	local data = self:getDJInfo(uid)
	local str = ""
	if data.kids then
		for i, v in ipairs(data.kids) do
			str = str .. "#" .. v .. " "
		end
	end
	return str
end
function djCtrl:getDJInfo(uid)
	local _ENV, ret
	if uid == nil then
		return ret
	end
	if self.ownDJInfo and self.ownDJInfo.uid == uid then
		ret = self.ownDJInfo
	elseif self.curDJInfo and self.curDJInfo.uid == uid then
		ret = self.curDJInfo
	else
		for i, v in ipairs(self.djList) do
			if v.uid == uid then
				ret = v
				break
			end
		end
	end
	return ret
end
function djCtrl:isAttentionDJ(uid)
	local ret = false
	if self.attentionList[tostring(uid)] then
		ret = true
	end
	return ret
end
function djCtrl:isBeInvite()
	return self.beInvite
end
function djCtrl:resetBeInvite()
	self.beInvite = false
end
function djCtrl:getPrizeList()
	if self.prizeList == nil or next(self.prizeList) == nil then
		local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
		local data = require("app." .. LocalTblPath .. ".config_server.live_chat_shop")
		_ENV = LocalTblPath
		LocalTblPath.index = 0
		LocalTblPath.itemId = 823801
		self.prizeList[1], LocalTblPath.num = LocalTblPath, 9
		for k, v in pairs(data) do
			table.insert(self.prizeList, v)
		end
		table.sort(self.prizeList, function(l, r)
			if l.point == nil then
				l.point = backpackltCtrl:getResult(l.itemId)
			end
			if r.point == nil then
				r.point = backpackltCtrl:getResult(r.itemId)
			end
			return l.index < r.index
		end)
	end
	return self.prizeList
end
function djCtrl:getGiftPrize(shopItemID)
	local data = require("app." .. LocalTblPath .. ".config_server.live_chat_shop")
	local price = 0
	for k, v in ipairs(data) do
		if v.shopItemID == shopItemID then
			price = v.price
			break
		end
	end
	return price
end
function djCtrl:onInitRsp()
	self.initRspNum = self.initRspNum + 1
	if self.initRspNum >= self.initRspTotalNum and not self.hasInitRspEventSended then
		self.hasInitRspEventSended = true
	end
end
function djCtrl:initShieldDataAndChatStatus(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_INIT_SHIELD_DATA_AND_CHAT_STATUS, nil, ...)
end
function djCtrl:getInitShieldDataAndChatStatusRsp(respone)
	self.shieldData = respone.data.shieldData
	self.chatStatusType = respone.data.chatStatusType
	self.shieldList = respone.data.shieldList
	self:onInitRsp()
end
function djCtrl:initBehaviour()
	local msg = self.chatAuxiliary:initBehaviour()
	serverproxy:SendMsg(msg)
end
function djCtrl:getBehaviourRsp(rep)
	self.behaviourData = rep.data
	self:onInitRsp()
end
function djCtrl:notifyChatStatus(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			self.chatStatusType = msg.chatStatusType
			local notifyMsg = msg.notifyMsg
			if notifyMsg then
				local notifyType = notifyMsg.notifyType
				local notifyData = notifyMsg.notifyData
				if "invited" == notifyType then
					local uid = notifyData.uid
					local roomID = notifyData.roomID
					local nickname = notifyData.nickname
					local allianceAbbr = notifyData.allianceAbbr
					if not self.voiceRoomInviteInfo then
						_ENV = self.voiceRoomInviteInfo
					end
					self.voiceRoomInviteInfo = self.voiceRoomInviteInfo
					self.voiceRoomInviteInfo.inviter = uid
					self.voiceRoomInviteInfo.roomID = roomID
					self.voiceRoomInviteInfo.nickname = nickname
					self.voiceRoomInviteInfo.allianceAbbr = allianceAbbr
					local _ENV, data = self.voiceRoomInviteInfo, self.voiceRoomInviteInfo
					data.msgType = 1
					data.roomId = roomID
					data.alliance = allianceAbbr
					data.inviteUserName = nickname
					data.inviteUserId = uid
					_ENV = nil
					;(nil).msg = "MESSAGE_CHAT_SERVER_SDK_VOICE_INVITATION"
					;(nil).data = data
					SoraDSendMessage(nil)
				elseif "agree" == notifyType then
					local uid = notifyData.uid
					local roomID = notifyData.roomID
					local nickname = notifyData.nickname
					local allianceAbbr = notifyData.allianceAbbr
				elseif "reject" == notifyType then
					local uid = notifyData.uid
					local roomID = notifyData.roomID
					local nickname = notifyData.nickname
					local allianceAbbr = notifyData.allianceAbbr or ""
					_ENV = nil
					;(nil).abbr = allianceAbbr
					;(nil).name = nickname
					SoraDShowMsgTip(i18n("common_text_3981", nil))
				end
			end
		end
	end
end
function djCtrl:initNewlyChatData()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CHAT_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_INIT_NEWLY_CHATDATA, gCmd.REQ_INIT_NEWLY_CHATDATA, gCmd.REQ_INIT_NEWLY_CHATDATA
	local msg
	serverproxy:SendMsg(msg)
end
function djCtrl:setVersion(v)
	self.version = v
end
function djCtrl:getVersion()
	return self.version or gChatVersion.NONE
end
function djCtrl:getNewlyChatDataRsp(content)
	local data = content.data
	local allianceSurpise = data.allianceSurpise
	local kingdomSurpise = data.kingdomSurpise
	if not data.initSetData then
		local _ENV, setData = data.initSetData, data.initSetData
	end
	if not (setData[gChatChannel.ALLIANCE] and setData[gChatChannel.ALLIANCE][gChatSet.TOTAL]) or not setData[gChatChannel.ALLIANCE][gChatSet.TOTAL].list then
		_ENV = setData[gChatChannel.ALLIANCE][gChatSet.TOTAL].list
	end
	self.allianceChatData = setData[gChatChannel.ALLIANCE][gChatSet.TOTAL].list
	if not (setData[gChatChannel.KINGDOM] and setData[gChatChannel.KINGDOM][gChatSet.TOTAL]) or not setData[gChatChannel.KINGDOM][gChatSet.TOTAL].list then
		_ENV = setData[gChatChannel.KINGDOM][gChatSet.TOTAL].list
	end
	self.kingDomChatData = setData[gChatChannel.KINGDOM][gChatSet.TOTAL].list
	local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
	chatRedPacketMgr:setAllianceSurpise(allianceSurpise)
	chatRedPacketMgr:setKingdomSurprise(kingdomSurpise)
	print("allianceSurpise, = ", allianceSurpise, ", kingdomSurpise = ", kingdomSurpise)
	local sendMsg = function(chatChannel, chatSetType)
		if setData[chatChannel] and setData[chatChannel][chatSetType] then
			local data = setData[chatChannel][chatSetType]
			local list = data.list
			if list and 0 < #list then
				table.sort(list, function(l, r)
					return l.date < r.date
				end)
			end
			local more = data.more
			function setData(l, r)
				return l.date < r.date
			end
			;(function(l, r)
				return l.date < r.date
			end).msg = "MESSAGE_CHAT_SERVER_LOAD_SUCCESS"
			;(function(l, r)
				return l.date < r.date
			end).isLogin = true
			;(function(l, r)
				return l.date < r.date
			end).chatChannel = chatChannel
			;(function(l, r)
				return l.date < r.date
			end).data = list
			;(function(l, r)
				return l.date < r.date
			end).chatDataSet = chatSetType
			;(function(l, r)
				return l.date < r.date
			end).requestId = ""
			;(function(l, r)
				return l.date < r.date
			end).direction = gDirection.FORWARD
			;(function(l, r)
				return l.date < r.date
			end).more = more
			SoraDSendMessage(function(l, r)
				return l.date < r.date
			end)
		else
		end
	end
	sendMsg(gChatChannel.KINGDOM, gChatSet.TOTAL)
	sendMsg(gChatChannel.KINGDOM, gChatSet.NOTICE)
	sendMsg(gChatChannel.ALLIANCE, gChatSet.TOTAL)
	sendMsg(gChatChannel.ALLIANCE, gChatSet.NOTICE)
	self:onInitRsp()
end
function djCtrl:getChatDataRsp(content)
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_DATA"
	;(nil).err = content.err
	;(nil).data = content.data
	;(nil).chatTypeUI = gChatTypeUI.kingdom
	SoraDSendMessage(nil, content)
end
function djCtrl:getShieldUserRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data
		self.shieldData = data
		self.shieldList = content.shieldList
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_SHIELD_USER"
		;(nil).err = content.err
		;(nil).data = data
		SoraDSendMessage(nil, content)
	end
end
function djCtrl:getUnShieldUserRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data
		self.shieldData = data
		self.shieldList = content.shieldList
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_UNSHIELD_USER"
		;(nil).err = content.err
		;(nil).data = data
		SoraDSendMessage(nil, content)
	end
end
function djCtrl:reportAllianceChatMsgStatus(msg, status, ...)
	serverproxy = nil
	local (nil).msg, data = msg, nil
	msg.status = status
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_REPORT_ALLIANCE_CHAT_MSG_STATUS, data, ...)
end
function djCtrl:getReportAllianceChatMsgStatusRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CHAT_REPORT_ALLIANCE_CHAT_MSG_STATUS_SUCCESS"
		gErrDef.Err_None.data = rsp.data
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CHAT_REPORT_ALLIANCE_CHAT_MSG_STATUS_FAIL"
		gErrDef.Err_None.err = rsp.err
		gErrDef.Err_None.data = rsp.data
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function djCtrl:getChatSetDataRsp(rsp)
	local rspData = rsp.data
	local list = rspData.list
	local more = rspData.more
	local requireID = rspData.requireID
	local chatSetType = rspData.chatSetType
	local channel = rspData.channel
	local direction = rspData.direction
	if gErrDef.Err_None == rsp.err then
		if list and 0 < #list then
			table.sort(list, function(l, r)
				return l.date < r.date
			end)
		end
		_ENV = list
		list.msg = "MESSAGE_CHAT_SERVER_LOAD_SUCCESS"
		list.chatChannel = channel
		list.data = list
		list.chatDataSet = chatSetType
		list.requestId = requireID
		list.direction = direction
		list.more = more
		SoraDSendMessage(list)
	else
		_ENV = list
		list.msg = "MESSAGE_CHAT_SERVER_LOAD_SUCCESS"
		list.data, _ENV, list.chatChannel = function(l, r)
			return l.date < r.date
		end, function(l, r)
			return l.date < r.date
		end, channel
		list.chatDataSet = chatSetType
		list.requestId = requireID
		list.direction = direction
		list.more = false
		SoraDSendMessage(list)
	end
end
function djCtrl:readChatMsg(chatChannel, msgID)
	print("djCtrl:readChatMsg", chatChannel, msgID)
	_ENV = print
	print.chatChannel = chatChannel
	local print.msgID, data = msgID, print
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_READ_CHAT_MSG, data)
end
function djCtrl:readChatMsgRsp(rsp)
	local data = rsp.data
	if gErrDef.Err_None == rsp.err then
	end
end
function djCtrl:getChatPromptInfo(chatChannel)
	serverproxy = nil
	local (nil).chatChannel, data = chatChannel, nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_PROMPT_INFO, data)
end
function djCtrl:getChatPromptInfoRsp(rsp)
	if gErrDef.Err_None == rsp.err then
		local rspData = rsp.data
		local chatChannel = rspData.chatChannel
		local lastReadMsgID, unreadMsgCount, redPacketFlag
		if gChatChannel.KINGDOM == chatChannel then
			lastReadMsgID = rspData.kLastReadMsgID
			unreadMsgCount = rspData.kUnreadMsgCount
			redPacketFlag = rspData.kRedPacketFlag
		elseif gChatChannel.ALLIANCE == chatChannel then
			lastReadMsgID = rspData.aLastReadMsgID
			unreadMsgCount = rspData.aUnreadMsgCount
			redPacketFlag = rspData.aRedPacketFlag
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_SERVER_UN_READ_BACK"
		;(nil).channel = chatChannel
		;(nil).chatId = lastReadMsgID
		;(nil).num = unreadMsgCount
		;(nil).hasRedPacket = redPacketFlag
		SoraDSendMessage(nil)
	end
end
function djCtrl:share(chatChannel, shareType, shareData)
	serverproxy = nil
	;(nil).chatChannel = chatChannel
	;(nil).shareType = shareType
	local (nil).shareData, data = shareData, nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SHARE_MESSAGE, data)
end
function djCtrl:shareMessageRsp(rsp)
	local err = rsp.err
	local rspData = rsp.data
	if gErrDef.Err_None == err then
		SoraDShowMsgTip(i18n("notice_0103"))
	elseif gErrDef.Err_CLIENT_EXCEPTION == err then
		SoraDShowMsgTip(i18n("common_text_2549"))
	end
end
function djCtrl:getChatSetData(chatChannel, chatSetType, startID, count, direction, requireID)
	serverproxy = nil
	;(nil).channel = chatChannel
	;(nil).chatSetType = chatSetType
	;(nil).startID = startID
	;(nil).count = count
	;(nil).direction = direction
	local (nil).requireID, data = requireID, nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_SET_DATA, data)
end
function djCtrl:getNewlyChatData(parameters)
	return self.allianceChatData, self.kingDomChatData
end
function djCtrl:requestAllianceChatData(number)
	local err = self.chatAuxiliary:validateNumber(number)
	if err == gErrDef.Err_None then
		local msg = self.chatAuxiliary:requestChatDataByType(gChatTypeDef.chat_alliance_type, number)
		serverproxy:SendMsg(msg)
	end
	return err
end
function djCtrl:requestKingDomChatData(number)
	local err = self.chatAuxiliary:validateNumber(number)
	if err == gErrDef.Err_None then
		local msg = self.chatAuxiliary:requestChatDataByType(gChatTypeDef.chat_kingDom_type, number)
		serverproxy:SendMsg(msg)
	end
	return err
end
function djCtrl:shieldUser(uid)
	local msg = self.chatAuxiliary:shieldUserByType(uid)
	serverproxy:SendMsg(msg)
end
function djCtrl:unShieldUser(uid)
	local msg = self.chatAuxiliary:unShieldUserByType(uid)
	serverproxy:SendMsg(msg)
end
function djCtrl:sendServiceMessageByProp(message)
	local msg = self.chatAuxiliary:sendServiceMessage(gChatTypeDef.chat_send_message_prop, message)
	serverproxy:SendMsg(msg)
end
function djCtrl:sendServiceMessageByGold(message)
	local msg = self.chatAuxiliary:sendServiceMessage(gChatTypeDef.chat_send_message_gold, message)
	serverproxy:SendMsg(msg)
end
function djCtrl:getAllianceShield()
	if self.shieldData then
		return self.shieldData
	end
end
function djCtrl:isShield(uid)
	local flag = false
	if self.shieldData and next(self.shieldData) ~= nil and self.shieldData[tostring(uid)] then
		flag = true
	end
	return flag
end
function djCtrl:canChat()
	return self.chatStatusType == gChatStatusType.normal
end
function djCtrl:getShieldList()
	return self.shieldList
end
function djCtrl:getRoomSetData()
	return self.roomData
end
function djCtrl:getSpeakList()
	return self.speakList
end
function djCtrl:isInSpeak()
	local ret = false
	for _, v in ipairs(self.speakList) do
		if v.uid == SoraDGetPlayerID() then
			ret = true
			break
		end
	end
	return ret
end
function djCtrl:isDJAnchor()
	return self.isDJ and self.isBroadcastDJ
end
function djCtrl:getBlackList()
	return self.blacklist
end
_ENV, djCtrl.isHaveApplyInfo = function(self)
	return next(self.applyInfo) and true or false
end, function(self)
	return next(self.applyInfo) and true or false
end
;(function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_content_equip_create] = true
;(function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_content_eliminateGame_share] = true
;(function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_content_starsWishGame_share] = true
;(function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_alliance_sys_message] = true
;(function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_kingDom_sys_message] = true
;(function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_content_system_announcement_with_scroll] = true
;(function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_content_system_king_msg] = true
;(function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_content_system_new_king] = true
local _ENV, (function(self)
	return next(self.applyInfo) and true or false
end)[gChatTypeDef.chat_content_system_control_king_castle], chatContentTypeConfig = gChatTypeDef.chat_content_system_control_king_castle, true, function(self)
	return next(self.applyInfo) and true or false
end
local _ENV, gChatTypeDef.chat_content_system_control_king_castle[gChatTypeDef.chat_content_pyramid_share], notChatContentTypeConfig = gChatTypeDef.chat_content_pyramid_share, true, gChatTypeDef.chat_content_system_control_king_castle
gChatTypeDef.chat_content_pyramid_share[gChatTypeDef.chat_alliance_type] = true
local _ENV, gChatTypeDef.chat_content_pyramid_share[gChatTypeDef.chat_alliance_sys_message], chatSysTypeConfig = gChatTypeDef.chat_alliance_sys_message, true, gChatTypeDef.chat_content_pyramid_share
gChatTypeDef.chat_alliance_sys_message[gChatSysMsgType.boss_rally] = true
local _ENV, gChatTypeDef.chat_alliance_sys_message[gChatSysMsgType.player_rally], noChatTypeInContentConfig = gChatSysMsgType.player_rally, true, gChatTypeDef.chat_alliance_sys_message
local gChatSysMsgType.player_rally[gSystemNoticeKingdomMsgTypeDef.open_escort_buff_kingdom], notKingdomMsgTypeConfig = true, gChatSysMsgType.player_rally
function djCtrl:isNoticeMsg(chatData)
	if chatData and chatData.content then
		if chatData.content.chatSysMsgType and noChatTypeInContentConfig[chatData.content.chatSysMsgType] then
			return false
		end
		if chatData.content.kingdomMsgType and notKingdomMsgTypeConfig[chatData.content.kingdomMsgType] then
			return false
		end
	end
	if notChatContentTypeConfig[chatData.contentType] then
		return false
	end
	if chatContentTypeConfig[chatData.contentType] then
		return true
	end
	if chatData.sysType and chatSysTypeConfig[chatData.sysType] then
		return true
	end
	return false
end
function djCtrl:getVoiceChatRoomInviteInfo()
	return self.voiceRoomInviteInfo
end
function djCtrl:inviteUsersJoinVoiceRoom(roomID, userList)
	serverproxy = nil
	;(nil).roomID = roomID
	;(nil).userList = userList
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_INVITE_USERS_JOIN_VOICE_ROOM, nil)
end
function djCtrl:reqVoiceChatRoomInviteInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_GET_VOICE_ROOM_INVITE_INFO, nil)
end
function djCtrl:agreeInvitation(inviter, roomID)
	serverproxy = nil
	;(nil).inviter = inviter
	;(nil).roomID = roomID
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_AGREE_VOICE_ROOM_INVITATION, nil)
end
function djCtrl:rejectInvitation(inviter, roomID)
	serverproxy = nil
	;(nil).inviter = inviter
	;(nil).roomID = roomID
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_REJECT_VOICE_ROOM_INVITATION, nil)
end
function djCtrl:getVoiceRoomInviteInfoRsp(rsp)
	if gErrDef.Err_None == rsp.err then
		self.voiceRoomInviteInfo = rsp.data.data
	end
end
function djCtrl:agreeVoiceRoomInvitationRsp(rsp)
	if gErrDef.Err_None == rsp.err then
		self.voiceRoomInviteInfo = nil
	end
end
function djCtrl:rejectVoiceRoomInvitationRsp(rsp)
	if gErrDef.Err_None == rsp.err then
		self.voiceRoomInviteInfo = nil
	end
end
function djCtrl:inviteUsersJoinVoiceRoomRsp(rsp)
	if gErrDef.Err_None == rsp.err then
	end
end
function djCtrl:sendPrivilegeDebut()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_PRIVILEGE_DEBUT, nil)
end
function djCtrl:getPrivilegeDebutRsp(data)
	dump(data, "djCtrl:getPrivilegeDebutRsp", 10)
	if data.err == gErrDef.Err_None then
		self.privilegeDebutTime = serviceFunctions.systemTime()
	end
end
function djCtrl:checkAndSendPrivilegeDebut(...)
	if not SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.ANCHOR_ENTER_ROOM) then
		return
	end
	if not SoraDConfigGet("Game:GameOptionsView:privilegeDebut~bool") then
		return
	end
	if self.privilegeDebutTime == 0 or serviceFunctions.systemTime() - self.privilegeDebutTime >= 1800 then
		self:sendPrivilegeDebut()
	end
end
function djCtrl:sendReceiveFreeProp()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_RECEIVE_FREE_PROP, nil)
end
function djCtrl:receiveFreePropRsp(data)
	dump(data, "djCtrl:receiveFreePropRsp", 10)
	if data.err == gErrDef.Err_None then
		_ENV = "djCtrl:receiveFreePropRsp"
		;("djCtrl:receiveFreePropRsp").isArray = true
		SoraDOpenGiftView(data.rspdata, "djCtrl:receiveFreePropRsp")
	end
	self.freePropTime = serviceFunctions.systemTime()
end
function djCtrl:checkReceiveFreeProp(...)
	if not SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.ANCHOR_FREE_ITEM) then
		return
	end
	if self.freePropTime == 0 or not serviceFunctions.isSameDay(serviceFunctions.systemTime(), self.freePropTime) then
		return true
	end
end
function djCtrl:getReceiveFreeProp(...)
	local retVal, retList = SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.ANCHOR_FREE_ITEM)
	local privilegeID = retList[tostring(retVal)]
	local exclusiveVipRead = include("exclusiveVipRead")
	local award = exclusiveVipRead:getAnchorAward(privilegeID)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(award, nil)
end
function djCtrl:reqExitSpeak()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_EXIT_SPEAK, nil)
end
function djCtrl:exitSpeakRsp(data)
	dump(data, "djCtrl:exitSpeakRsp", 10)
	if data.err == gErrDef.Err_None then
	end
end
function djCtrl:reqKickSpeak(toUid)
	serverproxy = nil
	;(nil).toUid = toUid
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_KICK_SPEAK, nil)
end
function djCtrl:kickSpeakRsp(data)
	dump(data, "djCtrl:kickSpeakRsp", 10)
	if data.err == gErrDef.Err_None then
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_ROOM_SPEAK_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function djCtrl:reqInviteSpeak(toUid)
	serverproxy = nil
	;(nil).toUid = toUid
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_INVITE_SPEAK, nil)
end
function djCtrl:inviteSpeakRsp(data)
	dump(data, "djCtrl:inviteSpeakRsp", 10)
	if data.err == gErrDef.Err_None then
	elseif data.err == gErrDef.Err_VOICE_ROOM_ALREADY_INVITE then
		SoraDShowMsgTip(i18n("Anchor_text_188"))
	elseif data.err == gErrDef.Err_VOICE_ROOM_INVITE_LIMIT then
	elseif data.err == gErrDef.Err_VOICE_ROOM_IN_SPEAKLIST then
		SoraDShowMsgTip(i18n("Anchor_text_198"))
	elseif data.err == gErrDef.Err_VOICE_ROOM_MEMBER_NOT_IN_ROOM then
		SoraDShowMsgTip(i18n("Anchor_text_186"))
	end
end
function djCtrl:reqAgreeInvite(isRefuse)
	serverproxy = nil
	;(nil).isRefuse = isRefuse
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_AGREE_INVITE, nil)
end
function djCtrl:agreeInviteRsp(data)
	dump(data, "djCtrl:agreeInviteRsp", 10)
	if data.err == gErrDef.Err_None then
		self.beInvite = false
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_AUDIENCE_BEINVITE"
		SoraDSendMessage(gErrDef.Err_None)
	elseif data.err == gErrDef.Err_VOICE_ROOM_SPEAK_LIMIT then
		SoraDShowMsgTip(i18n("Anchor_text_185"))
	end
	_ENV = i18n("Anchor_text_185")
	i18n("Anchor_text_185").msg = "MESSAGE_CHAT_DJ_ROOM_SPEAK_UPDATE"
	SoraDSendMessage(i18n("Anchor_text_185"))
end
function djCtrl:reqApplySpeak()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_APPLY_SPEAK, nil)
end
function djCtrl:applySpeakRsp(data)
	dump(data, "djCtrl:applySpeakRsp", 10)
	if data.err == gErrDef.Err_None then
	elseif data.err == gErrDef.Err_VOICE_ROOM_ALREADY_APPLY then
		SoraDShowMsgTip(i18n("Anchor_text_195"))
	elseif data.err == gErrDef.Err_VOICE_ROOM_PERMISSION then
		SoraDShowMsgTip(i18n("Anchor_text_106"))
	end
end
function djCtrl:reqAgreeApply(toUid)
	serverproxy = nil
	;(nil).toUid = toUid
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_AGREE_APPLY, nil)
end
function djCtrl:agreeApplyRsp(data)
	dump(data, "djCtrl:agreeApplyRsp", 10)
	if data.err == gErrDef.Err_None then
	elseif data.err == gErrDef.Err_VOICE_ROOM_SPEAK_LIMIT then
		SoraDShowMsgTip(i18n("Anchor_text_185"))
	elseif data.err == gErrDef.Err_VOICE_ROOM_IN_SPEAKLIST then
		SoraDShowMsgTip(i18n("Anchor_text_198"))
	elseif data.err == gErrDef.Err_VOICE_ROOM_MEMBER_NOT_IN_ROOM then
		SoraDShowMsgTip(i18n("Anchor_text_186"))
	end
	_ENV = i18n("Anchor_text_186")
	i18n("Anchor_text_186").msg = "MESSAGE_CHAT_DJ_ROOM_SPEAK_UPDATE"
	i18n("Anchor_text_186").agreeApply = true
	SoraDSendMessage(i18n("Anchor_text_186"))
end
function djCtrl:reqChangeSpeak(toUid, isClose)
	serverproxy = nil
	;(nil).toUid = toUid
	;(nil).isClose = isClose
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CHANGE_SPEAK, nil)
end
function djCtrl:changeSpeakRsp(data)
	dump(data, "djCtrl:changeSpeakRsp", 10)
	if data.err == gErrDef.Err_None then
	end
end
function djCtrl:reqSetUserBlack(toUid, permissionList)
	serverproxy = nil
	;(nil).toUid = toUid
	;(nil).permissionList = permissionList
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_SET_USER_BLACK, nil)
end
function djCtrl:setUserBlackRsp(data)
	dump(data, "djCtrl:setUserBlackRsp", 10)
	if data.err == gErrDef.Err_None then
		for k, v in ipairs(self.blacklist) do
			if v.uid == data.data.toUid then
				table.remove(self.blacklist, k)
			end
		end
	elseif data.err == gErrDef.Err_VOICE_ROOM_MEMBER_NOT_IN_ROOM then
		SoraDShowMsgTip(i18n("Anchor_text_186"))
	end
	_ENV = i18n("Anchor_text_186")
	i18n("Anchor_text_186").msg = "MESSAGE_CHAT_DJ_BLACK_LIST_BACK"
	SoraDSendMessage(i18n("Anchor_text_186"))
end
function djCtrl:reqGetUserBlackList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_USER_BLACK_LIST, nil)
end
function djCtrl:getUserBlackListRsp(data)
	dump(data, "djCtrl:getUserBlackListRsp", 10)
	if data.err == gErrDef.Err_None then
		self.blacklist = data.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_BLACK_LIST_BACK"
	SoraDSendMessage(gErrDef.Err_None)
end
function djCtrl:reqSetUsersBlack(uInfoList)
	serverproxy = nil
	;(nil).uInfoList = uInfoList
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_SET_USERS_BLACK, nil)
end
function djCtrl:setUsersBlackRsp(data)
	dump(data, "djCtrl:setUsersBlackRsp", 10)
	if data.err == gErrDef.Err_None then
		local _ENV, blacklist = data.err, data.err
		local _ENV, removeUid = gErrDef.Err_None, gErrDef.Err_None
		for k, v in ipairs(self.blacklist) do
			for _, info in ipairs(data.data.uInfoList) do
				if v.uid == info.uid then
					removeUid[v.uid] = true
				end
			end
		end
		for k, v in ipairs(self.blacklist) do
			if not removeUid[v.uid] then
				table.insert(blacklist, v)
			end
		end
		self.blacklist = blacklist
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_BLACK_LIST_BACK"
	SoraDSendMessage(gErrDef.Err_None)
end
function djCtrl:reqGetApplyList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_APPLY_LIST, nil)
end
function djCtrl:getApplyListRsp(data)
	dump(data, "djCtrl:getApplyListRsp", 10)
	if data.err == gErrDef.Err_None then
		local _ENV, list = data.err, data.err
		for _, v in ipairs(data.rspdata) do
			list[v.uid] = v
		end
		self.applyInfo = list
	end
	_ENV = ipairs(data.rspdata)
	ipairs(data.rspdata).msg = "MESSAGE_CHAT_DJ_APPLY_LIST_BACK"
	ipairs(data.rspdata).list = data.rspdata
	SoraDSendMessage(ipairs(data.rspdata))
end
function djCtrl:reqGetAnchorInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_ANCHOR_INFO, nil)
end
function djCtrl:getAnchorInfoRsp(data)
	dump(data, "djCtrl:getAnchorInfoRsp", 10)
	_ENV = data
	data.msg = "MESSAGE_CHAT_DJ_INFO_BACK"
	data.info = data.rspdata
	SoraDSendMessage(data)
end
function djCtrl:reqGetselfInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_SELF_INFO, nil)
end
function djCtrl:getSelfInfoRsp(data)
	dump(data, "djCtrl:getSelfInfoRsp", 10)
	_ENV = data
	data.msg = "MESSAGE_CHAT_DJ_INFO_BACK"
	data.info = data.rspdata
	SoraDSendMessage(data)
end
function djCtrl:reqGetContributeRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_CONTRIBUTE_RECORD, nil)
end
function djCtrl:getContributeRecordRsp(data)
	dump(data, "djCtrl:getContributeRecordRsp", 10)
	if data.err == gErrDef.Err_None then
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_HISTORY_GIFT_BACK"
	gErrDef.Err_None.list = data.rspdata
	SoraDSendMessage(gErrDef.Err_None)
end
function djCtrl:reqSwitchTitle(showTitle)
	serverproxy = nil
	;(nil).showTitle = showTitle
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_SWITCH_TITLE, nil)
end
function djCtrl:switchTitleRsp(data)
	dump(data, "djCtrl:switchTitleRsp", 10)
	if data.err == gErrDef.Err_None then
	end
end
function djCtrl:reqClearApplyList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_CLEAR_APPLY_LIST, nil)
end
function djCtrl:clearApplyListRsp(data)
	dump(data, "djCtrl:clearApplyListRsp", 10)
	if data.err == gErrDef.Err_None then
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.list, _ENV, gErrDef.Err_None.msg = "djCtrl:clearApplyListRsp", "djCtrl:clearApplyListRsp", "MESSAGE_CHAT_DJ_APPLY_LIST_BACK"
	SoraDSendMessage(gErrDef.Err_None)
end
function djCtrl:reqRoomSet(param)
	serverproxy = nil
	;(nil).param = param
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_ROOM_SET, nil)
end
function djCtrl:roomSetRsp(data)
	dump(data, "djCtrl:roomSetRsp", 10)
	if data.err == gErrDef.Err_None then
		self.roomData = data.data.param
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_INFO_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	elseif data.err == gErrDef.Err_VOICE_ROOM_CHANGE_MODE_CD then
		_ENV = 10
		;(10).num = data.rspdata.cdTime
		SoraDShowMsgTip(i18n("Anchor_text_194", 10))
	end
end
function djCtrl:reqGetAudienceList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_AUDIENCE_LIST, nil)
end
function djCtrl:getAudienceListRsp(data)
	dump(data, "djCtrl:getAudienceListRsp", 10)
	if data.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_INFO_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_AUDIENCE_LIST"
	gErrDef.Err_None.list = data.rspdata
	SoraDSendMessage(gErrDef.Err_None)
end
function djCtrl:reqGetAudienceInfo(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_GET_AUDIENCE_INFO, nil)
end
function djCtrl:getAudienceInfoRsp(data)
	dump(data, "djCtrl:getAudienceInfoRsp", 10)
	if data.err == gErrDef.Err_None then
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_CHAT_DJ_AUDIENCE_INFO"
	gErrDef.Err_None.data = data.rspdata
	SoraDSendMessage(gErrDef.Err_None)
end
function djCtrl:reqInIdle()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_ANCHOR_MODULE, gCmd.REQ_CHAT_ANCHOR_IN_IDLE, nil)
end
function djCtrl:inIdleRsp(data)
	dump(data, "djCtrl:inIdleRsp", 10)
	if data.err == gErrDef.Err_None then
	end
end
return djCtrl
