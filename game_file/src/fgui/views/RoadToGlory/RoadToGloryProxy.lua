local baseProxy = require("fgui.base.baseProxy")
local RoadToGloryProxy = class("RoadToGloryProxy", baseProxy)
function RoadToGloryProxy:ctor(...)
	self.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.GLORY_ROAD_ACTIVITY
end
function RoadToGloryProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.itemChange))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.updataInfoData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initScrollTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initScrollTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.initScrollTask))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.canExchange))
end
function RoadToGloryProxy:updataInfoData(target, data)
	SoraDCloseLoading()
	if data.activityID == self.activityID then
		dump("updataInfoData", data)
		local info = data.initData
		self.view:updataInfoData(info)
	end
end
function RoadToGloryProxy:initScrollTask(target, data)
	if data.activityID == self.activityID then
		SoraDCloseLoading()
		self.view:reflashScroll()
	end
end
function RoadToGloryProxy:itemChange()
	self.view:itemChange()
end
function RoadToGloryProxy:canExchange()
	self.view:canExchange()
end
function RoadToGloryProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RoadToGloryProxy
