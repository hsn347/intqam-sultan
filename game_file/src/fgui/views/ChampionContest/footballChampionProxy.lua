local baseProxy = require("fgui.base.baseProxy")
local footballChampionProxy = class("footballChampionProxy", baseProxy)
function footballChampionProxy:onRegisterEvent()
	print("=======footballChampionProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FOOTBALL_CHAMPION_REFRESH", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function footballChampionProxy:msgUpdateView(target, data)
	self.view:updateView()
end
function footballChampionProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FOOTBALL_CHAMPION_ACTIVITY) and self.view then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return footballChampionProxy
