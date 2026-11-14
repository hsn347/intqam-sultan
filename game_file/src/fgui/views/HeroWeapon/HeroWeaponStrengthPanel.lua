local constantRead = include("constantRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponStrengthPanel = class("HeroWeaponStrengthPanel", baseFguiPanel)
function HeroWeaponStrengthPanel:ctor(...)
	HeroWeaponStrengthPanel.super.ctor(self, ...)
	print("HeroWeaponStrengthPanel:ctor", self.viewName)
end
function HeroWeaponStrengthPanel:onInit()
	print("=======HeroWeaponStrengthPanel:onInit")
	self.fields.mv_sj:setAllFrameName("heroweapon_sj_01_%.2d.png", 1)
	self.fields.mv_sj:setVisible(false)
	self.costID = constantRead.getConstValue("WEAPON_LEVELUP_NEED_ITEM", 512901)
	local result = backpackltCtrl:getResult(self.costID)
	self.singleExp = result[1]
	self.fields.Com_title:initData(i18n("HeroWeapon_42"), handler(self, self.onClickClose))
	self.fields.Btn_strength:setString(i18n("HeroWeapon_14"))
	self.fields.Btn_strength:addClickListener(handler(self, self.btnStrengthClick))
	self.fields.Btn_strength:setEnabled(false)
	self.fields.Bar:setMax(100)
	self.fields.Text_attr:setString(i18n("hero_title_01"))
	self.fields.Text_max:setString(i18n("HeroWeapon_39"))
	self.fields.Text_need:setString(i18n("Weapon_Rune_tips_053"))
	self.fields.slider:setSliderCallBack(handler(self, self.onSliderChange))
	self.fields.slider:setInpuBoxFixPos()
	self.fields.Text_lv:fixPos()
	self.fields.arrow:fixPos()
	self.fields.arrow:setScaleX(SoraDFIsRA() and 0.55 or -0.55)
	self.fields.Text_lvTo:fixPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function HeroWeaponStrengthPanel:onShow()
	print("=======HeroWeaponStrengthPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.data = self.param.data
	self.fields.icon_weapon:setSpriteFrame(heroWeaponRead.getWeaponIcon(self.data.weaponID))
	self.fields.Text_name:setString(heroWeaponRead.getWeaponName(self.data.weaponID))
	self.fields.stars:setStage(self.data.stage)
	self.fields.item:initData(self.costID)
	self:initData()
end
function HeroWeaponStrengthPanel:initData(target, data)
	SoraDCloseLoading(self)
	if target then
		self.data = heroWeaponCtrl:getWeaponByUid(self.data.id)
		self.fields.mv_sj:setVisible(true)
		self.fields.mv_sj:setPlaySettings(0, -1, 1, -1, function()
			self.fields.mv_sj:setVisible(false)
		end)
	end
	self.lvLimit = heroWeaponRead.getWeaponLvLimit(self.data.weaponID, self.data.stage)
	self.data.isMax = self.data.lv >= self.lvLimit
	if self.data.lv >= self.lvLimit then
		self.controllers.c_max:setSelectedIndex(1)
		self.fields.Text_lv:setString("MAX")
		self.fields.Bar:setValue(100)
		self.fields.Text_bar:setString("")
	else
		self.controllers.c_max:setSelectedIndex(0)
		_ENV = 1
		;(1).lv = self.data.lv
		self.fields.Text_lv:setString(i18n("common_text_100", 1))
		_ENV = i18n("common_text_100", 1)
		i18n("common_text_100", 1).lv = self.data.lv + 1
		self.fields.Text_lvTo:setString(i18n("common_text_100", i18n("common_text_100", 1)))
		local progress = SoraDPreciseDecimal(self.data.exp / heroWeaponRead.getLvUpEXP(self.data.quality, self.data.lv), 4) * 100
		self.fields.Bar:setValue(progress)
		self.fields.Text_bar:setString(progress .. "%")
	end
	self.myItemCount = backpackCtrl:getItemCount(self.costID)
	_ENV = self.costID
	self.costID.maxValue = math.min(self.myItemCount, self:getToMaxCount())
	self.costID.minValue = 0
	self.costID.curValue = 0
	self.costID.allowZero = true
	self.fields.slider:initData(self.costID)
end
function HeroWeaponStrengthPanel:getToMaxCount()
	local count = 0
	local needEXP = 0
	for i = self.data.lv, self.lvLimit - 1 do
		needEXP = needEXP + heroWeaponRead.getLvUpEXP(self.data.quality, i)
	end
	count = math.ceil((needEXP - self.data.exp) / self.singleExp)
	return count
end
function HeroWeaponStrengthPanel:onSliderChange(value)
	_ENV = nil
	;(nil).var1 = value
	;(nil).var2 = self.myItemCount
	self.fields.Text_count:setString(i18n("%{var1}/%{var2}", nil))
	local addEXP = value * self.singleExp
	self:preView(addEXP)
	self.fields.Btn_strength:setString(self.myItemCount == 0 and i18n("Weapon_Rune_tips_074") or i18n("HeroWeapon_14"))
	if self.data.lv >= self.lvLimit then
		self.fields.Btn_strength:setEnabled(false)
	else
		self.fields.Btn_strength:setEnabled(self.myItemCount == 0 or 0 < value)
	end
end
function HeroWeaponStrengthPanel:preView(addEXP)
	local preLv = self.data.lv
	local preExp = self.data.exp + addEXP
	local preAddEXP = addEXP
	for i = self.data.lv, self.lvLimit - 1 do
		if preAddEXP + self.data.exp >= heroWeaponRead.getLvUpEXP(self.data.quality, i) then
			preLv = i + 1
			preAddEXP = preAddEXP - heroWeaponRead.getLvUpEXP(self.data.quality, i)
			preExp = preAddEXP + self.data.exp
		else
			break
		end
	end
	local isToMax = preLv == self.lvLimit
	heroWeaponRead = self.data.quality
	self.data.quality.lv = preLv
	self.fields.Text_lvTo:setString(i18n("common_text_100", self.data.quality))
	if isToMax then
		self.fields.Bar:setValue(100)
		self.fields.Text_bar:setString("MAX")
	else
		local progress = SoraDPreciseDecimal(preExp / heroWeaponRead.getLvUpEXP(self.data.quality, preLv), 4) * 100
		self.fields.Bar:setValue(progress)
		self.fields.Text_bar:setString(progress .. "%")
	end
	self.data.preLv = preLv
	self.fields.Com_attr:initData(self.data)
end
function HeroWeaponStrengthPanel:btnStrengthClick()
	SoraDPlaySound()
	if self.myItemCount == 0 then
		_ENV = nil
		;(nil).itemID = self.costID
		uiManager:show("CommonSourceGuide", nil)
		return
	end
	heroWeaponCtrl:reqUpgradeLv(self.data.id, self.fields.slider:getSliderCurValue())
	SoraDShowLoading(self)
end
return HeroWeaponStrengthPanel
