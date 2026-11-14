local baseProxy = require("fgui.base.baseProxy")
local Activity_9001654_MainProxy = class("Activity_9001654_MainProxy", baseProxy)
function Activity_9001654_MainProxy:onRegisterEvent()
	print("=======Activity_9001654_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_DESERT_TREASURE_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_DESERT_TREASURE_GET", handler(self, self.getReward))
	SoraDAddMessage(self, "MESSAGE_DESERT_TREASURE_READY", handler(self, self.enterUsmReady))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
end
function Activity_9001654_MainProxy:initData(target, data)
	if self.view then
		self.view:initData(data)
	end
end
function Activity_9001654_MainProxy:getReward(target, data)
	if self.view then
		self.view:getReward(data)
	end
end
function Activity_9001654_MainProxy:enterUsmReady(target, data)
	if self.view then
		self.view:enterUsmReady(data)
	end
end
function Activity_9001654_MainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NORMAL_ACTIVITY_9001654) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001654_MainProxy
