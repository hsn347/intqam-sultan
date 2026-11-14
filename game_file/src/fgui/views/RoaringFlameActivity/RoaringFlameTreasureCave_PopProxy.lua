local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameTreasureCave_PopProxy = class("RoaringFlameTreasureCave_PopProxy", baseProxy)
function RoaringFlameTreasureCave_PopProxy:onRegisterEvent()
	print("=======RoaringFlameTreasureCave_PopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_CAVE", handler(self, self.initView))
end
function RoaringFlameTreasureCave_PopProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlameTreasureCave_PopProxy
