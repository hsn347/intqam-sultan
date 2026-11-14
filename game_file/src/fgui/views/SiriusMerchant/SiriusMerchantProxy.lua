local baseProxy = require("fgui.base.baseProxy")
local SiriusMerchantProxy = class("SiriusMerchantProxy", baseProxy)
function SiriusMerchantProxy:onRegisterEvent()
	print("=======SiriusMerchantProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001528_UPDATE", handler(self, self.msgRefreshView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgRefreshItemNum))
end
function SiriusMerchantProxy:msgRefreshView(target, data)
	self.view:updateView()
end
function SiriusMerchantProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function SiriusMerchantProxy:msgRefreshItemNum(target, data)
	self.view:updateButton()
end
return SiriusMerchantProxy
