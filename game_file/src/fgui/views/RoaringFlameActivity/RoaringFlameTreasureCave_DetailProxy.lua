local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameTreasureCave_DetailProxy = class("RoaringFlameTreasureCave_DetailProxy", baseProxy)
function RoaringFlameTreasureCave_DetailProxy:onRegisterEvent()
	print("=======RoaringFlameTreasureCave_DetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_CAVE", handler(self, self.initView))
end
function RoaringFlameTreasureCave_DetailProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlameTreasureCave_DetailProxy
