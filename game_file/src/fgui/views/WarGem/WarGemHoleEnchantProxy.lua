local baseProxy = require("fgui.base.baseProxy")
local WarGemHoleEnchantProxy = class("WarGemHoleEnchantProxy", baseProxy)
function WarGemHoleEnchantProxy:onRegisterEvent()
	print("=======WarGemHoleEnchantProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_REFREASH_ENCHANTED", handler(self, self.onEnchant))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_REFREASH_ESSENCE", handler(self, self.onEssenceRefresh))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA_BAG", handler(self, self.onUpdateGemBag))
end
function WarGemHoleEnchantProxy:onEnchant(target, data)
	print("WarGemHoleEnchantProxy:onEnchant")
	self.view:onEnchant(target, data)
end
function WarGemHoleEnchantProxy:onEssenceRefresh()
	print("WarGemHoleEnchantProxy:onEssenceRefresh")
	self.view:updateEnchant()
end
function WarGemHoleEnchantProxy:onUpdateGemBag()
	print("WarGemHoleEnchantProxy:onBagUpdate")
	self.view:updateEnchant()
end
return WarGemHoleEnchantProxy
