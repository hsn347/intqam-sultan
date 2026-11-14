local baseProxy = require("fgui.base.baseProxy")
local allianceOptionsViewProxy = class("allianceOptionsViewProxy", baseProxy)
function allianceOptionsViewProxy:onRegisterEvent()
	print("=======allianceOptionsViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_JOIN_OPTIONS_SELECT", handler(self, self.uiOptionsBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_ALLIANCE_LIST_SUCCESS", handler(self, self.isCloseSelf))
end
function allianceOptionsViewProxy:uiOptionsBack(target, data)
	self.view:uiOptionsBack(target, data)
end
function allianceOptionsViewProxy:isCloseSelf(target, data)
	if data and data.err == gErrDef.Err_None then
		self.view:close()
	end
end
return allianceOptionsViewProxy
