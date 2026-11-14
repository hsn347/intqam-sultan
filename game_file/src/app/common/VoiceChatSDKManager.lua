_ENV = nil
;(nil).offLine = 1
;(nil).onLine = 2
_ENV, gVoiceState, (nil).inRoom = nil, nil, 3
;(nil).hold = 1
;(nil).free = 2
gSpeakStyle, (nil).mute = nil, 3
_VoiceChatSDKManagerInstance = nil
VoiceChatSDKManager = class("VoiceChatSDKManager")
local CSUserSDKManager = _G.CSUserSDKManager
function VoiceChatSDKManager:getInstance()
	if _VoiceChatSDKManagerInstance == nil then
		_VoiceChatSDKManagerInstance = VoiceChatSDKManager.new()
	end
	return _VoiceChatSDKManagerInstance
end
function VoiceChatSDKManager.openView(...)
	if VoiceChatSDKManager:getInstance().voiceState == gVoiceState.onLine then
		local panel = SoraDCreatePanel("voiceChatListView")
		panel:show()
	elseif VoiceChatSDKManager:getInstance().voiceState == gVoiceState.inRoom then
		local panel = SoraDCreatePanel("voiceChatRoomView")
		panel:show()
	elseif VoiceChatSDKManager:getInstance().voiceState == gVoiceState.offLine then
		SoraDShowMsgTip(i18n("chat_text_56"))
	end
	local voiceRoomCtrl = SoraDGetCtrl("voiceRoomCtrl")
	voiceRoomCtrl:onReadRoomList()
end
function VoiceChatSDKManager.share(roomId, roomName)
	_ENV = nil
	;(nil).roomId = roomId
	local (nil).roomName, dataJson = roomName, nil
	dump(dataJson, "请求分享语音聊天室", 10)
	local gametop = gModuleMgr.getObject("gametop")
	local chatCtrl = gametop.playertop_:getModule("chatCtrl")
	chatCtrl:share(gChatChannel.ALLIANCE, gChatShareType.VOICE_CHAT_ROOM, dataJson)
end
function VoiceChatSDKManager:muteMusic()
	print("设置音乐静音")
	AudioEngine.setMusicVolume(0)
	self:openSpeakerphone()
	self.isInVoiceRoom = true
end
function VoiceChatSDKManager:unmuteMusic()
	print("设置音乐恢复")
	if device.platform == "ios" then
		AudioEngine.destroyInstance()
		SoraDResetBackGroundMusic()
	end
	AudioEngine.setMusicVolume(SoraDConfigGet("System:GameOptionsView:musicVolume~float"))
	self.isInVoiceRoom = false
end
function VoiceChatSDKManager:resetLeaveChannel()
	self:unmuteMusic()
	self:resetData()
	_UPVALUE0_ = nil
	;(nil).msg = "MESSAGE_VOICECHAT_ONLEAVECHANNEL"
	self:sendmsg(nil)
	_UPVALUE0_ = nil
	;(nil).msg = "MESSAGE_VOICECHAT_SPEAKSTYLE_REFRESH"
	self:sendmsg(nil)
	_UPVALUE0_ = nil
	;(nil).msg = "MESSAGE_CHAT_DJ_ROOM_BACK"
	self:sendmsg(nil, true)
end
function VoiceChatSDKManager:isListenToDJ()
	return self.isInVoiceRoom and self.isInDJ
end
function VoiceChatSDKManager:isChatInVoiceRoom()
	return self.isInVoiceRoom and not self.isInDJ
end
function VoiceChatSDKManager:sendmsg(data, isDJ)
	if not self.isInDJ then
		SoraDSendMessage(data)
	elseif isDJ then
		SoraDSendMessage(data)
	end
end
function VoiceChatSDKManager:resetData(...)
	self.canTalk = false
	self._willJoinChannel = nil
	self.chatRoomId = nil
	self.sdkUID = nil
	self.voiceState = gVoiceState.offLine
	self.isBeMuted = false
	self.speakStyle = gSpeakStyle.hold
	self.voiceState = self:getInitState() and gVoiceState.onLine or gVoiceState.offLine
	print("[debug djCtrl:VoiceChatSDKManager:resetData] self.voiceState=", self.voiceState)
end
function VoiceChatSDKManager:ctor()
	self.vociePermission = false
	self.isInDJ = false
	self:resetData()
end
function VoiceChatSDKManager:changeSpeakStyle(style)
	self.speakStyle = style or self.speakStyle
	_UPVALUE0_ = nil
	;(nil).msg = "MESSAGE_VOICECHAT_SPEAKSTYLE_REFRESH"
	self:sendmsg(nil)
