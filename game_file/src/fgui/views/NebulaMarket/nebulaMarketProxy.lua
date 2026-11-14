local baseProxy = require("fgui.base.baseProxy")
local nebulaMarketProxy = class("nebulaMarketProxy", baseProxy)
function nebulaMarketProxy:onRegisterEvent()
	print("=======nebulaMarketProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.closeLoading))
end
function nebulaMarketProxy:updateView()
	if self.view then
		self.view:updateView()
	end
end
function nebulaMarketProxy:closeLoading()
	print("maybe have some error")
	SoraDCloseLoading(display.object)
	if self.view then
		self.view:closeLoading()
	end
end
function nebulaMarketProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return nebulaMarketProxy
