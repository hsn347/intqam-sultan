local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local heroWeaponRead = include("heroWeaponRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponResetPanel = class("HeroWeaponResetPanel", baseFguiPanel)
function HeroWeaponResetPanel:ctor(...)
	HeroWeaponResetPanel.super.ctor(self, ...)
	print("HeroWeaponResetPanel:ctor", self.viewName)
end
function HeroWeaponResetPanel:onInit()
	print("=======HeroWeaponResetPanel:onInit")
	self.isItemEnough = false
	self.fields.Panel_bg:setString(i18n("HeroWeapon_13"))
	self.fields.Text_tip:setString(i18n("HeroWeapon_16"))
	self.fields.Lab_back:setString(i18n("HeroWeapon_43"))
	self.fields.Lab_Need:setString(i18n("HeroWeapon_44"))
	self.fields.Btn_reset:setString(i18n("HeroWeapon_13"))
	self.fields.Btn_reset:addClickListener(handler(self, self.btnResetClick))
	self.fields.Btn_cancel:setString(i18n("common_text_185"))
	self.fields.Btn_cancel:addClickListener(handler(self, self.btnCancelClick))
	self.view:fixChildrenPos()
end
function HeroWeaponResetPanel:onShow()
	print("=======HeroWeaponResetPanel:onShow")
	self.data = self.param.data
	self:initData()
end
function HeroWeaponResetPanel:initData()
	self.costID = constantRead.getConstValue("HERO_WEAPON_REBUILD_COST_ITEM")
	self.fields.cost:initData(self.costID)
	local needCount = heroWeaponRead.getWeaponResetCost(self.data.weaponID, self.data.stage, self.data.lv, self.data.quality)
	local ownCount = backpackCtrl:getItemCount(self.costID)
	constantRead = self.data.quality
	self.data.quality.var1 = fguiHelper.getColorString(needCount > ownCount and "#E02B2B" or "#FFFBD5", ownCount)
	self.data.quality.var2 = needCount
	local strNum = i18n("%{var1}/%{var2}", self.data.quality)
	self.fields.Text_costNum:setString(strNum)
	self.isItemEnough = needCount <= ownCount
	self.fields.Btn_reset:setBright(self.isItemEnough)
	local itemID = constantRead.getConstValue("WEAPON_LEVELUP_NEED_ITEM", 512901)
	local result = backpackltCtrl:getResult(itemID)
	local singleExp = result[1]
	local totalExp = heroWeaponRead.getLvEXP(self.data.quality, self.data.lv, self.data.exp)
	local returnItemCount = math.floor(totalExp / singleExp)
	self.fields.return_item:initData(itemID)
	self.fields.Text_itemNum:setString(returnItemCount)
	local weaponID, count = heroWeaponRead.getWeaponRebuildReturn(self.data.weaponID, self.data.stage)
	constantRead = nil
	;(nil).id = self.data.id
	;(nil).weaponID = self.data.weaponID
	;(nil).quality = self.data.quality
	;(nil).type = self.data.type
	;(nil).lv = 0
	;(nil).stage = 0
	;(nil).exp = 0
	self.fields.return_weapon:initData(nil)
	self.fields.Text_weaponNum:setString(count)
end
function HeroWeaponResetPanel:btnResetClick()
	SoraDPlaySound()
	if not self.isItemEnough then
		SoraDShowMsgTip(i18n("HeroWeapon_52"))
		return
	end
	heroWeaponCtrl:reqRebirth(self.data.id)
	self:close()
end
function HeroWeaponResetPanel:btnCancelClick()
	SoraDPlaySound()
	self:close()
end
return HeroWeaponResetPanel
