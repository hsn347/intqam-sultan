local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_PhoenixMainProxy = class("RoaringFlame_PhoenixMainProxy", baseProxy)
function RoaringFlame_PhoenixMainProxy:onRegisterEvent()
	print("=======RoaringFlame_PhoenixMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_PHOENIX_LIST", handler(self, self.initView))
end
function RoaringFlame_PhoenixMainProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlame_PhoenixMainProxy
