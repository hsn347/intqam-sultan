local baseProxy = require("fgui.base.baseProxy")
local evilPalaceInfoViewProxy = class("evilPalaceInfoViewProxy", baseProxy)
function evilPalaceInfoViewProxy:onRegisterEvent()
	print("=======evilPalaceInfoViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.initView))
end
function evilPalaceInfoViewProxy:initView(target, data)
	self.view:initView()
end
return evilPalaceInfoViewProxy
