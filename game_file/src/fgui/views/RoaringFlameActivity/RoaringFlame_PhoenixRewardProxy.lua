local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_PhoenixRewardProxy = class("RoaringFlame_PhoenixRewardProxy", baseProxy)
function RoaringFlame_PhoenixRewardProxy:onRegisterEvent()
	print("=======RoaringFlame_PhoenixRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_PHOENIX_LIST", handler(self, self.initView))
end
function RoaringFlame_PhoenixRewardProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlame_PhoenixRewardProxy
