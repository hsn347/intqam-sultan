local baseProxy = require("fgui.base.baseProxy")
local ManorTechViewProxy = class("ManorTechViewProxy", baseProxy)
function ManorTechViewProxy:onRegisterEvent()
	print("=======ManorTechViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TECH_QUEUE", handler(self, self.updateStudy))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateStudy))
end
function ManorTechViewProxy:updateStudy(target, data)
	self.view:updateStudy(target, data)
end
return ManorTechViewProxy
