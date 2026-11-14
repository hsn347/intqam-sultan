local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_SetZeroProxy = class("RoaringFlame_SetZeroProxy", baseProxy)
function RoaringFlame_SetZeroProxy:onRegisterEvent()
	print("=======RoaringFlame_SetZeroProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_GET_LV0_LIST", handler(self, self.onMsgGeLv0List))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_KICKPLAYERCOUNT", handler(self, self.onMsgUpdateKickPlayerCount))
end
function RoaringFlame_SetZeroProxy:onMsgGeLv0List(...)
	self.view:onMsgGeLv0List(...)
end
function RoaringFlame_SetZeroProxy:onMsgUpdateKickPlayerCount(...)
	self.view:onMsgUpdateKickPlayerCount(...)
end
return RoaringFlame_SetZeroProxy
