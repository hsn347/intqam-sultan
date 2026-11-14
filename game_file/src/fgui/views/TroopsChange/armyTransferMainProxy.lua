local baseProxy = require("fgui.base.baseProxy")
local armyTransferMainProxy = class("armyTransferMainProxy", baseProxy)
function armyTransferMainProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_TROOPS_EXCHANGE_REFRESH", handler(self, self.updataItemView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updataView))
end
function armyTransferMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ARMY_TRANSFER_ACTIVTY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function armyTransferMainProxy:updataItemView(target, data)
	if data.activityID == gActivityTimeActivityID.ARMY_TRANSFER_ACTIVTY then
		SoraDCloseLoading()
		self.view:updateItemsInfo()
	end
end
function armyTransferMainProxy:updataView(target, data)
	self.view:updateNum()
end
return armyTransferMainProxy
