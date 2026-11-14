local baseProxy = require("fgui.base.baseProxy")
local HeroReforgeProxy = class("HeroReforgeProxy", baseProxy)
function HeroReforgeProxy:onRegisterEvent()
	print("=======HeroReforgeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
end
function HeroReforgeProxy:updateView()
	self.view:updateView()
end
return HeroReforgeProxy
