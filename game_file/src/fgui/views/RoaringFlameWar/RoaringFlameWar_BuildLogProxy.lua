local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWar_BuildLogProxy = class("RoaringFlameWar_BuildLogProxy", baseProxy)
function RoaringFlameWar_BuildLogProxy:onRegisterEvent()
	print("=======RoaringFlameWar_BuildLogProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUILD_LOG", handler(self, self.onMsgUpdateBuildLog))
end
function RoaringFlameWar_BuildLogProxy:onMsgUpdateBuildLog(...)
	self.view:onMsgUpdateBuildLog(...)
end
return RoaringFlameWar_BuildLogProxy
