local baseProxy = require("fgui.base.baseProxy")
local ThemTakeUIProxy = class("ThemTakeUIProxy", baseProxy)
function ThemTakeUIProxy:onRegisterEvent()
	print("=======ThemTakeUIProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LOUDLYDRESS_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ThemTakeUIProxy:updateView()
	self.view:initData(true)
end
function ThemTakeUIProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LOUDLY_DRESSED_ACTIVITY) then
		self.view:close()
	end
end
return ThemTakeUIProxy
