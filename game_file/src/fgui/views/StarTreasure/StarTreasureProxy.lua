local baseProxy = require("fgui.base.baseProxy")
local StarTreasureProxy = class("StarTreasureProxy", baseProxy)
function StarTreasureProxy:onRegisterEvent()
	print("=======StarTreasureProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_STAR_TREASURE_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function StarTreasureProxy:refreshView(target, data)
	if self.view then
		dump(data, "StarTreasureProxy:refreshV")
		self.view:refreshView(data)
	end
end
function StarTreasureProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STAR_TREASURE_EXPLORE) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return StarTreasureProxy
