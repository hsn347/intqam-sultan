local baseProxy = require("fgui.base.baseProxy")
local RadiantDecreeMainProxy = class("RadiantDecreeMainProxy", baseProxy)
function RadiantDecreeMainProxy:onRegisterEvent()
	print("=======RadiantDecreeMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RADIANT_DECREE_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateTask))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateRed))
end
function RadiantDecreeMainProxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
function RadiantDecreeMainProxy:updateRed(target, data)
	if self.view then
		self.view:updateRed(data)
	end
end
function RadiantDecreeMainProxy:updateTask(target, data)
	if self.view then
		self.view:updateTask(data)
		self.view:initData()
	end
end
function RadiantDecreeMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY) and self.view then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RadiantDecreeMainProxy
