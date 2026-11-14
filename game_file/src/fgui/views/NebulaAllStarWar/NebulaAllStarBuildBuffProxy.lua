local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarBuildBuffProxy = class("NebulaAllStarBuildBuffProxy", baseProxy)
function NebulaAllStarBuildBuffProxy:onRegisterEvent()
	print("=======NebulaAllStarBuildBuffProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_CAMP_BUILDING_COUNT", handler(self, self.onMsgUpdateBuildingCount))
end
function NebulaAllStarBuildBuffProxy:onMsgUpdateBuildingCount(...)
	self.view:onMsgUpdateBuildingCount(...)
end
return NebulaAllStarBuildBuffProxy
