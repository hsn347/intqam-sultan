local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameTreasureCave_MainProxy = class("RoaringFlameTreasureCave_MainProxy", baseProxy)
function RoaringFlameTreasureCave_MainProxy:onRegisterEvent()
	print("=======RoaringFlameTreasureCave_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_CAVE", handler(self, self.initView))
end
function RoaringFlameTreasureCave_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlameTreasureCave_MainProxy
