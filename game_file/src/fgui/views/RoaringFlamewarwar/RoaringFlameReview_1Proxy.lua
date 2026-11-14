local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameReview_1Proxy = class("RoaringFlameReview_1Proxy", baseProxy)
function RoaringFlameReview_1Proxy:onRegisterEvent()
	print("=======RoaringFlameReview_1Proxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SEASONRECORD", handler(self, self.onMsgUpdateStateData))
end
function RoaringFlameReview_1Proxy:onMsgUpdateStateData(...)
	self.view:onMsgUpdateStateData(...)
end
return RoaringFlameReview_1Proxy
