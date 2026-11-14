local baseProxy = require("fgui.base.baseProxy")
local angerSnowWolfMainProxy = class("angerSnowWolfMainProxy", baseProxy)
function angerSnowWolfMainProxy:onRegisterEvent()
	print("=======angerSnowWolfMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_ENTRANCE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_REFRESHINFO", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_UPDATEACTIVESTATUS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_SNOW_WOLF_KING_UPDATETIPS", handler(self, self.initData))
end
function angerSnowWolfMainProxy:judgeEventClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function angerSnowWolfMainProxy:initData(target, data)
	self.view:initData(target, data)
end
return angerSnowWolfMainProxy
