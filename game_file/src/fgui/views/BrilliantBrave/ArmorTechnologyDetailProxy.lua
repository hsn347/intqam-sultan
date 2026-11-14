local baseProxy = require("fgui.base.baseProxy")
local ArmorTechnologyDetailProxy = class("ArmorTechnologyDetailProxy", baseProxy)
function ArmorTechnologyDetailProxy:onRegisterEvent()
	print("=======ArmorTechnologyDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.speedBack))
end
function ArmorTechnologyDetailProxy:speedBack(target, data)
	if data.qtype == self.view.queueType then
		self.view:updateView()
	end
end
function ArmorTechnologyDetailProxy:updateView()
	self.view:updateView()
end
return ArmorTechnologyDetailProxy
