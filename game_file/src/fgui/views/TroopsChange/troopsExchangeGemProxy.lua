local baseProxy = require("fgui.base.baseProxy")
local troopsExchangeGem = class("troopsExchangeGem", baseProxy)
function troopsExchangeGem:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_TROOPS_EXCHANGE_REFRESH", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updataView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updataView))
end
function troopsExchangeGem:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function troopsExchangeGem:updateScroll(target, data)
	if data.activityID == gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY then
		self.view:updatTaskScroll()
	end
end
function troopsExchangeGem:updataView()
	self.view:updatTaskScroll()
	self.view:updateRedPoint()
	self.view:updateItemsNum()
end
return troopsExchangeGem