end
function VoiceChatSDKManager:changeIsMute(bool)
	self.isBeMuted = bool
	if self.isBeMuted then
		self.speakStyle = gSpeakStyle.mute
	else
		self.speakStyle = gSpeakStyle.hold
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_VOICECHAT_SPEAKSTYLE_REFRESH"
	self:sendmsg(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_VOICECHAT_ISMUTE_REFRESH"
	self:sendmsg(nil)
end
function VoiceChatSDKManager:getPermissionState(...)
	self.vociePermission = CSUserSDKManager:authorizationStatusForAudio()
	print("[debug djCtrl:self.vociePermission=", self.vociePermission)
	return self.vociePermission
end
function VoiceChatSDKManager:req4Permission(...)
	if device.platform == "mac" then
		return
	end
	CSUserSDKManager:requestAccessForAudio()
end
function VoiceChatSDKManager:getInitState(...)
	if not commonCheck.VOICE_CHATE_ROOM and not self.isInDJ then
		return
	end
	local _status = true
	return _status
end
function VoiceChatSDKManager:joinChannel(channel, isDJ)
	channel = tostring(channel)
	if self._willJoinChannel and self.isInDJ then
		return
	end
	self._willJoinChannel = channel
	self.isInDJ = isDJ
	local gametop = gModuleMgr.getObject("gametop")
	local uid = tostring(gametop.playertop_:getPlayerID())
	CSUserSDKManager:setChannelCommuniactionMode()
	CSUserSDKManager:joinChannel(channel, uid)
end
function VoiceChatSDKManager:leaveChannel(channel)
	if not commonCheck.VOICE_CHATE_ROOM and not self.isInDJ then
		return
	end
	self.isInDJ = false
	_ENV = nil
	;(nil).msg = "MESSAGE_VOICECHAT_PRELEAVECHANNEL"
	self:sendmsg(nil)
	if not channel and not self.chatRoomId then
		if device.platform == "mac" then
			return
		end
		CSUserSDKManager:leaveChannel("0")
		return
	elseif not channel and self.chatRoomId then
		channel = self.chatRoomId
	end
	CSUserSDKManager:leaveChannel(channel)
	self:resetLeaveChannel()
end
function VoiceChatSDKManager:leaveChannelTimeOut()
	if self._willJoinChannel then
		local gametop = gModuleMgr.getObject("gametop")
		local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
		voiceRoomCtrl:exitRoom(self._willJoinChannel)
	end
	self:leaveChannel(self._willJoinChannel)
end
function VoiceChatSDKManager:mute(uid)
	uid = uid or ""
	CSUserSDKManager:mute(uid)
end
function VoiceChatSDKManager:unmute(uid)
	uid = uid or ""
	CSUserSDKManager:unmute(uid)
end
function VoiceChatSDKManager:start2Speak(...)
	CSUserSDKManager:openMic()
end
function VoiceChatSDKManager:end2Speak(...)
	CSUserSDKManager:closeMic()
end
function VoiceChatSDKManager:openSpeakerphone(...)
	CSUserSDKManager:openSpeakerphone()
end
function VoiceChatSDKManager:closeSpeakerphone(...)
	CSUserSDKManager:closeSpeakerphone()
end
function VoiceChatSDKManager:enableAudio(...)
	if not commonCheck.VOICE_CHATE_ROOM and not self.isInDJ then
		return
	end
	CSUserSDKManager:enableAudio()
end
function VoiceChatSDKManager:disableAudio(...)
	if not commonCheck.VOICE_CHATE_ROOM and not self.isInDJ then
		return
	end
	CSUserSDKManager:disableAudio()
end
function VoiceChatSDKManager:DJJoinSuccess(info)
	local gametop = gModuleMgr.getObject("gametop")
	local uid = tostring(gametop.playertop_:getPlayerID())
	local djCtrl = gametop.playertop_:getModule("djCtrl")
	if info.arg1 then
		self.chatRoomId = tostring(info.arg0)
		self.sdkUID = tostring(info.arg1)
	end
	self.voiceState = gVoiceState.inRoom
	print("[debug djCtrl:DJJoinSuccess] self.voiceState=", self.voiceState, djCtrl.isBroadcastDJ, djCtrl:isInSpeak())
	self:muteMusic()
	if djCtrl.isBroadcastDJ or djCtrl:isInSpeak() then
		self:start2Speak()
	else
		self:end2Speak()
		if djCtrl.isBroadcastDJ then
			self:mute(uid)
		end
	end
end
function VoiceChatSDKManager:DJSomeTalk(info)
	local gametop = gModuleMgr.getObject("gametop")
	if gametop.playertop_ == nil then
		return
	end
	local uid = tostring(gametop.playertop_:getPlayerID())
	local djCtrl = gametop.playertop_:getModule("djCtrl")
	if info["0"] then
		self.canTalk = true
	elseif djCtrl.curDJInfo and djCtrl.curDJInfo.uid and info[tostring(djCtrl.curDJInfo.uid)] then
		self.isInDJ = true
	end
end
function VoiceChatSDKManager_Common_Callback(args)
	print("VoiceChatSDKManager_Common_Callback", args)
	local this = VoiceChatSDKManager:getInstance()
	local info = json.decode(args)
	if "onJoinChannelSuccess" == info.method then
		local gametop = gModuleMgr.getObject("gametop")
		local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
		local djCtrl = gametop.playertop_:getModule("djCtrl")
		local roomInfo = voiceRoomCtrl.roomInfo
		if djCtrl.isBroadcastDJ or djCtrl.isListen or djCtrl:isInSpeak() then
			this:DJJoinSuccess(info)
			_ENV = info
			info.msg = "MESSAGE_CHAT_DJ_ROOM_BACK"
			this:sendmsg(info, true)
		elseif djCtrl:checkIsDjChannel(info.arg0) then
			VoiceChatSDKManager:getInstance():leaveChannel(tostring(info.arg0))
			_ENV = tostring(info.arg0)
			tostring(info.arg0).msg = "MESSAGE_CHAT_DJ_ROOM_BACK"
			this:sendmsg(tostring(info.arg0))
		elseif roomInfo and roomInfo.roomID and roomInfo.roomID > 0 then
			display.getRunningScene():runAction(cca.seq(cca.delay(0.1), cca.callFunc(function()
				this.chatRoomId = tostring(info.arg0)
				this.sdkUID = tostring(info.arg1)
				this.voiceState = gVoiceState.inRoom
				this = nil
				;(nil).msg = "MESSAGE_VOICECHAT_ONJOINCHANNELSUCCESS"
				this:sendmsg(nil)
				this = nil
				;(nil).msg = "MESSAGE_VOICECHAT_SPEAKSTYLE_REFRESH"
				this:sendmsg(nil)
				voiceRoomCtrl:updateSDKUID(this.sdkUID)
				this:muteMusic()
				local panel = SoraDCreatePanel("voiceChatRoomView")
				panel:show()
			end)))
		else
			print("roominfo is not exit")
			VoiceChatSDKManager:getInstance():leaveChannel(tostring(info.arg0))
			_ENV = tostring(info.arg0)
			tostring(info.arg0).msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
			this:sendmsg(tostring(info.arg0))
			_ENV = tostring(info.arg0)
			tostring(info.arg0).msg = "MESSAGE_CHAT_DJ_ROOM_BACK"
			this:sendmsg(tostring(info.arg0))
		end
	elseif "onLeaveChannel" == info.method then
		this:resetLeaveChannel()
	elseif "onActiveSpeaker" == info.method then
		local jsonData = info.arg0
		local transData = json.decode(jsonData)
		this:DJSomeTalk(transData)
		_ENV = transData
		transData.msg = "MESSAGE_VOICECHAT_ONSOMEONESPEAK"
		transData.speakData = transData
		this:sendmsg(transData)
	elseif "onUserOffline" == info.method then
		local sdkUID = tostring(info.arg0)
	elseif "request4Permission" == info.method then
		if "false" == info.arg0 then
			this.vociePermission = false
		elseif "true" == info.arg0 then
			this.vociePermission = true
			print("麦克风权限授权成功。")
		end
	elseif "onError" == info.method then
		print("调用onError方法")
		local errorStr = tostring(info.arg1) or ""
		local errorCode = tostring(info.arg0) or ""
		if errorCode == "18" or errorCode == "-18" then
			print("已经退出")
			_ENV = transData
			transData.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
			this:sendmsg(transData)
			return
		end
		if this.isInDJ then
			if errorCode == "17" or errorCode == "-17" then
				this:DJJoinSuccess(info)
				_ENV = info
				info.msg = "MESSAGE_CHAT_DJ_ROOM_BACK"
				this:sendmsg(info, true)
				return
			elseif errorCode == "3" or errorCode == "4" or errorCode == "-3" or errorCode == "-4" then
				this.voiceState = gVoiceState.offLine
			end
		end
		_ENV = info
		info.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
		this:sendmsg(info)
		this:unmuteMusic()
		if this._willJoinChannel then
			local gametop = gModuleMgr.getObject("gametop")
			local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
			voiceRoomCtrl:exitRoom(this._willJoinChannel)
		end
		this:resetData()
		_ENV = voiceRoomCtrl.exitRoom
		voiceRoomCtrl.exitRoom.msg = "MESSAGE_VOICECHAT_ONLEAVECHANNEL"
		this:sendmsg(voiceRoomCtrl.exitRoom)
		_ENV = voiceRoomCtrl.exitRoom
		voiceRoomCtrl.exitRoom.msg = "MESSAGE_VOICECHAT_SPEAKSTYLE_REFRESH"
		this:sendmsg(voiceRoomCtrl.exitRoom)
		_ENV = voiceRoomCtrl.exitRoom
		voiceRoomCtrl.exitRoom.msg = "MESSAGE_CHAT_DJ_ROOM_BACK"
		this:sendmsg(voiceRoomCtrl.exitRoom, true)
		if errorCode ~= "-3" then
			_G.sendTraceBackLog("onError", nil, errorStr .. ":" .. errorCode)
		end
	end
end
