local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorAppointRTProxy = class("NebulaEmperorAppointRTProxy", baseProxy)
function NebulaEmperorAppointRTProxy:onRegisterEvent()
	print("=======NebulaEmperorAppointRTProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_SINGLE_TITLE", handler(self, self.onMsgUpdateSingleTitle))
end
function NebulaEmperorAppointRTProxy:onMsgUpdateSingleTitle(...)
	self.view:closePanel()
end
return NebulaEmperorAppointRTProxy
