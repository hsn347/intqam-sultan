local baseProxy = require("fgui.base.baseProxy")
local SeedCultivateProxy = class("SeedCultivateProxy", baseProxy)
function SeedCultivateProxy:onRegisterEvent()
	print("=======SeedCultivateProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_MERGE", handler(self, self.onSeedCultivateUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_CULTIVATE_SEED_TIME_END", handler(self, self.onSeedCultivateUpdate))
end
function SeedCultivateProxy:onSeedCultivateUpdate()
	self.view:initData()
end
return SeedCultivateProxy
