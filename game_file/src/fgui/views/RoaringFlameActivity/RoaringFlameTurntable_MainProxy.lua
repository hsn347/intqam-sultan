local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameTurntable_MainProxy = class("RoaringFlameTurntable_MainProxy", baseProxy)
function RoaringFlameTurntable_MainProxy:onRegisterEvent()
	print("=======RoaringFlameTurntable_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_TURNTABLE", handler(self, self.initView))
end
function RoaringFlameTurntable_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlameTurntable_MainProxy
