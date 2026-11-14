local baseProxy = require("fgui.base.baseProxy")
local BeachHuntViewProxy = class("BeachHuntViewProxy", baseProxy)
function BeachHuntViewProxy:onRegisterEvent()
	print("=======BeachHuntViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_BEACH_HUNT_DIGBAKE", handler(self, self.digBake))
	SoraDAddMessage(self, "MESSAGE_BEACH_HUNT_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GET_EXTRA_SUCCESS", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function BeachHuntViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function BeachHuntViewProxy:digBake(target, data)
	self.view:digBake(target, data)
end
function BeachHuntViewProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY) or param.curState ~= ACTIVITY_STATE.ACTIVE then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return BeachHuntViewProxy
