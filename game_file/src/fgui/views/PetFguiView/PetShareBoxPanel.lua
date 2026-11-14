local petCtrl = SoraDGetCtrl("petCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetShareBoxPanel = class("PetShareBoxPanel", baseFguiPanel)
function PetShareBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PetShareBoxPanel:ctor", self.viewName)
	self.sharePid = 0
end
function PetShareBoxPanel:onInit()
	print("=======PetShareBoxPanel:onInit")
	self.sharePid = self.param and self.param.sharePid
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
function PetShareBoxPanel:onShow()
	print("=======PetShareBoxPanel:onShow")
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	self:openTimeUp()
end
function PetShareBoxPanel:openTimeUp()
	local leftTime = petCtrl:getPetShareLeftCDTime()
	self.fields.Text_cd:setVisible(0 < leftTime)
	self.fields.bg_cd:setVisible(0 < leftTime)
	self.fields.Button_share:setTouchEnabled(leftTime <= 0)
	self.fields.Button_share:setBright(leftTime <= 0)
	if 0 < leftTime then
		petCtrl = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.fields.Text_cd:setString(i18n("common_text_2944", nil))
	end
end
function PetShareBoxPanel:setCheck(isWorld)
	self.checkBoxWorld:setSelected(isWorld)
	self.checkBoxWorld:setTouchEnabled(not isWorld)
	self.checkBoxAlliance:setSelected(not isWorld)
	self.checkBoxAlliance:setTouchEnabled(isWorld)
end
function PetShareBoxPanel:btnClickCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(PET_SHARE_GOLD) then
		petCtrl:reqPetShare(self.sharePid, self.checkBoxWorld:isSelected() and gChatChannel.KINGDOM or gChatChannel.ALLIANCE)
		self:removeFromParent()
	end
end
function PetShareBoxPanel:getShareUrl(source)
	_ENV = nil
	;(nil).petid = self.sharePid
	return SoraGetGameShareUrl("petshare", source, nil)
end
function PetShareBoxPanel:onClick_Button_FaceBook()
	SoraDPlaySound()
	local contentUrl = self:getShareUrl(1)
	print(contentUrl)
	if device.platform == "mac" then
		device.openURL(contentUrl)
	end
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_begin, nil)
	userSDKManager.shareFacebookLinkContent(contentUrl)
end
function PetShareBoxPanel:onClick_Button_Whatsapp()
	SoraDPlaySound()
	local contentUrl = self:getShareUrl(2)
	print(contentUrl)
	if device.platform == "mac" then
		device.openURL(contentUrl)
	end
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_begin, nil)
	userSDKManager.shareWhatsappLinkContent(contentUrl)
end
function PetShareBoxPanel:btnCheckClickCallBack(EventContext)
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
return PetShareBoxPanel
