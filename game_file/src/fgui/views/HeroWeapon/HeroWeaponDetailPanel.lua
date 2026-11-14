local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponDetailPanel = class("HeroWeaponDetailPanel", baseFguiPanel)
function HeroWeaponDetailPanel:ctor(...)
	HeroWeaponDetailPanel.super.ctor(self, ...)
	print("HeroWeaponDetailPanel:ctor", self.viewName)
end
function HeroWeaponDetailPanel:onInit()
	print("=======HeroWeaponDetailPanel:onInit")
	self.isCanReset = false
	self.fields.Panel_bg:setString(i18n("common_text_059"))
	self.fields.Btn_advance:setString(i18n("HeroWeapon_15"))
	self.fields.Btn_advance:addClickListener(handler(self, self.btnAdvanceClick))
	self.fields.Btn_strength:setString(i18n("HeroWeapon_14"))
	self.fields.Btn_strength:addClickListener(handler(self, self.btnStengthClick))
	self.fields.Btn_reset:setString(i18n("HeroWeapon_13"))
	self.fields.Btn_reset:addClickListener(handler(self, self.btnResetClick))
	self.fields.nbg:fix()
end
function HeroWeaponDetailPanel:onShow()
	print("=======HeroWeaponDetailPanel:onShow")
	self.data = self.param.data
	self:initData()
end
function HeroWeaponDetailPanel:initData()
	self.fields.weapon:initData(self.data)
	self.fields.Text_name:setString(heroWeaponRead.getWeaponName(self.data.weaponID))
	self.fields.nbg:setSpriteFrame(heroWeaponRead.getWeaponNBg(self.data.weaponID))
	local recipientName = heroWeaponRead.getRecipientName(self.data.weaponID)
	self.controllers.c1:setSelectedIndex(recipientName and 1 or 0)
	self.view:fixChildrenPos()
	if recipientName then
		self.fields.Text_pro:setString(recipientName)
	end
	heroWeaponRead = heroWeaponRead.getWeaponNBg(self.data.weaponID)
	heroWeaponRead.getWeaponNBg(self.data.weaponID).lv = self.data.lv
	self.fields.Text_lv:setString(i18n("common_text_100", heroWeaponRead.getWeaponNBg(self.data.weaponID)))
	self.fields.stars:setStage(self.data.stage)
	self.fields.hero:initData(self.data.id, self.data.heroID)
	self.fields.Com_attr:initData(self.data)
	self.lvLimit = heroWeaponRead.getWeaponLvLimit(self.data.weaponID, self.data.stage)
	self.fields.Btn_strength:setEnabled(self.data.lv < self.lvLimit)
	self.isCanReset = 0 < self.data.lv or 0 < self.data.exp or 0 < self.data.stage
	self.fields.Btn_reset:setBright(self.isCanReset)
end
function HeroWeaponDetailPanel:updateView()
	SoraDCloseLoading(self)
	self.data = heroWeaponCtrl:getWeaponByUid(self.data.id)
	self:initData()
end
function HeroWeaponDetailPanel:btnAdvanceClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("HeroWeaponAdvance", nil)
	self:close()
end
function HeroWeaponDetailPanel:btnStengthClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("HeroWeaponStrength", nil)
	self:close()
end
function HeroWeaponDetailPanel:btnResetClick()
	SoraDPlaySound()
	if not self.isCanReset then
		SoraDShowMsgTip(i18n("HeroWeapon_51"))
		return
	end
	_ENV = i18n("HeroWeapon_51")
	i18n("HeroWeapon_51").data = self.data
	uiManager:show("HeroWeaponReset", i18n("HeroWeapon_51"))
end
function HeroWeaponDetailPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "hero" then
		return self.fields.hero:getTouch()
	else
		return self.fields[itemName]
	end
end
return HeroWeaponDetailPanel
