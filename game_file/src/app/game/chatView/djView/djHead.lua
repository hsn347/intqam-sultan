local djCtrl = SoraDGetCtrl("djCtrl")
local DjHead = class("djHead", function(target)
	if target == nil then
		return SoraDCreateBasePanel("djHead")
	end
	return target
end)
function DjHead:ctor()
	self.canSpeak = true
	self.djuid = 0
	self.djInfo, _ENV, self.showType = gChatDJShowType.OTHER, gChatDJShowType.OTHER, gChatDJShowType.OTHER
	self.layerCut = SoraDGetChildByName(self, "Panel_cut")
	self.nodeInfo = SoraDGetChildByName(self, "Node_info")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.btnHead = SoraDGetChildByName(self, "Button_head")
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelTips = SoraDGetChildByName(self, "Text_tips")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.btnTime = SoraDGetChildByName(self, "Button_time")
	self.nodeOpen = SoraDGetChildByName(self, "Node_open")
	self.btnRank = SoraDGetChildByName(self, "Button_rank")
	self.labelPeople = SoraDGetChildByName(self, "Text_people")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.nodeSwitch = SoraDGetExtendChildFromCCSByName(self, "CCS_gameSettingCommonSwitch_switch")
	self.nodeDj = SoraDGetChildByName(self, "Node_dj")
	self.btnVoice = SoraDGetChildByName(self, "Button_voice")
	self.btnList = SoraDGetChildByName(self, "Button_list")
	self.spriteRank = SoraDGetChildByName(self, "Sprite_rank")
	self.btnTime:setTitleText(i18n("Anchor_text_37"))
	SoraDAutoSizeButtonText(self.btnTime)
	self.btnHead:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnTime:addTouchEventListener(handler(self, self.btnTimeClickCallBack))
	self.btnVoice:addTouchEventListener(handler(self, self.btnVoiceClickCallBack))
	self.btnList:addTouchEventListener(handler(self, self.btnListClickCallBack))
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClickCallBack))
	self.nodeSwitch:setCallBack(handler(self, self.btnSwitchClickCallBack))
	self:resetVoiceBtn()
	self.labelTips:setString(i18n("common_text_4761"))
end
function DjHead:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_LISTEN_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_ROOM_BACK", function(...)
		self:resetVoiceBtn()
		self.nodeSwitch:setEnabledTouch(true)
	end)
end
function DjHead:initData(uid, type)
	self.djuid = uid
	self.showType = type
	self:updateData()
end
function DjHead:updateData()
	if self.djuid == nil or self.showType ~= gChatDJShowType.OTHER then
		if SoraDGetCtrl("djCtrl").isDJ and self.showType == gChatDJShowType.DJ_VIEW then
			local gametop = gModuleMgr.getObject("gametop")
			local uid = gametop.playertop_:getPlayerID()
			self.djuid = uid
		else
			self.djuid = djCtrl:getCurDJInfo().uid
		end
	end
	print("当前主播", self.djuid)
	self.djInfo = djCtrl:getDJInfo(self.djuid)
	self:updatePublic()
	if self.showType == gChatDJShowType.OTHER then
		self.nodeOpen:setVisible(false)
	elseif self.showType == gChatDJShowType.CHAT_VIEW or self.showType == gChatDJShowType.DJ_VIEW then
		self.labelTips:setVisible(not djCtrl.isBroadcastDJ)
		if djCtrl.isBroadcast then
			self.nodeOpen:setVisible(true)
			self.nodeSwitch:setVisible(self.showType == gChatDJShowType.CHAT_VIEW and not djCtrl.isBroadcastDJ)
			self.nodeSwitch:setVal(djCtrl.isListen)
			self.nodeDj:setVisible(self.showType == gChatDJShowType.DJ_VIEW and djCtrl.isDJ)
			self.labelPoint:setString(string.formatnumberthousands(self.djInfo.contributeCount))
			self.labelPeople:setString(string.formatnumberthousands(self.djInfo.listenNum))
			self.spriteRank:setPositionX(self.labelPoint:getPositionX() - SoraDFSign(self.labelPoint:getContentSize().width + 10))
		else
			self.nodeOpen:setVisible(false)
		end
	end
	local offsetY = self.nodeOpen:isVisible() and 180 or 120
	local oldOffsetY = self.nodeInfo:getPositionY()
	self.imgBg:setContentSize(cc.size(640, offsetY + 20))
	self.layerCut:setContentSize(cc.size(640, offsetY))
	self.nodeInfo:setPositionY(offsetY)
	print("oldOffsetY", oldOffsetY)
	print("offsetY", offsetY)
	if oldOffsetY ~= offsetY then
		_ENV = "offsetY"
		;("offsetY").msg = "MESSAGE_CHAT_DJ_HEAD_UPDATE"
		SoraDSendMessage("offsetY")
	end
	SoraDCloseLoading()
