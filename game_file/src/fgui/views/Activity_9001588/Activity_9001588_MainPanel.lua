local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001588_Ctrl = SoraDGetCtrl("activity_9001588_Ctrl")
local newLotteryRead = include("newLotteryRead")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001588_MainPanel = class("Activity_9001588_MainPanel", baseFguiPanel)
function Activity_9001588_MainPanel:ctor(...)
	Activity_9001588_MainPanel.super.ctor(self, ...)
	print("Activity_9001588_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001588
	self.exchange_activityID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001589
end
function Activity_9001588_MainPanel:onInit()
	print("=======Activity_9001588_MainPanel:onInit")
	self.itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
	self.fields.Com_title:initData(activityTimeRead.getActivityShowName(self.activityID), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Com_Preaward:setString(i18n("decrypt_text_03"))
	self.fields.Com_Preaward:addClickListener(handler(self, self.onClickPreaward))
	self.fields.Btn_exchangeShop:setString(i18n("common_text_1809"))
	self.fields.Btn_exchangeShop:addClickListener(handler(self, self.btnExchangeShopClick))
	self.fields.Button_Ten:addClickListener(handler(self, self.onClickTen))
	self.fields.Button_One:addClickListener(handler(self, self.onClickOne))
	self.fields.Com_have:initData(self.itemID)
	self.fields.Button_One:setString(i18n("Nebula_walk_02"))
	self.fields.Button_Ten:setString(i18n("Nebula_walk_03"))
	self.fields.Usm_2:setCompleteCallback(handler(self, self.playUsm2EndBack))
	self.fields.touch_panel:setVisible(false)
end
function Activity_9001588_MainPanel:onShow()
	print("=======Activity_9001588_MainPanel:onShow")
	SoraDShowLoading(self)
	activity_9001588_Ctrl:reqCommonLottery9001588Init()
end
function Activity_9001588_MainPanel:updateButton()
	_ENV = activity_9001588_Ctrl:getLuckyValue()
	activity_9001588_Ctrl:getLuckyValue().color = "#70C723"
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(activity_9001588_Ctrl:getLuckyValue()), activity_9001588_Ctrl:getLuckyValue())
	self.fields.Text_luckyValue:setString(i18n("nebulaeroaming08") .. countStr)
	self.fields.Button_One:setCost(self.itemID, 1)
	self.fields.Button_Ten:setCost(self.itemID, 10)
	if activity_9001588_Ctrl:isFreeLottery() then
		self.fields.Button_One:setFree()
	end
end
function Activity_9001588_MainPanel:updateItemNum()
	self.fields.Com_have:updateNum()
end
function Activity_9001588_MainPanel:playLotteryAction(reward)
	self.fields.Usm_2:setVisible(true)
	self.fields.Usm_2:play(false)
	self.fields.touch_panel:setVisible(true)
	self.rewardGained = reward
end
function Activity_9001588_MainPanel:playUsm2EndBack()
	self.fields.Usm_2:setVisible(false)
	if self.rewardGained then
		_ENV = nil
		;(nil).reward = self.rewardGained
		uiManager:show("Activity_9001588_Gainaward", nil)
		self.rewardGained = nil
	end
	self.fields.touch_panel:setVisible(false)
end
function Activity_9001588_MainPanel:onClickPreaward()
	SoraDPlaySound()
	uiManager:show("Activity_9001588_Preaward")
end
function Activity_9001588_MainPanel:onClickOne()
	SoraDPlaySound()
	if activity_9001588_Ctrl:isFreeLottery() or backpackCtrl:getItemCount(self.itemID) >= 1 then
		SoraDShowLoading(self)
		activity_9001588_Ctrl:reqCommonLottery9001588Lottery(1)
	else
		self:jumpToGift()
	end
end
function Activity_9001588_MainPanel:onClickTen()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= 10 then
		SoraDShowLoading(self)
		activity_9001588_Ctrl:reqCommonLottery9001588Lottery(10)
	else
		self:jumpToGift()
	end
end
function Activity_9001588_MainPanel:jumpToGift()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001588_MainPanel:onClickHelp()
	SoraDPlaySound()
	local MAX_LUCKYRATIO = include("constantRead").getConstValue("MAX_LUCKYRATIO", 100)
	_ENV = nil
	_ENV = nil
	;(nil).num = MAX_LUCKYRATIO
	;(nil).content = i18n("Icefestival2024_text03", nil)
	uiManager:show("RuleView", nil)
end
function Activity_9001588_MainPanel:btnExchangeShopClick()
	SoraDPlaySound()
	print("跳转到对应兑换商城======")
	if clientEventMgr.judgeIsOpen(self.exchange_activityID, true) then
		_ENV = nil
		;(nil).id = self.exchange_activityID
		uiManager:show("ExchangeEventPage", nil)
	end
end
return Activity_9001588_MainPanel
