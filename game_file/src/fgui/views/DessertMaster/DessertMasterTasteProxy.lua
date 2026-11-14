local baseProxy = require("fgui.base.baseProxy")
local DessertMasterTasteProxy = class("DessertMasterTasteProxy", baseProxy)
function DessertMasterTasteProxy:onRegisterEvent()
	print("=======DessertMasterTasteProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_SPECIAL_DRAW", handler(self, self.onTaste))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_DEL", handler(self, self.onDel))
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_TIMEOUT", handler(self, self.onTimeout))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemCountChange))
end
function DessertMasterTasteProxy:onItemCountChange()
	self.view:updateSpoon()
end
function DessertMasterTasteProxy:onTimeout()
	self:removeAllView()
end
function DessertMasterTasteProxy:onDel()
	self:removeAllView()
end
function DessertMasterTasteProxy:onTaste()
	self:removeAllView()
end
function DessertMasterTasteProxy:onRemoveView()
	print("=======DessertMasterTasteProxy:onRemoveView")
end
return DessertMasterTasteProxy
