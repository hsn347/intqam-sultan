local baseProxy = require("fgui.base.baseProxy")
local vipCenterRewardViewProxy = class("vipCenterRewardViewProxy", baseProxy)
function vipCenterRewardViewProxy:onRegisterEvent()
	print("=======vipCenterRewardViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.initData))
end
function vipCenterRewardViewProxy:initData()
	self.view:initData()
end
return vipCenterRewardViewProxy
