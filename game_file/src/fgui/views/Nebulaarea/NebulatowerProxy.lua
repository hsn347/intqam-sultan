local baseProxy = require("fgui.base.baseProxy")
local NebulatowerProxy = class("NebulatowerProxy", baseProxy)
function NebulatowerProxy:onRegisterEvent()
	print("=======NebulatowerProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_GET_TOWER_DATA", handler(self, self.updateView))
end
function NebulatowerProxy:updateView()
	if self.view then
		self.view:updateView()
	end
end
return NebulatowerProxy
