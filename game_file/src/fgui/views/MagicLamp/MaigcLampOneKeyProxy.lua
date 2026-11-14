local baseProxy = require("fgui.base.baseProxy")
local MaigcLampOneKeyProxy = class("MaigcLampOneKeyProxy", baseProxy)
function MaigcLampOneKeyProxy:onRegisterEvent()
	print("=======MaigcLampOneKeyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_HATCH_UPDATE", handler(self, self.msgUpdateView))
end
function MaigcLampOneKeyProxy:msgUpdateView(target, msgdata)
	self.view:updateView()
end
return MaigcLampOneKeyProxy
