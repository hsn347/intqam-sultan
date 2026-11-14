local rocketRushRead = include("rocketRushRead")
local rocketRushCtrl = SoraDGetCtrl("rocketRushCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SkyrocketPointsGiftBoxPanel = class("SkyrocketPointsGiftBoxPanel", baseFguiPanel)
function SkyrocketPointsGiftBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SkyrocketPointsGiftBoxPanel:ctor", self.viewName)
end
function SkyrocketPointsGiftBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SkyrocketPointsGiftBoxPanel:onInit()
	print("=======SkyrocketPointsGiftBoxPanel:onInit")
	self.fields.Text_notify:setString(i18n("Bright_fireworks_05"))
	self.fields.List:setAlignCenter(true)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_get:setString(i18n("cavalryrise_text_06"))
	self.fields.Btn_get:addClickListener(handler(self, self.btnGetClick))
end
function SkyrocketPointsGiftBoxPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function SkyrocketPointsGiftBoxPanel:onShow()
	print("=======SkyrocketPointsGiftBoxPanel:onShow")
	self.classType = rocketRushCtrl:getClassType()
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self:updateView()
end
function SkyrocketPointsGiftBoxPanel:updateView()
	SoraDCloseLoading(self)
	self.curLevel = rocketRushCtrl:getCurRewardLevel()
	self.chestPoint = rocketRushRead.getChestPoint(self.classType, self.curLevel)
	local hasRewardCount = rocketRushCtrl:getHasRewardCount()
	local chestLimit = rocketRushRead.getChestLimit(self.classType)
	_ENV = nil
	;(nil).var1 = hasRewardCount
	;(nil).var2 = chestLimit
	self.fields.Text_count:setString(i18n("%{var1}/%{var2}", nil))
	local mayGetCount = rocketRushCtrl:getMayGetCount()
	self.fields.Btn_get:setEnabled(0 < mayGetCount)
	local allianceScore = rocketRushCtrl:getAllianceScore()
	local mayGetCount = rocketRushCtrl:getMayGetCount()
	local curScore = allianceScore - mayGetCount * self.chestPoint
	if mayGetCount == 0 and curScore <= self.chestPoint and hasRewardCount >= chestLimit then
		self.fields.Btn_get:setString(i18n("common_text_1892"))
	else
		self.fields.Btn_get:setString(i18n("cavalryrise_text_06"))
	end
	self.reward = rocketRushRead.getChestReward(self.classType, self.curLevel)
	self.fields.List:setNumItems(#self.reward)
	_ENV = i18n("cavalryrise_text_06")
	i18n("cavalryrise_text_06").num = self.chestPoint
	self.fields.Text_tip:setString(i18n("EidalAdha_King_text_08", i18n("cavalryrise_text_06")))
end
function SkyrocketPointsGiftBoxPanel:btnGetClick()
	SoraDPlaySound()
	SoraDShowLoading(self)
	rocketRushCtrl:sendReward(self.curLevel)
end
return SkyrocketPointsGiftBoxPanel
