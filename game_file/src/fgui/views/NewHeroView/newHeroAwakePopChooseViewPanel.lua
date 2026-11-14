local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newHeroAwakePopChooseViewPanel = class("newHeroAwakePopChooseViewPanel", baseFguiPanel)
function newHeroAwakePopChooseViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("newHeroAwakePopChooseViewPanel:ctor", self.viewName)
end
function newHeroAwakePopChooseViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewHeroView"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function newHeroAwakePopChooseViewPanel:onInit()
	print("=======newHeroAwakePopChooseViewPanel:onInit")
	self.fields.btn_instance:addClickListener(handler(self, self.btnInstanceClickCallBack))
	self.fields.btn_upgrade:addClickListener(handler(self, self.btnUpgradeClickCallBack))
	self.fields.btn_upgrade:fixPos()
	self.fields.btn_instance:fixPos()
	self.fields.head_to:fixPos()
	self.fields.head_from:fixPos()
	self.fields.arrow:setScaleX(SoraDFIsRA() and 1 or -1)
	self:initData(self.param.heroID, self.param.upgradeType)
end
function newHeroAwakePopChooseViewPanel:onShow()
	print("=======newHeroAwakePopChooseViewPanel:onShow")
end
function newHeroAwakePopChooseViewPanel:onHide()
	print("=======newHeroAwakePopChooseViewPanel:onHide")
end
function newHeroAwakePopChooseViewPanel:onDispose()
	print("=======newHeroAwakePopChooseViewPanel:onDispose")
end
function newHeroAwakePopChooseViewPanel:initData(heroID, upgradeType)
	self.heroID = heroID
	self.upgradeType = upgradeType or gHeroSysUpType.UPGRADE
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroUpgradedInfo = heroltCtrl:getUpgradeInfo(self.heroID, self.heroInfo.quality + 1)
	self:initView()
end
function newHeroAwakePopChooseViewPanel:initView(...)
	local costTime = 0
	if self.upgradeType == gHeroSysUpType.UPGRADE then
		self.fields.Panel_bg:setTitle(i18n("hero_btn_01"))
		self.controllers.c1:setSelectedIndex(0)
		self.fields.head_to:initData(self.heroID)
		self.fields.head_to:setHeadBg(self.heroInfo.quality + 1)
		self.fields.text_instruction:setString(i18n("hero_text_68"))
		self.fields.btn_upgrade:setString(i18n("hero_btn_01"))
		self.fields.btn_instance:setString(i18n("hero_text_67"))
		costTime = self.heroUpgradedInfo.upgradeTime
	else
		local skillID = heroltCtrl:getAwakeSkill(self.heroID).skillID
		local skillInfo = heroltCtrl.getSkillDesInfo(skillID)
		self.fields.skillIcon:setIcon(skillInfo.herIcon)
		self.fields.Panel_bg:setTitle(i18n("hero_btn_04"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.text_instruction:setString(i18n("heroskill_text_02"))
		self.fields.btn_upgrade:setString(i18n("hero_btn_04"))
		self.fields.btn_instance:setString(i18n("hero_btn_05"))
		costTime = heroltCtrl:getAwakeInfo(self.heroID).time
	end
	local achiReduceTime = buffCtrl:getBuffEffect(gBuffEffect.HERO_UPGRADE_SPEED, gBuffSource.ACHIEVEMENT) or 0
	self.realUpgradeTime = costTime * (1 / (1 + achiReduceTime / 1000))
	self.fields.btn_instance:setCostNum(serviceFunctions.timeConvertToGold(self.realUpgradeTime), SoraDGetGold())
	self.fields.btn_upgrade:setCostTitle(SoraDConvertSecondToString(self.realUpgradeTime))
	self.fields.btn_upgrade:setCostIcon("icon_hourglass.png")
	self.fields.head_from:initData(self.heroID)
	self.fields.head_from:setHeadBg(self.heroInfo.quality)
end
function newHeroAwakePopChooseViewPanel:updateView()
	self:initData(self.heroID, self.upgradeType)
end
function newHeroAwakePopChooseViewPanel:btnInstanceClickCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(serviceFunctions.timeConvertToGold(self.realUpgradeTime)) then
		heroCtrl:upgradeHeroReq(self.heroID, gHeroUpgradeType.IMMEDIATE, self.upgradeType)
		_ENV = self.heroID
		self.heroID.byUID = true
		local guideData = SoraDConfigGet("Game:heroList:guide~table", self.heroID)
		if not guideData.heroUpQuality then
			guideData.heroUpQuality = true
			_ENV = self.upgradeType
			self.upgradeType.byUID = true
			SoraDConfigSet("Game:heroList:guide~table", guideData, self.upgradeType)
		end
	end
end
function newHeroAwakePopChooseViewPanel:btnUpgradeClickCallBack()
	SoraDPlaySound()
	local obj, upgradeType = heroCtrl:getUpgradeQueue()
	local ret = obj and obj ~= self.heroID
	if ret then
		if upgradeType == gHeroSysUpType.UPGRADE then
			SoraDShowMsgTip(i18n("hero_text_09"))
		else
			SoraDShowMsgTip(i18n("hero_text_107"))
		end
	else
		heroCtrl:upgradeHeroReq(self.heroID, gHeroUpgradeType.NORMAL, self.upgradeType)
		_ENV = self.heroID
		self.heroID.byUID = true
		local guideData = SoraDConfigGet("Game:heroList:guide~table", self.heroID)
		if not guideData.heroUpQuality then
			guideData.heroUpQuality = true
			_ENV = self.upgradeType
			self.upgradeType.byUID = true
			SoraDConfigSet("Game:heroList:guide~table", guideData, self.upgradeType)
		end
	end
end
return newHeroAwakePopChooseViewPanel
