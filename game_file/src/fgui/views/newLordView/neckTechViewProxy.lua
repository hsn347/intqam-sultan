local baseProxy = require("fgui.base.baseProxy")
local neckTechViewProxy = class("neckTechViewProxy", baseProxy)
function neckTechViewProxy:onRegisterEvent()
	print("=======neckTechViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NECKLACE_TECHNOLOGY_UPDATE", handler(self, self.initView))
end
function neckTechViewProxy:initView()
	self.view:initView()
end
return neckTechViewProxy
