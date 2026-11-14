local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameActivity_MainProxy = class("RoaringFlameActivity_MainProxy", baseProxy)
function RoaringFlameActivity_MainProxy:onRegisterEvent()
	print("=======RoaringFlameActivity_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_ACTIVITY_NEW", handler(self, self.onMsgUpdateActivityNew))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_PHOENIX_LIST", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_TURNTABLE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_ACTIVITY_RED", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_COLLECT", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_CAVE", handler(self, self.updateView))
end
function RoaringFlameActivity_MainProxy:onMsgUpdateActivityNew(...)
	self.view:onMsgUpdateActivityNew(...)
end
function RoaringFlameActivity_MainProxy:updateView(...)
	self.view:updateView(...)
end
return RoaringFlameActivity_MainProxy
