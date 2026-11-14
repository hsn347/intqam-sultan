local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001564_Ctrl = SoraDGetCtrl("activity_9001564_Ctrl")
local newLotteryRead = include("newLotteryRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001564_MainPanel = class("Activity_9001564_MainPanel", baseFguiPanel)
function Activity_9001564_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001564_MainPanel:ctor", self.viewName)
end
function Activity_9001564_MainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001564_MainPanel:onInit()
	print("=======Activity_9001564_MainPanel:onInit")
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001564
	self.exchange_activityID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001554
	self.itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
	self.fields.Com_title:initData(i18n("activity_name_9001564"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
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
function Activity_9001564_MainPanel:onShow()
	print("=======Activity_9001564_MainPanel:onShow", self.itemID)
	SoraDShowLoading(self)
	activity_9001564_Ctrl:reqCommonLottery9001564Init()
end
function Activity_9001564_MainPanel:updateButton()
	_ENV = activity_9001564_Ctrl:getLuckyValue()
	activity_9001564_Ctrl:getLuckyValue().color = "#70C723"
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(activity_9001564_Ctrl:getLuckyValue()), activity_9001564_Ctrl:getLuckyValue())
	self.fields.Text_luckyValue:setString(i18n("nebulaeroaming08") .. countStr)
	self.fields.Button_One:setCost(self.itemID, 1)
	self.fields.Button_Ten:setCost(self.itemID, 10)
	if activity_9001564_Ctrl:isFreeLottery() then
		self.fields.Button_One:setFree()
	end
end
function Activity_9001564_MainPanel:updateItemNum()
	self.fields.Com_have:updateNum()
end
function Activity_9001564_MainPanel:playLotteryAction(reward)
	self.fields.Usm_2:setVisible(true)
	self.fields.Usm_2:play(false)
	self.fields.touch_panel:setVisible(true)
	self.rewardGained = reward
end
function Activity_9001564_MainPanel:playUsm2EndBack()
	self.fields.Usm_2:setVisible(false)
	if self.rewardGained then
		_ENV = nil
		;(nil).reward = self.rewardGained
		uiManager:show("Activity_9001564_Gainaward", nil)
		self.rewardGained = nil
	end
	self.fields.touch_panel:setVisible(false)
end
function Activity_9001564_MainPanel:onClickPreaward()
	SoraDPlaySound()
	uiManager:show("Activity_9001564_Preaward")
end
function Activity_9001564_MainPanel:onClickOne()
	SoraDPlaySound()
	if activity_9001564_Ctrl:isFreeLottery() or backpackCtrl:getItemCount(self.itemID) >= 1 then
		SoraDShowLoading(self)
		activity_9001564_Ctrl:reqCommonLottery9001564Lottery(1)
	else
		self:jumpToGift()
	end
end
function Activity_9001564_MainPanel:onClickTen()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= 10 then
		SoraDShowLoading(self)
		activity_9001564_Ctrl:reqCommonLottery9001564Lottery(10)
	else
		self:jumpToGift()
	end
end
function Activity_9001564_MainPanel:jumpToGift()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001564_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	_ENV = nil
	;(nil).NUM = include("constantRead").getConstValue("MAX_LUCKYRATIO", 100)
	;(nil).content = i18n("nebulaeroaming01", nil)
	uiManager:show("RuleView", nil)
end
function Activity_9001564_MainPanel:btnExchangeShopClick()
	SoraDPlaySound()
	print("跳转到对应兑换商城======")
	if clientEventMgr.judgeIsOpen(self.exchange_activityID, true) then
		_ENV = nil
		;(nil).id = self.exchange_activityID
		uiManager:show("ExchangeEventPage", nil)
	end
end
return Activity_9001564_MainPanel
