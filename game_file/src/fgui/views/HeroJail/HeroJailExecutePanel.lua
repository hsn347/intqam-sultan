local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroJailExecutePanel = class("HeroJailExecutePanel", baseFguiPanel)
function HeroJailExecutePanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroJailExecutePanel:ctor", self.viewName)
end
function HeroJailExecutePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroJailExecutePanel:onInit()
	print("=======HeroJailExecutePanel:onInit")
	self.itemID = 502001
	self.shareType = nil
	self.isShowShare = self.proxy.param.isShare
	self.handle = self.proxy.param.handle
	self.worldShareCost = constantRead.getConstValue("HERO_KILL_SHARE_KINGDOMCHAT_GOLD")
	self.kingdomShareCost = constantRead.getConstValue("HERO_KILL_SHARE_ANNOUNCEMENT_GOLD")
	self.fields.Panel_bg:setString(i18n("killHero_title"))
	self.fields.Text_msg:setString(i18n("killHero_sure_desc"))
	self.fields.CheckBox_share_world:addClickListener(handler(self, self.btnShareWorldClick))
	self.fields.CheckBox_share_kingdom:addClickListener(handler(self, self.btnShareKingdomClick))
	self.fields.CheckBox_share_world:setString(i18n("common_text_1486"))
	self.fields.CheckBox_share_kingdom:setString(i18n("killHero_shareToAnnouncement_name"))
	self.fields.Button_yes:setString(i18n("common_text_204"))
	self.fields.Button_yes:setFreeTitle(i18n("common_text_204"))
	self.fields.Button_yes:addClickListener(handler(self, self.onBtnYesClick))
end
function HeroJailExecutePanel:onShow()
	print("=======HeroJailExecutePanel:onShow")
	self:updateBtnState()
end
function HeroJailExecutePanel:updateBtnState()
	self.controllers.c1:setSelectedIndex(self.isShowShare and 1 or 0)
	local hornCount = backpackCtrl:getItemCount(self.itemID)
	if self.shareType == 1 then
		self.fields.Button_yes:setCost(1001, self.worldShareCost)
	elseif self.shareType == 2 then
		if 0 < hornCount then
			self.fields.Button_yes:setCost(self.itemID, 1)
		else
			self.fields.Button_yes:setCost(1001, self.kingdomShareCost)
		end
	else
		self.fields.Button_yes:setCost(1001, 0)
	end
end
function HeroJailExecutePanel:btnShareWorldClick()
	SoraDPlaySound()
	local isSelected = self.fields.CheckBox_share_world:isSelected()
	if isSelected then
		self.fields.CheckBox_share_kingdom:setSelected(false)
	end
	self.shareType = isSelected and 1 or nil
	self:updateBtnState()
end
function HeroJailExecutePanel:btnShareKingdomClick()
	local isSelected = self.fields.CheckBox_share_kingdom:isSelected()
	self.shareType = isSelected and 2 or nil
	if isSelected then
		self.fields.CheckBox_share_world:setSelected(false)
	end
	self:updateBtnState()
end
function HeroJailExecutePanel:onBtnYesClick()
	if self.handle then
		self.handle(self.shareType)
	end
	self:removeFromParent()
end
return HeroJailExecutePanel
