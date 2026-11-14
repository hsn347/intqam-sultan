local baseProxy = require("fgui.base.baseProxy")
local FarmPlantProxy = class("FarmPlantProxy", baseProxy)
function FarmPlantProxy:onRegisterEvent()
	print("=======FarmPlantProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_BACKPACK_UPDATE", handler(self, self.onSeedListUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_UPDATE", handler(self, self.onFarmlandUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_PLANT", handler(self, self.removeFakePlant))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_PICK_ALL", handler(self, self.autoReplant))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_USE_SEEDPACK", handler(self, self.onSeedListUpdate))
end
function FarmPlantProxy:removeFakePlant(target, data, iid)
	if iid then
		self.view.fakePlants[iid] = nil
	else
		self.view.fakePlants, _UPVALUE0_ = nil, nil
		self.view:saveFakePlant()
	end
	self.view:initData()
end
function FarmPlantProxy:onFarmlandUpdate(target, data)
	self.view:initData()
end
function FarmPlantProxy:onSeedListUpdate(target, data)
	self.view:initData()
end
function FarmPlantProxy:autoReplant()
	self.view:autoReplant()
end
return FarmPlantProxy
