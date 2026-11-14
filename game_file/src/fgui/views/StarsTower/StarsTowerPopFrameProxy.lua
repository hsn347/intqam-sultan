local baseProxy = require("fgui.base.baseProxy")
local StarsTowerPopFrameProxy = class("StarsTowerPopFrameProxy", baseProxy)
function StarsTowerPopFrameProxy:onRegisterEvent()
	print("=======StarsTowerPopFrameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.closeView))
end
function StarsTowerPopFrameProxy:closeView(target, data)
	self.view:close()
end
return StarsTowerPopFrameProxy
