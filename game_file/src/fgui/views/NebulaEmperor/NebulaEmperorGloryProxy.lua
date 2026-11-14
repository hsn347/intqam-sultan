local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorGloryProxy = class("NebulaEmperorGloryProxy", baseProxy)
function NebulaEmperorGloryProxy:onRegisterEvent()
	print("=======NebulaEmperorGloryProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_GLORY_DATA", handler(self, self.onMsgReqGloryData))
end
function NebulaEmperorGloryProxy:onMsgReqGloryData(...)
	self.view:onMsgReqGloryData(...)
end
return NebulaEmperorGloryProxy
