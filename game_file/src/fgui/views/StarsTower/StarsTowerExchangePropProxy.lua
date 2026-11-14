local baseProxy = require("fgui.base.baseProxy")
local StarsTowerExchangePropProxy = class("StarsTowerExchangePropProxy", baseProxy)
function StarsTowerExchangePropProxy:onRegisterEvent()
	print("=======StarsTowerExchangePropProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function StarsTowerExchangePropProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STARLIGHT_PAVILION_ACTIVITY) then
		self.view:close()
	end
end
return StarsTowerExchangePropProxy
