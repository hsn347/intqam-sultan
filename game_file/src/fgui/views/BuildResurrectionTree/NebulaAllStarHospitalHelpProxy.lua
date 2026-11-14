local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarHospitalHelpProxy = class("NebulaAllStarHospitalHelpProxy", baseProxy)
function NebulaAllStarHospitalHelpProxy:onRegisterEvent()
	print("=======NebulaAllStarHospitalHelpProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_TOTAL_ARMY", handler(self, self.onMsgUpdateTotalArmy))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_CURE_ARMY", handler(self, self.onMsgUpdateCureArmy))
end
function NebulaAllStarHospitalHelpProxy:onMsgUpdateTotalArmy(...)
	self.view:updateTotalArmy(...)
end
function NebulaAllStarHospitalHelpProxy:onMsgUpdateCureArmy(...)
	self.view:updateCureArmy(...)
end
return NebulaAllStarHospitalHelpProxy
