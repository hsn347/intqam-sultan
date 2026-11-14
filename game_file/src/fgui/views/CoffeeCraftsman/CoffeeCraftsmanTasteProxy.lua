local baseProxy = require("fgui.base.baseProxy")
local CoffeeCraftsmanTasteProxy = class("CoffeeCraftsmanTasteProxy", baseProxy)
function CoffeeCraftsmanTasteProxy:onRegisterEvent()
	print("=======CoffeeCraftsmanTasteProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_SPECIAL_DRAW", handler(self, self.onTaste))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_DEL", handler(self, self.onDel))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_TIMEOUT", handler(self, self.onTimeout))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemCountChange))
end
function CoffeeCraftsmanTasteProxy:onItemCountChange()
	self.view:updateSpoon()
end
function CoffeeCraftsmanTasteProxy:onTimeout()
	self:removeAllView()
end
function CoffeeCraftsmanTasteProxy:onDel()
	self:removeAllView()
end
function CoffeeCraftsmanTasteProxy:onTaste()
	self:removeAllView()
end
function CoffeeCraftsmanTasteProxy:onRemoveView()
	print("=======CoffeeCraftsmanTasteProxy:onRemoveView")
end
return CoffeeCraftsmanTasteProxy
