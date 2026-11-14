local baseProxy = require("fgui.base.baseProxy")
local FruitCultivateProxy = class("FruitCultivateProxy", baseProxy)
function FruitCultivateProxy:onRegisterEvent()
	print("=======FruitCultivateProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT", handler(self, self.onFruitCultivateUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT_PICK", handler(self, self.onFruitCultivatePick))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_FRUIT_TIME_END", handler(self, self.onFruitCultivateProduce))
end
function FruitCultivateProxy:onFruitCultivateUpdate()
	self.view:initData()
end
function FruitCultivateProxy:onFruitCultivatePick()
	SoraDCloseLoading(self.view)
	self.view:initData()
end
function FruitCultivateProxy:onFruitCultivateProduce()
	self.view:initData(true)
end
return FruitCultivateProxy
