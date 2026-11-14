local baseProxy = require("fgui.base.baseProxy")
local WarGemHoleColorProxy = class("WarGemHoleColorProxy", baseProxy)
function WarGemHoleColorProxy:onRegisterEvent()
	print("=======WarGemHoleColorProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_CHANGE_COLOR", handler(self, self.onColorChange))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_CHANGE_COLOR_FAIL", handler(self, self.onColorChangeFail))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemCountChange))
end
function WarGemHoleColorProxy:onColorChange()
	SoraDCloseLoading(self.view:displayObject())
	self:removeView(self.view)
end
function WarGemHoleColorProxy:onColorChangeFail()
	SoraDCloseLoading(self.view:displayObject())
end
function WarGemHoleColorProxy:onItemCountChange()
	self.view:updateBtn()
end
return WarGemHoleColorProxy
