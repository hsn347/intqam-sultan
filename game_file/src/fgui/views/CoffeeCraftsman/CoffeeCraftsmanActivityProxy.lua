local baseProxy = require("fgui.base.baseProxy")
local CoffeeCraftsmanActivityProxy = class("CoffeeCraftsmanActivityProxy", baseProxy)
function CoffeeCraftsmanActivityProxy:onRegisterEvent()
	print("=======CoffeeCraftsmanActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_INIT", handler(self, self.onInit))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_DRAW", handler(self, self.onBake))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_SPECIAL_DRAW", handler(self, self.onTaste))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_DEL", handler(self, self.onDel))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemCountChange))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_TIMEOUT", handler(self, self.onTimeout))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_CHOOSE", handler(self, self.onChoose))
end
function CoffeeCraftsmanActivityProxy:onChoose()
	self.view:updateBtnPool()
end
function CoffeeCraftsmanActivityProxy:onInit()
	self.view:updateView()
end
function CoffeeCraftsmanActivityProxy:onTimeout(target, data)
	dump(data, "onTimeout", 10)
	self.view:onTimeout(data.index)
end
function CoffeeCraftsmanActivityProxy:onBake(target, data)
	self.view:onBake(data)
end
function CoffeeCraftsmanActivityProxy:onTaste()
	self.view:updateView()
end
function CoffeeCraftsmanActivityProxy:onDel()
	self.view:updateView()
end
function CoffeeCraftsmanActivityProxy:onItemCountChange()
	self.view:updateCoffeeCount()
	self.view:updateCount()
end
function CoffeeCraftsmanActivityProxy:onRemoveView()
	print("=======CoffeeCraftsmanActivityProxy:onRemoveView")
end
return CoffeeCraftsmanActivityProxy
