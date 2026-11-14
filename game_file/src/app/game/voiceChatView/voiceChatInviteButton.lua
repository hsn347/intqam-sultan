local djCtrl = SoraDGetCtrl("djCtrl")
local voiceChatInviteButton = class("voiceChatInviteButton", function(target)
	if target == nil then
		return SoraDCreateBasePanel("voiceChatInviteButton")
	end
	return target
end)
function voiceChatInviteButton:ctor()
	self.btnMain = SoraDGetChildByName(self, "Button_main")
	self.btnMain:addTouchEventListener(handler(self, self.btnMainClickCallBack))
end
function voiceChatInviteButton:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_ONJOINCHANNELSUCCESS", handler(self, self.onSuccessJoin))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK", function(...)
		SoraDCloseLoading()
		self:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_ONLEAVECHANNEL", function(...)
		SoraDCloseLoading()
	end)
end
function voiceChatInviteButton:initData(info)
	self.inviteData = info
end
function voiceChatInviteButton:req4Permission(...)
	VoiceChatSDKManager:getInstance():req4Permission()
end
function voiceChatInviteButton:checkDJ()
	return djCtrl.isListen
end
function voiceChatInviteButton:btnMainClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.pop_msgbox then
			return
		end
		SoraDPlaySound()
		if self:checkDJ() then
			SoraDShowMsgTip(i18n("Anchor_text_58"))
			self:removeFromParent()
			return
		end
		self:req4Permission()
		dump(self.inviteData, "self.inviteData")
		local inviteData = clone(self.inviteData)
		self.pop_msgbox = true
		_ENV = i18n("Anchor_text_58")
		i18n("Anchor_text_58").name = inviteData.inviteUserName
		SoraDShowMsgBox(i18n("chat_text_58", i18n("Anchor_text_58")), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			self.pop_msgbox = false
			local gametop = gModuleMgr.getObject("gametop")
			local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
			local inviteUserId = inviteData.inviteUserId
			local roomId = inviteData.roomId
			local chatDataModuleAPI = include("chatDataModuleAPI")
			local joinChannel = function(channel, inviteUid)
				if VoiceChatSDKManager:getInstance().vociePermission then
					voiceRoomCtrl:joinRoom(channel, nil, inviteUid)
				else
					SoraDShowMsgTip(i18n("chat_text_55"))
					SoraDCloseLoading()
				end
			end
			if callType == MSGBOX_CALLBACK_YES then
				if VoiceChatSDKManager:getInstance().voiceState == gVoiceState.inRoom then
					if VoiceChatSDKManager:getInstance().chatRoomId ~= tostring(roomId) then
						SoraDShowMsgBox(i18n("chat_text_59"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
							if msgType == MSGBOX_CALLBACK_YES then
								SoraDShowLoading(nil, nil, nil, nil, 10)
								local _roomId = VoiceChatSDKManager:getInstance().chatRoomId
								voiceRoomCtrl:exitRoom(_roomId)
							end
						end)
					else
						SoraDShowMsgTip(i18n("chat_text_60"))
						self:removeFromParent()
					end
				else
					SoraDShowLoading(nil, nil, nil, nil, 10)
					joinChannel(roomId, inviteUserId)
				end
			elseif callType == MSGBOX_CALLBACK_NO then
				chatDataModuleAPI:rejectInvitation(inviteUserId, roomId)
				self:removeFromParent()
			end
		end)
	end
end
function voiceChatInviteButton:onSuccessJoin(target, redata)
	SoraDCloseLoading()
	self:removeFromParent()
end
return voiceChatInviteButton
