local baseProxy = require("fgui.base.baseProxy")
local equipBaptizeSetViewProxy = class("equipBaptizeSetViewProxy", baseProxy)
function equipBaptizeSetViewProxy:onRegisterEvent()
	print("=======equipBaptizeSetViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_ATTRIBUTE_SET", handler(self, self.updateView))
end
function equipBaptizeSetViewProxy:updateView()
	self.view:updateView()
end
return equipBaptizeSetViewProxy
