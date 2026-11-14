local baseProxy = require("fgui.base.baseProxy")
local DessertMasterActivityProxy = class("DessertMasterActivityProxy", baseProxy)
function DessertMasterActivityProxy:onRegisterEvent()
	print("=======DessertMasterActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_INIT", handler(self, self.onInit))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_DRAW", handler(self, self.onBake))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_SPECIAL_DRAW", handler(self, self.onTaste))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_DEL", handler(self, self.onDel))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemCountChange))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_TIMEOUT", handler(self, self.onTimeout))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_CHOOSE", handler(self, self.onChoose))
end
function DessertMasterActivityProxy:onChoose()
	self.view:updateBtnPool()
end
function DessertMasterActivityProxy:onInit()
	self.view:updateView()
end
function DessertMasterActivityProxy:onTimeout(target, data)
	dump(data, "onTimeout", 10)
	self.view:onTimeout(data.index)
end
function DessertMasterActivityProxy:onBake(target, data)
	self.view:onBake(data)
end
function DessertMasterActivityProxy:onTaste()
	self.view:updateView()
end
function DessertMasterActivityProxy:onDel()
	self.view:updateView()
end
function DessertMasterActivityProxy:onItemCountChange()
	self.view:updateCoffeeCount()
	self.view:updateCount()
end
function DessertMasterActivityProxy:onRemoveView()
	print("=======DessertMasterActivityProxy:onRemoveView")
end
return DessertMasterActivityProxy
