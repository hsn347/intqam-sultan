local baseProxy = require("fgui.base.baseProxy")
local FarmBagProxy = class("FarmBagProxy", baseProxy)
function FarmBagProxy:onRegisterEvent()
	print("=======FarmBagProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_USE_SEEDPACK", handler(self, self.onFarmlandUseSeedPack))
end
function FarmBagProxy:onFarmlandUseSeedPack(target, data)
	self.view:initData(self.view.fields.comTab.curTab)
end
return FarmBagProxy
