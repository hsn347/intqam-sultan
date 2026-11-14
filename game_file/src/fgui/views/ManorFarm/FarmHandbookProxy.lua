local baseProxy = require("fgui.base.baseProxy")
local FarmHandbookProxy = class("FarmHandbookProxy", baseProxy)
function FarmHandbookProxy:onRegisterEvent()
	print("=======FarmHandbookProxy:onRegisterEvent")
	SoraDAddMessage("MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT_PICK", handler(self, self.onCultivateFruitPick))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_LV_UP", handler(self, self.onMsgBuildLvUp))
end
function FarmHandbookProxy:onCultivateFruitPick()
	self.view:updateReddot()
end
function FarmHandbookProxy:onMsgBuildLvUp()
	self.view:updateFruitCultivate()
end
return FarmHandbookProxy
