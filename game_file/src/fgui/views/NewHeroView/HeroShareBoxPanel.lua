local heroCtrl = SoraDGetCtrl("heroCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroShareBoxPanel = class("HeroShareBoxPanel", baseFguiPanel)
function HeroShareBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroShareBoxPanel:ctor", self.viewName)
	self.shareHid = 0
end
function HeroShareBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroShareBoxPanel:onInit()
	print("=======HeroShareBoxPanel:onInit")
	self.shareHid = self.param and self.param.shareHid
	self.fields.Panel_bg:setString(i18n("common_text_533"))
	self.checkBoxWorld = self.fields.CheckBox_world
	self.checkBoxAlliance = self.fields.CheckBox_alliance
	self.checkBoxWorld:addClickListener(handler(self, self.btnCheckClickCallBack))
	self.checkBoxAlliance:addClickListener(handler(self, self.btnCheckClickCallBack))
	self.fields.Text_world:setString(i18n("common_text_1486"))
	self.fields.Text_alliance:setString(i18n("common_text_1487"))
	self:setCheck(true)
	self.fields.Button_share:setString(i18n("common_text_533"))
	self.fields.Button_share:setCostNum(PET_SHARE_GOLD)
	self.fields.Button_share:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_facebook:setString("Facebook")
	self.fields.Button_facebook:addClickListener(handler(self, self.onClick_Button_FaceBook))
	self.fields.Button_whatsapp:setString("WhatsApp")
	self.fields.Button_whatsapp:addClickListener(handler(self, self.onClick_Button_Whatsapp))
	if not SoraDFIsRA() then
		self.checkBoxWorld:fixPos()
		self.checkBoxAlliance:fixPos()
		self.fields.Text_world:fixPos()
		self.fields.Text_alliance:fixPos()
		self.fields.Button_facebook:fixPos()
		self.fields.Button_whatsapp:fixPos()
	end
end
function HeroShareBoxPanel:onShow()
	print("=======HeroShareBoxPanel:onShow")
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	self:openTimeUp()
end
function HeroShareBoxPanel:openTimeUp()
	local leftTime = heroCtrl:getShareCDTime()
	self.fields.Text_cd:setVisible(0 < leftTime)
	self.fields.bg_cd:setVisible(0 < leftTime)
	self.fields.Button_share:setTouchEnabled(leftTime <= 0)
	self.fields.Button_share:setBright(leftTime <= 0)
	if 0 < leftTime then
		heroCtrl = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.fields.Text_cd:setString(i18n("common_text_2944", nil))
	end
end
function HeroShareBoxPanel:setCheck(isWorld)
	self.checkBoxWorld:setSelected(isWorld)
	self.checkBoxWorld:setTouchEnabled(not isWorld)
	self.checkBoxAlliance:setSelected(not isWorld)
	self.checkBoxAlliance:setTouchEnabled(isWorld)
end
function HeroShareBoxPanel:btnClickCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(PET_SHARE_GOLD) then
		heroCtrl:queryShareInfo(self.shareHid, self.checkBoxWorld:isSelected() and gChatChannel.KINGDOM or gChatChannel.ALLIANCE)
		self:removeFromParent()
	end
end
function HeroShareBoxPanel:getShareUrl(source)
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
function HeroShareBoxPanel:onClick_Button_FaceBook()
	SoraDPlaySound()
	local contentUrl = self:getShareUrl(1)
	print(contentUrl)
	if device.platform == "mac" then
		device.openURL(contentUrl)
	end
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_begin, nil)
	userSDKManager.shareFacebookLinkContent(contentUrl)
end
function HeroShareBoxPanel:onClick_Button_Whatsapp()
	SoraDPlaySound()
	local contentUrl = self:getShareUrl(2)
	print(contentUrl)
	if device.platform == "mac" then
		device.openURL(contentUrl)
	end
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_begin, nil)
	userSDKManager.shareWhatsappLinkContent(contentUrl)
end
function HeroShareBoxPanel:btnCheckClickCallBack(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	if button == self.checkBoxWorld then
		self:setCheck(true)
	elseif not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("common_text_583"))
		self:setCheck(true)
	else
		self:setCheck(false)
	end
end
return HeroShareBoxPanel
