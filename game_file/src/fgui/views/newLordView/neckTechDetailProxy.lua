local baseProxy = require("fgui.base.baseProxy")
local neckTechDetailProxy = class("neckTechDetailProxy", baseProxy)
function neckTechDetailProxy:onRegisterEvent()
	print("=======neckTechDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NECKLACE_TECHNOLOGY_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
end
function neckTechDetailProxy:updateView()
	self.view:updateView()
end
return neckTechDetailProxy
