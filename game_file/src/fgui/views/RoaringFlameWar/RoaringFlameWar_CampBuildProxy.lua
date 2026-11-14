local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWar_CampBuildProxy = class("RoaringFlameWar_CampBuildProxy", baseProxy)
function RoaringFlameWar_CampBuildProxy:onRegisterEvent()
	print("=======RoaringFlameWar_CampBuildProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUILD_LIST", handler(self, self.onMsgUpdateBuildList))
end
function RoaringFlameWar_CampBuildProxy:onMsgUpdateBuildList(...)
	self.view:onMsgUpdateBuildList(...)
end
return RoaringFlameWar_CampBuildProxy
