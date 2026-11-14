local baseProxy = require("fgui.base.baseProxy")
local MoonAndTreasureMapProxy = class("MoonAndTreasureMapProxy", baseProxy)
function MoonAndTreasureMapProxy:onRegisterEvent()
	print("=======MoonAndTreasureMapProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_CROSS_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function MoonAndTreasureMapProxy:onUpdateTask(target, data)
	dump(data, "MoonAndTreasureMapProxy:onUpdateTask=====", 10)
	if data.index then
		self.view:playGZAction(data.index)
	else
		self.view:initData()
	end
end
function MoonAndTreasureMapProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CROSS_MISSION_2022_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return MoonAndTreasureMapProxy
