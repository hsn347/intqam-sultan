local activityExchangeMallRead = include("activityExchangeMallRead")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExchangeRunePagePanel = class("ExchangeRunePagePanel", baseFguiPanel)
function ExchangeRunePagePanel:ctor(...)
	self.super.ctor(self, ...)
	print("ExchangeRunePagePanel:ctor", self.viewName)
end
function ExchangeRunePagePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ExchangeRunePagePanel:onInit()
	print("=======ExchangeRunePagePanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001532"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRenderer))
end
function ExchangeRunePagePanel:onShow()
	print("=======ExchangeRunePagePanel:onShow")
	_ENV = print
	self.otherData, print.activityID = print, gActivityTimeActivityID.RUNE_EXCHANGE_MALL
	self:initData()
end
function ExchangeRunePagePanel:initData()
	self.tableData = activityExchangeMallRead.getShopItemListFromOri(gActivityTimeActivityID.RUNE_EXCHANGE_MALL)
	self.fields.List_exchange:setNumItems(#self.tableData)
	self:updateTime()
end
function ExchangeRunePagePanel:updateTime()
	local nextRefreshTime = SoraDGetSpecialActivityRefreshTime(gActivityTimeActivityID.RUNE_EXCHANGE_MALL)
	if nextRefreshTime and nextRefreshTime - serviceFunctions.systemTime() > 0 then
		self.fields.Com_title:setTimeShow(true)
		_ENV = nil
		;(nil).time = ""
		self.fields.Com_title:initSpecialActivityTime(nextRefreshTime - serviceFunctions.systemTime(), i18n("common_text_4720", nil))
	else
		self.fields.Com_title:setTimeShow(false)
	end
end
function ExchangeRunePagePanel:onItemRenderer(index, object)
	object:initData(self.tableData[index + 1], self.otherData)
end
function ExchangeRunePagePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("common_text_4719")
	uiManager:show("RuleView", nil)
end
return ExchangeRunePagePanel
