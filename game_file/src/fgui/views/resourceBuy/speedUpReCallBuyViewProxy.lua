local baseProxy = require("fgui.base.baseProxy")
local speedUpReCallBuyViewProxy = class("speedUpReCallBuyViewProxy", baseProxy)
function speedUpReCallBuyViewProxy:onRegisterEvent()
	print("=======speedUpReCallBuyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_SPEEDUP", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_ARMY_SPEEDUP_TIMEREFRESH", handler(self, self.updateTimeRefesh))
	SoraDAddMessage(self, "MESSAGE_ARMY_WORLDMAPCONTROL_CLOSEWINDOW", handler(self, self.closeMe))
end
function speedUpReCallBuyViewProxy:update(target, data)
	self.view:update(target, data)
end
function speedUpReCallBuyViewProxy:refreshData(target, data)
	self.view:refreshData(target, data)
end
function speedUpReCallBuyViewProxy:updateTimeRefesh(target, data)
	self.view:updateTimeRefesh(target, data)
end
function speedUpReCallBuyViewProxy:closeMe(target, data)
	self.view:closeMe(target, data)
end
return speedUpReCallBuyViewProxy
