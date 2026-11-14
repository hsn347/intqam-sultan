local armyTransferCtrl = SoraDGetCtrl("armyTransferCtrl")
local gemExchangeCtrl = SoraDGetCtrl("gemExchangeCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local troopsExchangeLogPanel = class("troopsExchangeLogPanel", basePanel)
function troopsExchangeLogPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function troopsExchangeLogPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function troopsExchangeLogPanel:onInit()
	self.fields.Text_NoLog:setString(i18n("common_text_1464"))
	self.fields.scroll_log:setItemRenderer(handler(self, self.onItemRenderer))
end
function troopsExchangeLogPanel:onShow()
	self.logType = self.proxy.param.type
	SoraDShowLoading()
	if self.logType == 0 then
		gemExchangeCtrl:reqGemExchangeRecord()
		self.fields.panel_normal:setTitle(i18n("armyExchange_text_018"))
	else
		armyTransferCtrl:reqArmyTransferRecord()
		self.fields.panel_normal:setTitle(i18n("armyExchange_text_001"))
	end
end
function troopsExchangeLogPanel:updateScroll()
	self.record = self.logType == 0 and gemExchangeCtrl:getHistoryList() or armyTransferCtrl:getHistoryList()
	self.controllers.c1:setSelectedIndex(#self.record <= 0 and 1 or 0)
	self.fields.scroll_log:setNumItems(#self.record)
end
function troopsExchangeLogPanel:onItemRenderer(index, object)
	object:initData(self.record[index + 1], self.logType, index)
end
return troopsExchangeLogPanel
