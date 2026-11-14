local baseProxy = require("fgui.base.baseProxy")
local FarmHelpRecordProxy = class("FarmHelpRecordProxy", baseProxy)
function FarmHelpRecordProxy:onRegisterEvent()
	print("=======FarmHelpRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_INIT", handler(self, self.onMapInit))
end
function FarmHelpRecordProxy:onMapInit()
	self.view:close()
end
return FarmHelpRecordProxy
