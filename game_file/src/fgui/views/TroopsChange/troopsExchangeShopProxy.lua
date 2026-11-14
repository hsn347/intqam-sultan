local baseProxy = require("fgui.base.baseProxy")
local troopsExchangeShopProxy = class("troopsExchangeShopProxy", baseProxy)
function troopsExchangeShopProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.updataScroll))
end
function troopsExchangeShopProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PREFERENTIAL_SHOP_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function troopsExchangeShopProxy:updataScroll(target, data)
	SoraDCloseLoading(self)
	self.view:updataScroll()
	self.view:updateItemsNum()
end
return troopsExchangeShopProxy
