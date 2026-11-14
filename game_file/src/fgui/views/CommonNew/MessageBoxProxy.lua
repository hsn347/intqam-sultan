local baseProxy = require("fgui.base.baseProxy")
local MessageBoxProxy = class("MessageBoxProxy", baseProxy)
function MessageBoxProxy:ctor(...)
	self.super.ctor(self, ...)
	self.addMode = UI_ADD_MODE.Single
end
function MessageBoxProxy:onRegisterEvent()
	print("=======MessageBoxProxy:onRegisterEvent")
end
function MessageBoxProxy:onRemoveView()
	print("=======MessageBoxProxy:onRemoveView")
end
return MessageBoxProxy
