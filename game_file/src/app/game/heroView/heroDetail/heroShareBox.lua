local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local HeroShareBox = class("heroShareBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroShareBox")
	end
	return target
end)
function HeroShareBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_533"))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Node_Content = SoraDGetChildByName(self, "Node_Content")
	self.labelCD = SoraDGetChildByName(self, "Text_cd")
	self.commonPopBox_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.labelWorld = SoraDGetChildByName(self, "Text_world")
	self.checkBoxWorld = SoraDGetChildByName(self, "CheckBox_world")
	self.checkBoxAlliance = SoraDGetChildByName(self, "CheckBox_alliance")
	self.labelAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.Sprite_line = SoraDGetChildByName(self, "Sprite_line")
	self.Sprite_line_2 = SoraDGetChildByName(self, "Sprite_line_2")
	self.Sprite_line_sheer = SoraDGetChildByName(self, "Sprite_line_sheer")
	self.Button_FaceBook = SoraDGetChildByName(self, "Button_FaceBook")
	self.text_fb = SoraDGetChildByName(self, "text_fb")
	self.sp_fb = SoraDGetChildByName(self, "sp_fb")
	self.Button_Whatsapp = SoraDGetChildByName(self, "Button_Whatsapp")
	self.Sprite_Whatsapp = SoraDGetChildByName(self, "Sprite_Whatsapp")
	self.text_whatsapp = SoraDGetChildByName(self, "text_whatsapp")
	self.btnShare = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_share")
	self.btnShare:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.Button_FaceBook:addTouchEventListener(handler(self, self.onClick_Button_FaceBook))
	self.Button_Whatsapp:addTouchEventListener(handler(self, self.onClick_Button_Whatsapp))
	self.checkBoxWorld:addEventListener(handler(self, self.btnCheckClickCallBack))
	self.checkBoxAlliance:addEventListener(handler(self, self.btnCheckClickCallBack))
	self.text_fb:setString("Facebook")
	self.text_whatsapp:setString("WhatsApp")
	_ENV = "WhatsApp"
	;("WhatsApp").title = i18n("common_text_533")
	;("WhatsApp").gold = PET_SHARE_GOLD
	self.btnShare:initData("WhatsApp", 1)
	self.shareHid = 0
	self.labelWorld:setString(i18n("common_text_1486"))
	self.labelAlliance:setString(i18n("common_text_1487"))
	self:setCheck(true)
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	self:openTimeUp()
	self:updateBtn()
end
function HeroShareBox:init(heroid)
	self.shareHid = heroid
end
function HeroShareBox:updateBtn()
	if userSDKManager.isKO() then
		self.Button_Whatsapp:setVisible(false)
		self.Button_FaceBook:setPositionX(0)
	end
end
function HeroShareBox:openTimeUp()
	local leftTime = heroCtrl:getShareCDTime()
	self.labelCD:setVisible(0 < leftTime)
	self.btnShare:setTouchEnabled(leftTime <= 0)
	self.btnShare:setBright(leftTime <= 0)
	heroCtrl = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.labelCD:setString(i18n("common_text_2944", nil))
end
function HeroShareBox:setCheck(isWorld)
	self.checkBoxWorld:setSelected(isWorld)
	self.checkBoxWorld:setTouchEnabled(not isWorld)
	self.checkBoxAlliance:setSelected(not isWorld)
	self.checkBoxAlliance:setTouchEnabled(isWorld)
end
function HeroShareBox:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_SUCCESS", handler(self, self.msgHandlerFbSuccess))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_FAIL", handler(self, self.msgHandlerFbFail))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_CANCEL", handler(self, self.msgHandlerFbCancel))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_SUCCESS", handler(self, self.msgHandlerWhatsAppSuccess))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_FAIL", handler(self, self.msgHandlerWhatsAppFail))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_CANCEL", handler(self, self.msgHandlerWhatsAppCancel))
end
function HeroShareBox:msgHandlerFbSuccess()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_success, nil)
end
function HeroShareBox:msgHandlerFbFail()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_fail, nil)
end
function HeroShareBox:msgHandlerFbCancel()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_cancel, nil)
end
function HeroShareBox:msgHandlerWhatsAppSuccess()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_success, nil)
end
function HeroShareBox:msgHandlerWhatsAppFail()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_fail, nil)
end
function HeroShareBox:msgHandlerWhatsAppCancel()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_cancel, nil)
end
function HeroShareBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDEnoughGold(HERO_SHARE_GOLD) then
			print("self.shareHid = ", self.shareHid)
			heroCtrl:queryShareInfo(self.shareHid, self.checkBoxWorld:isSelected() and gChatChannel.KINGDOM or gChatChannel.ALLIANCE)
			self:removeFromParent()
		end
	end
end
function HeroShareBox:btnCheckClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		if button == self.checkBoxWorld then
			self:setCheck(true)
		elseif not gametop.playertop_:getModule("allianceMgr"):hasJoinAlliance() then
			SoraDShowMsgTip(i18n("common_text_583"))
			self:setCheck(true)
		else
			self:setCheck(false)
		end
	end
end
function HeroShareBox:getShareUrl(source)
	local invCode = SoraDGetCtrl("accountExtCtrl"):getAccountInviteCode()
	local nickName = string.urlencode(SoraDGetCtrl("lordInfoCtrl"):getBaseInfo().nickName)
	if type(source) == "number" then
		local cInfo = include("gameInviteltCtrl").getPlatformByVersion(source)
		source = cInfo.platform or ""
	end
	local channel = userSDKManager.getChannel()
	local language = SoraDGetDefaultLanguage() or ""
	local reUrl = ""
	local comUrl = "https://h5share.onemtshare.com/koh/heroshare/?lang=%s&code=%s&id=%s&name=%s&source=%s&kid=%s&timestamp=%s"
	if device.platform == "mac" or userSDKManager.isBeta() then
		comUrl = "https://testh5share.onemtshare.com/koh/heroshare/?lang=%s&code=%s&id=%s&name=%s&source=%s&kid=%s&timestamp=%s"
	end
	reUrl = string.format(comUrl, language, invCode, "" .. self.shareHid, nickName, source, "", "" .. math.floor(socket:gettime()))
	return reUrl
end
function HeroShareBox:onClick_Button_FaceBook(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentUrl = self:getShareUrl("facebook")
		print(contentUrl)
		if device.platform == "mac" then
			device.openURL(contentUrl)
		end
		_ENV = nil
		;(nil).channel = gSDKDef.shareChannel.facebook
		userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_begin, nil)
		userSDKManager.shareFacebookLinkContent(contentUrl)
	end
end
function HeroShareBox:onClick_Button_Whatsapp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentUrl = self:getShareUrl("whatsapp")
		print(contentUrl)
		if device.platform == "mac" then
			device.openURL(contentUrl)
		end
		_ENV = nil
		;(nil).channel = gSDKDef.shareChannel.whatsapp
		userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_begin, nil)
		userSDKManager.shareWhatsappLinkContent(contentUrl)
	end
end
function HeroShareBox:onExitPanel()
end
return HeroShareBox
