local baseProxy = require("fgui.base.baseProxy")
local combinationViewProxy = class("combinationViewProxy", baseProxy)
function combinationViewProxy:onRegisterEvent()
	print("=======combinationViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_REFRESH_COMBINATION", handler(self, self.updateConbination))
end
function combinationViewProxy:updateConbination()
	self.view:updateConbination()
end
return combinationViewProxy
