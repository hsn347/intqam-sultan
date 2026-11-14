local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
local voiceRoomCtrl = class("voiceRoomCtrl", gamemodulec)
_ENV = "voiceRoomCtrl"
;("voiceRoomCtrl").update = 0
;("voiceRoomCtrl").join = 1
;("voiceRoomCtrl").exit = 2
;("voiceRoomCtrl").kick = 3
local ("voiceRoomCtrl").dismiss, optype = 4, "voiceRoomCtrl"
function voiceRoomCtrl:createRoom(roomName, password)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_CREATE, gCmd.REQ_VOICE_ROOM_CREATE
	gCmd.REQ_VOICE_ROOM_CREATE.roomName = roomName
	;(nil).data, gCmd.REQ_VOICE_ROOM_CREATE.password = gCmd.REQ_VOICE_ROOM_CREATE, password
	local msg
	dump(msg, "voiceRoomCtrl:createRoom", 10)
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:changeRoomName(roomID, roomName)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_MODIFY_NAME, gCmd.REQ_VOICE_ROOM_MODIFY_NAME
	gCmd.REQ_VOICE_ROOM_MODIFY_NAME.roomID = roomID
	;(nil).data, gCmd.REQ_VOICE_ROOM_MODIFY_NAME.roomName = gCmd.REQ_VOICE_ROOM_MODIFY_NAME, roomName
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:changePassword(roomID, password)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_MODIFY_PASSWORD, gCmd.REQ_VOICE_ROOM_MODIFY_PASSWORD
	gCmd.REQ_VOICE_ROOM_MODIFY_PASSWORD.roomID = roomID
	;(nil).data, gCmd.REQ_VOICE_ROOM_MODIFY_PASSWORD.password = gCmd.REQ_VOICE_ROOM_MODIFY_PASSWORD, password
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:dismissRoom(roomID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_DIMISS_ROOM, gCmd.REQ_VOICE_ROOM_DIMISS_ROOM
	;(nil).data, gCmd.REQ_VOICE_ROOM_DIMISS_ROOM.roomID = gCmd.REQ_VOICE_ROOM_DIMISS_ROOM, roomID
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:joinRoom(roomID, password, inviter)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_JOIN_ROOM, gCmd.REQ_VOICE_ROOM_JOIN_ROOM
	gCmd.REQ_VOICE_ROOM_JOIN_ROOM.roomID = roomID
	gCmd.REQ_VOICE_ROOM_JOIN_ROOM.password = password
	;(nil).data, gCmd.REQ_VOICE_ROOM_JOIN_ROOM.inviter = gCmd.REQ_VOICE_ROOM_JOIN_ROOM, inviter
	local msg
	dump(msg, "voiceRoomCtrl:joinRoom")
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:exitRoom(roomID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_EXIT_ROOM, gCmd.REQ_VOICE_ROOM_EXIT_ROOM
	;(nil).data, gCmd.REQ_VOICE_ROOM_EXIT_ROOM.roomID = gCmd.REQ_VOICE_ROOM_EXIT_ROOM, roomID
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:kickUser(roomID, uid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_KICK_ROOM, gCmd.REQ_VOICE_ROOM_KICK_ROOM
	gCmd.REQ_VOICE_ROOM_KICK_ROOM.roomID = roomID
	;(nil).data, gCmd.REQ_VOICE_ROOM_KICK_ROOM.uid = gCmd.REQ_VOICE_ROOM_KICK_ROOM, uid
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:transferOwner(roomID, uid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_DEMISS_ROOM, gCmd.REQ_VOICE_ROOM_DEMISS_ROOM
	gCmd.REQ_VOICE_ROOM_DEMISS_ROOM.roomID = roomID
	;(nil).data, gCmd.REQ_VOICE_ROOM_DEMISS_ROOM.uid = gCmd.REQ_VOICE_ROOM_DEMISS_ROOM, uid
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:shutUser(roomID, uid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_FORBID_SPEAK, gCmd.REQ_VOICE_ROOM_FORBID_SPEAK
	gCmd.REQ_VOICE_ROOM_FORBID_SPEAK.roomID = roomID
	;(nil).data, gCmd.REQ_VOICE_ROOM_FORBID_SPEAK.uid = gCmd.REQ_VOICE_ROOM_FORBID_SPEAK, uid
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:unshutUser(roomID, uid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_DEL_FORBID_SPEAK, gCmd.REQ_VOICE_ROOM_DEL_FORBID_SPEAK
	gCmd.REQ_VOICE_ROOM_DEL_FORBID_SPEAK.roomID = roomID
	;(nil).data, gCmd.REQ_VOICE_ROOM_DEL_FORBID_SPEAK.uid = gCmd.REQ_VOICE_ROOM_DEL_FORBID_SPEAK, uid
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:getRoomList()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_GET_ROOM_LIST, gCmd.REQ_VOICE_ROOM_GET_ROOM_LIST, gCmd.REQ_VOICE_ROOM_GET_ROOM_LIST
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:updateSDKUID(sdkuid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_VOICE_ROOM_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_VOICE_ROOM_UPDATE_SDK_UID, gCmd.REQ_VOICE_ROOM_UPDATE_SDK_UID
	;(nil).data, gCmd.REQ_VOICE_ROOM_UPDATE_SDK_UID.sdkuid = gCmd.REQ_VOICE_ROOM_UPDATE_SDK_UID, sdkuid
	local msg
	serverproxy:SendMsg(msg)
end
function voiceRoomCtrl:createRoomRsp(content)
	dump(content, "voiceRoomCtrl:createRoomRsp", 10)
	if content.err == gErrDef.Err_None then
		self.roomInfo = content.data.retdata.roomData
		local roomId = self.roomInfo.roomID
		_ENV = "voiceRoomCtrl:createRoomRsp"
		;("voiceRoomCtrl:createRoomRsp").msg = "MESSAGE_VOICECHAT_SERVER_ONCREATECHANNELSUCCESS"
		;("voiceRoomCtrl:createRoomRsp").roomId = roomId
		SoraDSendMessage("voiceRoomCtrl:createRoomRsp")
		self:selfJoinTheRoomRecord()
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:changeRoomNameRsp(content)
	dump(content, "voiceRoomCtrl:changeRoomNameRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("chat_text_29"))
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:changePasswordRsp(content)
	dump(content, "voiceRoomCtrl:changePasswordRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("chat_text_30"))
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:dismissRoomRsp(content)
	dump(content, "voiceRoomCtrl:dismissRoomRsp", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_VOICECHAT_SERVER_ONDISMISSSUCCESS"
		SoraDSendMessage(gErrDef.Err_None)
		self.roomRecords, _ENV, self.roomInfo.roomID = self.roomInfo, self.roomInfo, 0
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:joinRoomRsp(content)
	dump(content, "voiceRoomCtrl:joinRoomRsp", 10)
	if content.err == gErrDef.Err_None then
		self.roomInfo = content.data.retdata.roomData
		local roomId = self.roomInfo.roomID
		_ENV = "voiceRoomCtrl:joinRoomRsp"
		;("voiceRoomCtrl:joinRoomRsp").msg = "MESSAGE_VOICECHAT_SERVER_ONJOINCHANNELSUCCESS"
		;("voiceRoomCtrl:joinRoomRsp").roomId = roomId
		SoraDSendMessage("voiceRoomCtrl:joinRoomRsp")
		self:selfJoinTheRoomRecord()
		VoiceChatSDKManager:getInstance():joinChannel(roomId)
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:exitRoomRsp(content)
	dump(content, "voiceRoomCtrl:exitRoomRsp", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_VOICECHAT_SERVER_ONLEAVECHANNEL"
		SoraDSendMessage(gErrDef.Err_None)
		VoiceChatSDKManager:getInstance():leaveChannel()
		self.roomRecords, _ENV, self.roomInfo.roomID = self.roomInfo, self.roomInfo, 0
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:kickUserRsp(content)
	dump(content, "voiceRoomCtrl:kickUserRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("chat_text_34"))
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:transferOwnerRsp(content)
	dump(content, "voiceRoomCtrl:transferOwnerRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("chat_text_35"))
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:shutUserRsp(content)
	dump(content, "voiceRoomCtrl:shutUserRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("chat_text_36"))
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:unshutUserRsp(content)
	dump(content, "voiceRoomCtrl:unshutUserRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("chat_text_37"))
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:getRoomListRsp(content)
	dump(content, "voiceRoomCtrl:getRoomListRsp", 10)
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		_ENV = "voiceRoomCtrl:getRoomListRsp"
		;("voiceRoomCtrl:getRoomListRsp").msg = "MESSAGE_VOICECHAT_SERVER_ROOMLISTCALLBACK"
		;("voiceRoomCtrl:getRoomListRsp").retdata = retdata
		SoraDSendMessage("voiceRoomCtrl:getRoomListRsp")
		if self.isUnReadNum == nil then
			self.isUnReadNum = retdata and #retdata or 0
			_ENV = "voiceRoomCtrl:getRoomListRsp"
			;("voiceRoomCtrl:getRoomListRsp").msg = "MESSAGE_VOICECHAT_SERVER_UPDATE_TIPS"
			SoraDSendMessage("voiceRoomCtrl:getRoomListRsp")
		end
	else
		self:commonErrMsgTip(content.err)
		_ENV = self
		self.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		SoraDSendMessage(self)
	end
end
function voiceRoomCtrl:updateSDKUIDRsp(content)
	dump(content, "voiceRoomCtrl:updateSDKUIDRsp", 10)
	if content.err == gErrDef.Err_None then
	else
		self:commonErrMsgTip(content.err)
	end
end
function voiceRoomCtrl:commonErrMsgTip(errid)
	if gErrDef.Err_VOICE_ROOM_MEMBER_IN_ROOM == errid then
		SoraDShowMsgTip(i18n("chat_text_38"))
	elseif gErrDef.Err_VOICE_ROOM_CREATETIME_ERROR == errid then
		SoraDShowMsgTip(i18n("chat_text_39"))
	elseif gErrDef.Err_VOICE_ROOM_NOT_FIND_ROOM == errid then
		SoraDShowMsgTip(i18n("chat_text_40"))
	elseif gErrDef.Err_VOICE_ROOM_BE_KICK_TARGET_ROOM_TIME_LESS == errid then
		SoraDShowMsgTip(i18n("chat_text_41"))
	elseif gErrDef.Err_VOICE_ROOM_MEMBER_LIMIT == errid then
		SoraDShowMsgTip(i18n("chat_text_42"))
	elseif gErrDef.Err_VOICE_ROOM_PASSWORD_NOT_MATCH == errid then
		SoraDShowMsgTip(i18n("chat_text_43"))
	elseif gErrDef.Err_VOICE_ROOM_ROOM_NAME_LEN_ERROR == errid then
		SoraDShowMsgTip(i18n("chat_text_44"))
	elseif gErrDef.Err_VOICE_ROOM_ROOM_NAME_ILLEGAL == errid then
		SoraDShowMsgTip(i18n("chat_text_45"))
	elseif gErrDef.Err_VOICE_ROOM_NOT_LEADER == errid then
		SoraDShowMsgTip(i18n("chat_text_46"))
	elseif gErrDef.Err_VOICE_ROOM_PASSWORD_ILLEGAL == errid then
		SoraDShowMsgTip(i18n("chat_text_47"))
	elseif gErrDef.Err_VOICE_ROOM_MEMBER_NOT_IN_ROOM == errid then
		SoraDShowMsgTip(i18n("chat_text_48"))
	elseif gErrDef.Err_VOICE_ROOM_JOIN_AID_NOT_MATCH == errid then
		SoraDShowMsgTip(i18n("chat_text_49"))
	elseif gErrDef.Err_VOICE_ROOM_INVITE_INFO_ERROR == errid then
		SoraDShowMsgTip(i18n("chat_text_50"))
	elseif gErrDef.Err_ALLIANCE_CPLAYER_NOT_IN_ALLIANCE then
		SoraDShowMsgTip(i18n("common_text_826"))
	else
		SoraDShowMsgTip(string.format("unexpected error:%d", errid))
	end
end
function voiceRoomCtrl:selfJoinTheRoomRecord(...)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local lordInfo = lordInfoCtrl:getBaseInfo()
	local nickName = lordInfo.nickName
	_ENV = nil
	;(nil).name = nickName or "null"
	;(nil).time = serviceFunctions.systemTime()
	;(nil).method = "join"
	table.insert(self.roomRecords, nil)
end
function voiceRoomCtrl.checkInputPwd(pwd)
	local vailCount = 0
	for i = 1, #pwd do
		if tonumber(string.sub(pwd, i, i)) then
			vailCount = vailCount + 1
		end
	end
	return 4 <= vailCount
end
function voiceRoomCtrl.checkInputRoomName(returnName)
	local err = gErrDef.Err_None
	local namkVailidCheck = function(nickName)
		local __err
		if nickName then
			if string.utf8len(nickName) > MAX_NICKNAME_LEN then
				__err = gErrDef.Err_NICKNAME
			elseif string.sub(nickName, 1, 1) == "(" then
				__err = gErrDef.Err_NICKNAME_BRACKET
			elseif string.match(nickName, "$SoarDragon&") then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			elseif string.match(nickName, "[%%%*%^%$%[%]%*%+%-%?#&]+") then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			elseif string.match(nickName, "\n") then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			elseif string.match(nickName, "\r") then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			else
				__err = gErrDef.Err_None
			end
		else
			__err = gErrDef.Err_NICKNAME
		end
		return __err
	end
	local err = namkVailidCheck(returnName)
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameShieldWord(returnName) then
		err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
	end
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(returnName) then
		err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
	end
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedEmoji(returnName) then
		err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
	end
	return err
end
function voiceRoomCtrl:judgeIsMaster(_uid)
	local ret = false
	if self.roomInfo and next(self.roomInfo) then
		local leaderUID = self.roomInfo.leader
		if _uid then
			ret = tostring(leaderUID) == tostring(_uid)
		else
			ret = tostring(leaderUID) == tostring(gametop.playertop_:getPlayerID())
		end
	end
	return ret
end
function voiceRoomCtrl:getRoomRecordsInfo(...)
	return self.roomRecords
end
function voiceRoomCtrl.doRecordsMsg(info)
	local msg = ""
	if "join" == info.method then
		_ENV = nil
		;(nil).name = info.name
		msg = i18n("chat_text_20", nil)
	elseif "exit" == info.method then
		_ENV = nil
		;(nil).name = info.name
		msg = i18n("chat_text_21", nil)
	elseif "kick" == info.method then
		_ENV = nil
		;(nil).name = info.name
		msg = i18n("chat_text_22", nil)
	elseif "master" == info.method then
		_ENV = nil
		;(nil).name = info.name
		msg = i18n("chat_text_23", nil)
	end
	return msg
end
function voiceRoomCtrl:ctor(properties)
	voiceRoomCtrl.super.ctor(self, properties)
	self:resetData()
end
function voiceRoomCtrl:resetData()
	self.roomRecords, _UPVALUE0_, self.roomInfo, _UPVALUE0_ = nil, nil, nil, nil
	self.shareInfo, _UPVALUE0_, self.handle_notify = nil, nil, nil
end
function voiceRoomCtrl:EnterGame()
	voiceRoomCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_CREATE, handler(self, self.createRoomRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_MODIFY_NAME, handler(self, self.changeRoomNameRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_MODIFY_PASSWORD, handler(self, self.changePasswordRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_DIMISS_ROOM, handler(self, self.dismissRoomRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_JOIN_ROOM, handler(self, self.joinRoomRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_EXIT_ROOM, handler(self, self.exitRoomRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_KICK_ROOM, handler(self, self.kickUserRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_DEMISS_ROOM, handler(self, self.transferOwnerRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_FORBID_SPEAK, handler(self, self.shutUserRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_DEL_FORBID_SPEAK, handler(self, self.unshutUserRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_GET_ROOM_LIST, handler(self, self.getRoomListRsp))
	msgCtrl.register(gCmd.CMD_VOICE_ROOM_MODULE, gCmd.REQ_VOICE_ROOM_UPDATE_SDK_UID, handler(self, self.updateSDKUIDRsp))
	self:registerNotify()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		self:getRoomList()
	end
end
function voiceRoomCtrl:Logout()
	voiceRoomCtrl.super.Logout(self)
	self.unReadNum = nil
	self:resetData()
end
function voiceRoomCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.VOICE_ROOM, handler(self, self.handleNotifyData))
end
local getMemberDataOfMine = function(mainData)
	return mainData.memInfos[tostring(gametop.playertop_:getPlayerID())]
end
function voiceRoomCtrl:disposeRecord(uid, roomData, method)
	local roleInfo
	if roomData then
		for _, v in pairs(roomData) do
			if v.uid == uid then
				roleInfo = v
				break
			end
		end
		_ENV = pairs(roomData)
		pairs(roomData).name = roleInfo and roleInfo.nickName and roleInfo.nickName or "null"
		pairs(roomData).time = serviceFunctions.systemTime()
		pairs(roomData).method = method
		table.insert(self.roomRecords, pairs(roomData))
	end
	_ENV = self.roomRecords
	self.roomRecords.msg = "MESSAGE_VOICECHAT_SERVER_EVENTRECORD"
	SoraDSendMessage(self.roomRecords)
end
function voiceRoomCtrl:handleNotifyData(event)
	dump(event.data, "voiceRoomCtrl:handleNotifyData event.data", 10)
	for _, v in pairs(event.data) do
		if v.optype == optype.update then
			local oldLeader = self.roomInfo.leader
			self.roomInfo = v.roomData
			local myData = getMemberDataOfMine(self.roomInfo)
			if myData and VoiceChatSDKManager:getInstance().isBeMuted ~= myData.isFobid then
				if myData.isFobid then
					SoraDShowMsgTip(i18n("chat_text_31"))
				end
				VoiceChatSDKManager:getInstance():changeIsMute(myData.isFobid)
			end
			if oldLeader ~= self.roomInfo.leader then
				self:disposeRecord(self.roomInfo.leader, self.roomInfo.memInfos, "master")
			end
			_ENV = self
			self.msg = "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMINFOUPDATE"
			SoraDSendMessage(self)
		elseif v.optype == optype.join then
			local uid = v.uid
			self.roomInfo = v.roomData
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMJOIN"
			SoraDSendMessage(SoraDSendMessage)
			self:disposeRecord(uid, self.roomInfo.memInfos, "join")
		elseif v.optype == optype.exit then
			local oldLeader = self.roomInfo.leader
			self:disposeRecord(v.uid, self.roomInfo.memInfos, "exit")
			local uid = v.uid
			self.roomInfo = v.roomData
			if oldLeader ~= self.roomInfo.leader then
				self:disposeRecord(self.roomInfo.leader, self.roomInfo.memInfos, "master")
			end
			_ENV = self
			self.msg = "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMEXIT"
			SoraDSendMessage(self)
		elseif v.optype == optype.kick then
			self:disposeRecord(v.uid, self.roomInfo.memInfos, "kick")
			local uid = v.uid
			self.roomInfo = v.roomData
			local myData = getMemberDataOfMine(self.roomInfo)
			if not myData then
				SoraDShowMsgTip(i18n("chat_text_32"))
				VoiceChatSDKManager:getInstance():leaveChannel()
				self.roomRecords, _ENV, self.roomInfo.roomID = self.roomInfo, self.roomInfo, 0
			else
				_ENV = VoiceChatSDKManager:getInstance()
				VoiceChatSDKManager:getInstance().msg = "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMKICK"
				SoraDSendMessage((VoiceChatSDKManager:getInstance()))
			end
		elseif v.optype == optype.dismiss then
			SoraDShowMsgTip(i18n("chat_text_33"))
			VoiceChatSDKManager:getInstance():leaveChannel()
			self.roomRecords, _ENV, self.roomInfo.roomID = self.roomInfo, self.roomInfo, 0
		end
	end
end
function voiceRoomCtrl:getMaxMemCount()
	if worldMapDefine.isInRemains() then
		return _G.TEAM_MEMBER_MAX
	end
	return gVoiceMembersLimit
end
function voiceRoomCtrl:isCanSendShare(roomID)
	local time = self.shareInfo[roomID]
	if time and 0 < time then
		local curTime = serviceFunctions.systemTime()
		return 600 <= curTime - time
	end
	return true
end
function voiceRoomCtrl:setSendShare(roomID)
	local curTime = serviceFunctions.systemTime()
	self.shareInfo[roomID] = curTime
end
function voiceRoomCtrl:isHasUnreadRoomList()
	local unReadNum = self.isUnReadNum or 0
	return 0 < unReadNum
end
function voiceRoomCtrl:onRoomDelete()
	if SoraDSearchPanelFromManagerByName("voiceChatListView") then
		self.isUnReadNum = 0
		return
	elseif self.isUnReadNum ~= nil and self.isUnReadNum > 0 then
		self.isUnReadNum = self.isUnReadNum - 1
	end
	_ENV = "voiceChatListView"
	;("voiceChatListView").msg = "MESSAGE_VOICECHAT_SERVER_UPDATE_TIPS"
	SoraDSendMessage("voiceChatListView")
end
function voiceRoomCtrl:onRoomCreate()
	if SoraDSearchPanelFromManagerByName("voiceChatListView") then
		self.isUnReadNum = 0
	elseif self.isUnReadNum ~= nil then
		self.isUnReadNum = self.isUnReadNum + 1
	end
	_ENV = "voiceChatListView"
	;("voiceChatListView").msg = "MESSAGE_VOICECHAT_SERVER_UPDATE_TIPS"
	SoraDSendMessage("voiceChatListView")
end
function voiceRoomCtrl:onReadRoomList()
	self.isUnReadNum = 0
	_ENV = nil
	;(nil).msg = "MESSAGE_VOICECHAT_SERVER_UPDATE_TIPS"
	SoraDSendMessage(nil)
end
return voiceRoomCtrl
