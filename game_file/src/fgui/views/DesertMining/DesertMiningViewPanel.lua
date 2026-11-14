local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local DesertMiningCtrl = SoraDGetCtrl("DesertMiningCtrl")
local newLotteryRead = include("newLotteryRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertMiningViewPanel = class("DesertMiningViewPanel", baseFguiPanel)
function DesertMiningViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertMiningViewPanel:ctor", self.viewName)
end
function DesertMiningViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertMiningViewPanel:onInit()
	print("=======DesertMiningViewPanel:onInit")
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545
	self.itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
	self.fields.Com_title:initData(i18n("activity_name_9001545"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Com_Preaward:setString(i18n("decrypt_text_03"))
	self.fields.Com_Preaward:addClickListener(handler(self, self.onClickPreaward))
	self.fields.Button_Ten:addClickListener(handler(self, self.onClickTen))
	self.fields.Button_One:addClickListener(handler(self, self.onClickOne))
	self.fields.Com_Stage:initData(newLotteryRead.getStageConfig(self.activityID, DesertMiningCtrl:getClassType()))
	self.fields.Com_have:initData(self.itemID)
	self.fields.Button_One:setString(i18n("Desertmining_03"))
	self.fields.Button_Ten:setString(i18n("Desertmining_04"))
end
function DesertMiningViewPanel:onShow()
	print("=======DesertMiningViewPanel:onShow")
	SoraDShowLoading(self)
	DesertMiningCtrl:sendReqInitDataMsg()
end
function DesertMiningViewPanel:updatePoint()
	local lotteryCount = DesertMiningCtrl:getLotteryCount()
	self.fields.Com_Stage:setBarValue(lotteryCount, DesertMiningCtrl)
	DesertMiningCtrl = nil
	;(nil).num = lotteryCount
	self.fields.txt_value:setString(i18n_html("Desertmining_02", nil))
end
function DesertMiningViewPanel:updateButton()
	self.fields.Button_One:setCost(self.itemID, 1)
	self.fields.Button_Ten:setCost(self.itemID, 10)
	if DesertMiningCtrl:isFreeLottery() then
		self.fields.Button_One:setFree()
	end
end
function DesertMiningViewPanel:updateItemNum()
	self.fields.Com_have:updateNum()
end
function DesertMiningViewPanel:onClickPreaward()
	SoraDPlaySound()
	uiManager:show("DesertMiningPreaward")
end
function DesertMiningViewPanel:onClickOne()
	SoraDPlaySound()
	if DesertMiningCtrl:isFreeLottery() or backpackCtrl:getItemCount(self.itemID) >= 1 then
		SoraDShowLoading(self)
		DesertMiningCtrl:reqCommonLottery9001545Lottery(1)
	else
		self:jumpToGift()
	end
end
function DesertMiningViewPanel:onClickTen()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= 10 then
		SoraDShowLoading(self)
		DesertMiningCtrl:reqCommonLottery9001545Lottery(10)
	else
		self:jumpToGift()
	end
end
function DesertMiningViewPanel:jumpToGift()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function DesertMiningViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Desertmining_01")
	uiManager:show("RuleView", nil)
end
return DesertMiningViewPanel
