local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponAdvancePanel = class("HeroWeaponAdvancePanel", baseFguiPanel)
function HeroWeaponAdvancePanel:ctor(...)
	HeroWeaponAdvancePanel.super.ctor(self, ...)
	print("HeroWeaponAdvancePanel:ctor", self.viewName)
end
function HeroWeaponAdvancePanel:onInit()
	print("=======HeroWeaponAdvancePanel:onInit")
	self.fields.mv_jjbd:setAllFrameName("heroweapon_jj_01_%.2d.png", 1)
	self.fields.mv_jjbd:setVisible(false)
	self.weaponUidList, _ENV = self.fields.mv_jjbd.setVisible, self.fields.mv_jjbd.setVisible
	self.fields.Com_title:initData(i18n("HeroWeapon_41"), handler(self, self.onClickClose))
	self.fields.Text_attr:setString(i18n("hero_title_01"))
	self.fields.Text_max:setString(i18n("HeroWeapon_38"))
	self.fields.Text_need:setString(i18n("Weapon_Rune_tips_053"))
	self.fields.Btn_advance:setString(i18n("HeroWeapon_15"))
	self.fields.Btn_advance:addClickListener(handler(self, self.btnAdvanceClick))
	self.fields.Btn_advance:setEnabled(false)
	self.fields.starFrom:fixPos()
	self.fields.starTo:fixPos()
	self.fields.Text_fromLv:fixPos()
	self.fields.Text_toLv:fixPos()
	self.fields.arrow:setScaleX(SoraDFIsRA() and 0.55 or -0.55)
end
function HeroWeaponAdvancePanel:chooseBack(target, data)
	self.weaponUidList = data.selList
	self.fields.Btn_need:initData(self.data.id, self.data.quality, self.costID, self.costNum, self.weaponUidList)
	_ENV = self.costID
	_ENV = nil
	;(nil).num = fguiHelper.getColorString(#self.weaponUidList < self.costNum and "#E02B2B" or "#FFFBD5", #self.weaponUidList)
	;(nil).need = self.costNum
	self.costID.num = i18n("%{num}/%{need}", nil)
	self.fields.Text_selectNum:setString(i18n("HeroWeapon_46", self.costID))
	self.fields.Btn_advance:setEnabled(#self.weaponUidList >= self.costNum)
end
function HeroWeaponAdvancePanel:onShow()
	print("=======HeroWeaponAdvancePanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.data = self.param.data
	self.fields.icon_weapon:setSpriteFrame(heroWeaponRead.getWeaponIcon(self.data.weaponID))
	self.fields.Text_name:setString(heroWeaponRead.getWeaponName(self.data.weaponID))
	_ENV = heroWeaponRead.getWeaponName(self.data.weaponID)
	heroWeaponRead.getWeaponName(self.data.weaponID).lv = self.data.lv
	self.fields.Text_lv:setString(i18n("common_text_100", heroWeaponRead.getWeaponName(self.data.weaponID)))
	self:initData()
end
function HeroWeaponAdvancePanel:initView()
	self.fields.Btn_advance:setEnabled(false)
	self.stageLimit = heroWeaponRead.getWeaponStageLimit(self.data.weaponID)
	self.data.isMax = self.data.stage >= self.stageLimit
	if self.data.stage >= self.stageLimit then
		self.controllers.c_max:setSelectedIndex(1)
		self.fields.starMax:setStage(self.stageLimit)
	else
		self.controllers.c_max:setSelectedIndex(0)
		self.fields.starFrom:setStage(self.data.stage)
		local lvLimitFrom = heroWeaponRead.getWeaponLvLimit(self.data.weaponID, self.data.stage)
		heroWeaponRead = nil
		;(nil).lv = lvLimitFrom
		self.fields.Text_fromLv:setString(i18n("HeroWeapon_45", nil))
		self.fields.starTo:setStage(self.data.stage + 1)
		local lvLimitTo = heroWeaponRead.getWeaponLvLimit(self.data.weaponID, self.data.stage + 1)
		heroWeaponRead = i18n("HeroWeapon_45", nil)
		i18n("HeroWeapon_45", nil).lv = lvLimitTo
		self.fields.Text_toLv:setString(i18n("HeroWeapon_45", i18n("HeroWeapon_45", nil)))
		self.weaponUidList, heroWeaponRead = self.fields.Text_toLv.setString, self.fields.Text_toLv.setString
		self.costID, self.costNum = heroWeaponRead.getWeaponStageCost(self.data.weaponID, self.data.stage)
		self.fields.Btn_need:initData(self.data.id, self.data.quality, self.costID, self.costNum, self.weaponUidList)
		heroWeaponRead = self.costID
		heroWeaponRead = i18n("HeroWeapon_45", i18n("HeroWeapon_45", nil))
		i18n("HeroWeapon_45", i18n("HeroWeapon_45", nil)).num = fguiHelper.getColorString("#E02B2B", 0)
		i18n("HeroWeapon_45", i18n("HeroWeapon_45", nil)).need = self.costNum
		self.costID.num = i18n("%{num}/%{need}", i18n("HeroWeapon_45", i18n("HeroWeapon_45", nil)))
		self.fields.Text_selectNum:setString(i18n("HeroWeapon_46", self.costID))
	end
	self.data.preStage = math.min(self.data.stage + 1, self.stageLimit)
	self.fields.Com_attr:initDataEX(self.data)
end
function HeroWeaponAdvancePanel:initData(target, data)
	SoraDCloseLoading(self)
	if target then
		self.data = heroWeaponCtrl:getWeaponByUid(self.data.id)
		_UPVALUE4_ = nil
		;(nil)[1] = ffa.callFunc(function()
			self.fields.mv_jjbd:setVisible(true)
			self.fields.mv_jjbd:setPlaySettings(0, -1, 1, -1, function()
				self.fields.mv_jjbd:setVisible(false)
			end)
		end)
		;(nil)[2] = ffa.delay(0.6)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.starFrom:playUpStageAni(self.data.stage)
		end)
		;(nil)[4] = ffa.delay(0.2)
		;(nil)[5] = ffa.callFunc(function()
			self:initView()
		end)
		;(nil)[6] = ffa.callFunc(function()
			self:initView()
		end)
		self:runAction(ffa.seq(nil))
	else
		self:initView()
	end
end
function HeroWeaponAdvancePanel:btnAdvanceClick()
	SoraDPlaySound()
	heroWeaponCtrl:reqUpgradeStage(self.data.id, self.weaponUidList)
	self.fields.Btn_advance:setEnabled(false)
	SoraDShowLoading(self)
end
return HeroWeaponAdvancePanel
