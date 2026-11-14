local troopsExchangeCtrl = SoraDGetCtrl("troopsExchangeCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local troopsExchangeMainPanel = class("troopsExchangeMainPanel", basePanel)
_ENV, troopsExchangeMainPanel.ctor = function(self, ...)
	self.super.ctor(self, ...)
	self.debug = true
end, function(self, ...)
	self.super.ctor(self, ...)
	self.debug = true
end
;(function(self, ...)
	self.super.ctor(self, ...)
	self.debug = true
end)[gActivityTimeActivityID.BATTLEFIELD_TRAINING] = "troopsExchangeTask"
;(function(self, ...)
	self.super.ctor(self, ...)
	self.debug = true
end)[gActivityTimeActivityID.PREFERENTIAL_SHOP_ACTIVITY] = "troopsExchangeShop"
;(function(self, ...)
	self.super.ctor(self, ...)
	self.debug = true
end)[gActivityTimeActivityID.ARMY_TRANSFER_ACTIVTY] = "armyTransferMain"
local (function(self, ...)
	self.super.ctor(self, ...)
	self.debug = true
end)[gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY], panelName = "troopsExchangeGem", function(self, ...)
	self.super.ctor(self, ...)
	self.debug = true
end
function troopsExchangeMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function troopsExchangeMainPanel:onInit()
	self.fields.com_Title:initData(i18n("armyExchange_text_025"), handler(self, self.onClickClose), handler(self, self.helpCallback))
	self.fields.scroll:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function troopsExchangeMainPanel:onShow()
	self:updateScroll()
end
function troopsExchangeMainPanel:updateScroll()
	self.activityList, _ENV = nil, nil
	for activityID, _ in pairs(activityShowCtrl:getActivityGroup(gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY)) do
		if clientEventMgr.judgeIsOpen(activityID) then
			table.insert(self.activityList, activityID)
		end
	end
	self.fields.scroll:setNumItems(#self.activityList)
end
function troopsExchangeMainPanel:onItemRenderer(index, object)
	object:initData(self.activityList[index + 1])
	object:setReddot(troopsExchangeCtrl:getReddotNum(self.activityList[index + 1]))
end
function troopsExchangeMainPanel:onClickItem()
	SoraDPlaySound()
	local index = self.fields.scroll:getSelectedIndex() + 1
	uiManager:show(panelName[self.activityList[index]])
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityList[index])
end
function troopsExchangeMainPanel:helpCallback(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("armyExchange_text_045")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return troopsExchangeMainPanel
