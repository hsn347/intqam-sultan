local baseProxy = require("fgui.base.baseProxy")
local ManorTechDetailProxy = class("ManorTechDetailProxy", baseProxy)
function ManorTechDetailProxy:onRegisterEvent()
	print("=======ManorTechDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TECH_QUEUE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateView))
end
function ManorTechDetailProxy:updateView()
	self.view:updateView()
end
return ManorTechDetailProxy
