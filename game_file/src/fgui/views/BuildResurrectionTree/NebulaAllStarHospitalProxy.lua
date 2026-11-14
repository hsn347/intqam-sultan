local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarHospitalProxy = class("NebulaAllStarHospitalProxy", baseProxy)
function NebulaAllStarHospitalProxy:onRegisterEvent()
	print("=======NebulaAllStarHospitalProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_CURE_ARMY", handler(self, self.onMsgUpdateCureArmy))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_BANDAGE_COUNT", handler(self, self.onMsgUpdateBandageCount))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_WOUNDED_ARMY", handler(self, self.onMsgUpdateWoundedArmy))
end
function NebulaAllStarHospitalProxy:onMsgUpdateCureArmy(...)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateCureArmy(...)
end
function NebulaAllStarHospitalProxy:onMsgUpdateBandageCount(...)
	self.view:updateBandageCount(...)
end
function NebulaAllStarHospitalProxy:onMsgUpdateWoundedArmy(...)
	self.view:updateWoundedArmy(...)
end
return NebulaAllStarHospitalProxy
