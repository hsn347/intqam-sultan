local baseProxy = require("fgui.base.baseProxy")
local SeedCultivateChooseProxy = class("SeedCultivateChooseProxy", baseProxy)
function SeedCultivateChooseProxy:onRegisterEvent()
	print("=======SeedCultivateChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_MERGE", handler(self, self.onFarmlandMergeSeed))
end
function SeedCultivateChooseProxy:onFarmlandMergeSeed(target, data)
	if data.failed then
		self.view:initData()
		self.view.fields.btnGo:setEnabled(true)
	end
end
return SeedCultivateChooseProxy
