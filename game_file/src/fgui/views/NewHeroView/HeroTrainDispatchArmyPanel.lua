local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local armyltCtrl = include("armyltCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local armyDesRead = include("armyDesRead")
local buildLogic = include("buildLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroTrainDispatchArmyPanel = class("HeroTrainDispatchArmyPanel", baseFguiPanel)
function HeroTrainDispatchArmyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroTrainDispatchArmyPanel:ctor", self.viewName)
end
function HeroTrainDispatchArmyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonDispatch"
	end
	return self._packageList
end
function HeroTrainDispatchArmyPanel:onInit()
	print("=======HeroTrainDispatchArmyPanel:onInit")
	self.tableArmy, _ENV = print, print
	self.allCount = 0
	self.curCount = 0
	self.curExp = 0
	self.canUseCount = 0
	self.isReset = true
	self.fields.title:initData(i18n("herotrain_btn_01"), handler(self, self.onClickClose))
	self.fields.Text_warning:setString(i18n("herotrain_text_23"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Com_Slide:setText("%")
	_ENV = "%"
	;("%").maxValue = 100
	;("%").minValue = 0
	;("%").curValue = 0
	self.fields.Com_Slide:initData("%")
	self.fields.Com_Slide:setSliderCallBack(handler(self, self.armyChange))
	self.fields.Com_Slide:setMinValue(0)
	self.fields.Com_Slide:setInpuBoxFixPos(96, 96)
	self.fields.Label_weight:setString("0")
	self.fields.Label_count:setString("0/0")
	self.fields.Button_convene:setString(i18n("common_text_3616"))
	self.fields.btn_train:setString(i18n("herotrain_btn_02"))
	self.fields.btn_quickChoose:setString(i18n("common_btn_18"))
	self.fields.Button_physicalPlus:addClickListener(handler(self, self.btnExpHelpClick))
	self.fields.Button_convene:addClickListener(handler(self, self.btnConveneClickCallBack))
	self.fields.btn_quickChoose:addClickListener(handler(self, self.btnQuickClickCallBack))
	self.fields.btn_train:addClickListener(handler(self, self.btnTrainClickCallBack))
end
function HeroTrainDispatchArmyPanel:onShow()
	print("=======HeroTrainDispatchArmyPanel:onShow")
	self:initData(nil, self.proxy.param.heroID, self.proxy.param.myPosition)
end
function HeroTrainDispatchArmyPanel:armyChange(armyPer)
	armyPer = math.min(armyPer, self.nowCount * 100 / self.canUseCount)
	self:quickChoose(armyPer)
	_ENV = armyPer
	armyPer.notBack = true
	self.fields.Com_Slide:setSliderCurValue(math.ceil(armyPer), armyPer)
	self.isReset = true
	if 100 <= armyPer then
		self.fields.btn_quickChoose:setTitleText(i18n("common_btn_18"))
	elseif self.curCount >= self.nowCount or self.curCount > 0 then
		self.fields.btn_quickChoose:setTitleText(i18n("common_btn_18"))
	else
		self.fields.btn_quickChoose:setTitleText(i18n("common_text_852"))
		self.isReset = false
	end
	return true
end
function HeroTrainDispatchArmyPanel:initData(initArmyList, heroID, myPosition)
