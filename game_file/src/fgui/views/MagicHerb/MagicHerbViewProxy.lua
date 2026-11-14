local baseProxy = require("fgui.base.baseProxy")
local MagicHerbViewProxy = class("MagicHerbViewProxy", baseProxy)
function MagicHerbViewProxy:onRegisterEvent()
	print("=======MagicHerbViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateTaskView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MAGICHERB_UPDATE", handler(self, self.updateIrrigateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_QUEST_DATA", handler(self, self.updateView))
end
function MagicHerbViewProxy:updateView(target, data)
	dump(data, "MagicHerbViewProxy:updateView=====", 10)
	if data.activityID == gActivityTimeActivityID.MAGIC_HERB_ACTIVITY then
		SoraDCloseLoading(self.view:displayObject())
		self.view:updateTaskView()
		self.view:updateIrrigateView()
	end
end
function MagicHerbViewProxy:updateIrrigateView(target, data)
	dump(data, "MagicHerbViewProxy:updateIrrigateView=====", 10)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateIrrigateView(data.isIrrigate)
end
function MagicHerbViewProxy:updateTaskView(target, data)
	dump(data, "MagicHerbViewProxy:updateTaskView=====", 10)
	if data.activityID == gActivityTimeActivityID.MAGIC_HERB_ACTIVITY then
		SoraDCloseLoading(self.view:displayObject())
		self.view:updateTaskView()
	end
end
function MagicHerbViewProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MAGIC_HERB_ACTIVITY) then
		self.view:close()
	end
end
return MagicHerbViewProxy
