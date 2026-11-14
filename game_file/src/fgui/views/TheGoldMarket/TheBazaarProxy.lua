local baseProxy = require("fgui.base.baseProxy")
local TheBazaarProxy = class("TheBazaarProxy", baseProxy)
function TheBazaarProxy:onRegisterEvent()
	print("=======TheBazaarProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_GOLDSOUK_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function TheBazaarProxy:updateView()
	self.view:initData()
end
function TheBazaarProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GOLD_SOUK_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return TheBazaarProxy