end
function DjHead:updatePublic()
	if djCtrl.isBroadcast then
		SoraDGetHeadFromManager(self.imgHead, self.djInfo.iconID, self.djInfo.avatar)
		self.labelName:setString(self.djInfo.nick_name)
		self.labelDes:setString(self.djInfo.anchor_sign)
		self.btnTime:setVisible(false)
	else
		self.labelName:setString(i18n("Anchor_text_21"))
		self.labelDes:setString(i18n("Anchor_text_22"))
		self.imgHead:loadTexture("frame_zblt_tx.png", ccui.TextureResType.plistType)
		self.btnTime:setVisible(true)
	end
	self.btnHead:setTouchEnabled(djCtrl.isBroadcast)
end
function DjHead:getSingleHeight()
	return self.layerCut:getContentSize().height
end
function DjHead:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended and self.djuid then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("djInfoView")
		panel:initData(self.djuid)
		panel:show()
	end
end
function DjHead:btnTimeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("djListView"):show()
	end
end
function DjHead:btnListClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = djCtrl
		djCtrl.title = i18n("Anchor_text_28")
		SoraDShowHelpMsgTip(djCtrl:getKidListStr(self.djuid), djCtrl)
	end
end
function DjHead:btnRankClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("djRankView")
		panel:initData(self.djuid)
		panel:show()
	end
end
function DjHead:btnSwitchClickCallBack(isListen)
	VoiceChatSDKManager:getInstance():req4Permission()
	if VoiceChatSDKManager:getInstance():isChatInVoiceRoom() then
		SoraDShowMsgTip(i18n("Anchor_text_57"))
		_ENV = i18n("Anchor_text_57")
		i18n("Anchor_text_57").msg = "MESSAGE_CHAT_DJ_INFO_UPDATE"
		SoraDSendMessage(i18n("Anchor_text_57"))
	else
		SoraDShowLoading()
		self.nodeSwitch:setEnabledTouch(false)
		djCtrl:sendDJListen()
	end
end
function DjHead:resetVoiceBtn()
	self.canSpeak = true
	SoraDGetChildByName(self.btnVoice, "frame_zbyh_gb"):setVisible(not self.canSpeak)
	SoraDGetChildByName(self.btnVoice, "icon_voice_speak_hold"):setColor(self.canSpeak and cc.c3b(225, 225, 225) or cc.c3b(120, 120, 120))
end
function DjHead:btnVoiceClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("音量设置", djCtrl.isDJ, djCtrl.isBroadcastDJ, self.canSpeak)
		if djCtrl.isDJ and djCtrl.isBroadcastDJ then
			if self.canSpeak then
				self.canSpeak = false
				VoiceChatSDKManager:getInstance():end2Speak()
				VoiceChatSDKManager:getInstance():mute(tostring(self.djuid))
			else
				self.canSpeak = true
				VoiceChatSDKManager:getInstance():start2Speak()
			end
			SoraDGetChildByName(self.btnVoice, "frame_zbyh_gb"):setVisible(not self.canSpeak)
			SoraDGetChildByName(self.btnVoice, "icon_voice_speak_hold"):setColor(self.canSpeak and cc.c3b(225, 225, 225) or cc.c3b(120, 120, 120))
		end
	end
end
return DjHead
