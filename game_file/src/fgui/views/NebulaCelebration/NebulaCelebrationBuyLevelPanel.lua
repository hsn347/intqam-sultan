local nebulaCelebrationCtrl = SoraDGetCtrl("nebulaCelebrationCtrl")
local nebulaCelebrationRead = include("nebulaCelebrationRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCelebrationBuyLevelPanel = class("NebulaCelebrationBuyLevelPanel", baseFguiPanel)
local NEBULA_CELEBRATION_ITEM = 1659
function NebulaCelebrationBuyLevelPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaCelebrationBuyLevelPanel:ctor", self.viewName)
end
function NebulaCelebrationBuyLevelPanel:onInit()
	self.fields.Text_cur:fixPos()
	self.fields.Text_target:fixPos()
	self.fields.Text_from:fixPos()
	self.fields.Text_to:fixPos()
	self.fields.Text_max:fixPos()
	self.fields.effect_jiantou:fixPos()
	print("=======NebulaCelebrationBuyLevelPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Nebula_Celebration_button01"))
	self.fields.Text_cur:setString(i18n("Nebula_Celebration_text14"))
	self.fields.Text_target:setString(i18n("Nebula_Celebration_text15"))
	self.fields.Text_need:setString(i18n("Nebula_Celebration_text16"))
	self.fields.Text_max:setString(i18n("hero_text_41"))
	self.fields.Button_buy:setString(i18n("common_text_282"))
	self.fields.Com_item:initData(NEBULA_CELEBRATION_ITEM, 0)
	self.fields.Slider:setSliderCallBack(handler(self, self.onSliderChanged))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
end
function NebulaCelebrationBuyLevelPanel:onClickBuy()
	SoraDPlaySound()
	if not SoraDEnoughGold(self.goldNum) then
		return
	end
	nebulaCelebrationCtrl:sendReqBuyStarLight(self.buyNum)
end
function NebulaCelebrationBuyLevelPanel:onSliderChanged(value)
	self.toValue = value
	self:updateUI()
end
function NebulaCelebrationBuyLevelPanel:onShow()
	print("=======NebulaCelebrationBuyLevelPanel:onShow")
	local curLevel = nebulaCelebrationCtrl:getCurLevel()
	self.curLevel = curLevel
	self.curExp = nebulaCelebrationCtrl:getCurLevelExp()
	local maxLevel = nebulaCelebrationCtrl:getMaxLevel()
	self.minValue = curLevel + 1
	self.maxValue = maxLevel - 1
	self.toValue = self.minValue
	_ENV = nil
	;(nil).minValue = self.minValue
	;(nil).maxValue = self.maxValue
	;(nil).curValue = self.toValue
	self.fields.Slider:initData(nil)
	print(self.minValue, self.maxValue, self.curLevel, self.curExp)
	self.fields.Text_from:setString(curLevel)
	self:updateUI()
end
function NebulaCelebrationBuyLevelPanel:updateUI()
	self.fields.Text_to:setString(self.toValue)
	self.fields.Text_max:setVisible(self.maxValue == self.toValue)
	local starNum = 0
	local rewardList = nebulaCelebrationCtrl:getRewardList()
	local cfg
	for i = self.minValue, self.toValue do
		if self.toValue > #rewardList then
			cfg = rewardList[#rewardList]
		else
			cfg = rewardList[i]
		end
		if i == self.minValue then
			starNum = starNum + cfg.exp - self.curExp
		else
			starNum = starNum + cfg.exp
		end
	end
	print("buyLevel", self.minValue, self.toValue, starNum)
	self.buyNum = starNum
	self.fields.Com_item:setNum(starNum)
	local price = constantRead.getConstValue("NEBULA_CELEBRATION_STAR")
	local goldNum = starNum * price
	local haveGold = SoraDGetCtrl("lordInfoCtrl"):getBaseInfo().gold
	self.fields.Button_buy:setCostNum(goldNum, haveGold)
	self.goldNum = goldNum
end
return NebulaCelebrationBuyLevelPanel
