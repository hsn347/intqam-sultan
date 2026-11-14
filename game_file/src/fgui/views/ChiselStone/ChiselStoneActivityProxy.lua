local baseProxy = require("fgui.base.baseProxy")
local ChiselStoneActivityProxy = class("ChiselStoneActivityProxy", baseProxy)
function ChiselStoneActivityProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_CHISEL_STONE_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ChiselStoneActivityProxy:onUpdateTask(target, data)
	dump(data, "onUpdateTask")
	if data.activityID == gActivityTimeActivityID.CHISEL_STONE_ACTIVITY then
		SoraDCloseLoading()
		self.view:updatTaskScroll()
		self.view:updateRed()
	end
end
function ChiselStoneActivityProxy:onUpdateView()
	self.view:updateCurDay()
	self.view:updateRed()
end
function ChiselStoneActivityProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHISEL_STONE_ACTIVITY) then
		self.view:close()
	end
end
return ChiselStoneActivityProxy
