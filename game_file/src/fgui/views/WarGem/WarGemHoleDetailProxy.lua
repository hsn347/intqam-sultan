local baseProxy = require("fgui.base.baseProxy")
local WarGemHoleDetailProxy = class("WarGemHoleDetailProxy", baseProxy)
function WarGemHoleDetailProxy:onRegisterEvent()
	print("=======WarGemHoleDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_REFREASH_ENCHANTED", handler(self, self.onEnchant))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_CHANGE_COLOR", handler(self, self.onChangeColor))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_REFREASH_ESSENCE", handler(self, self.onEssenceRefresh))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemCountChange))
end
function WarGemHoleDetailProxy:onChangeColor()
	self:removeView(self.view)
end
function WarGemHoleDetailProxy:onEnchant()
	self.view:updateView()
end
function WarGemHoleDetailProxy:onEssenceRefresh()
	self.view:updateEnchant()
end
function WarGemHoleDetailProxy:onItemCountChange()
	self.view:updateEnchant()
end
return WarGemHoleDetailProxy
