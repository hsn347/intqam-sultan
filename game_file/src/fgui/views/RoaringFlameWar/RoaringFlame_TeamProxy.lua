local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_TeamProxy = class("RoaringFlame_TeamProxy", baseProxy)
function RoaringFlame_TeamProxy:onRegisterEvent()
	print("=======RoaringFlame_TeamProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_GET_MANAGER_INFO", handler(self, self.onMsgGetManagerInfo))
end
function RoaringFlame_TeamProxy:onMsgGetManagerInfo(...)
	self.view:onMsgGetManagerInfo(...)
end
return RoaringFlame_TeamProxy
