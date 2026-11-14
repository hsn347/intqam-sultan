local baseProxy = require("fgui.base.baseProxy")
local GetWayPopBoxProxy = class("GetWayPopBoxProxy", baseProxy)
function GetWayPopBoxProxy:onRegisterEvent()
	print("=======GetWayPopBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COMMON_BOX_CLOSE", handler(self, self.closeSelf))
end
function GetWayPopBoxProxy:closeSelf()
	if self.view then
		self.view:close()
	end
end
return GetWayPopBoxProxy
