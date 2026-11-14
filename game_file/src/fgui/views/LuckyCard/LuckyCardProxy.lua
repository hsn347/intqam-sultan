local baseProxy = require("fgui.base.baseProxy")
local LuckyCardProxy = class("LuckyCardProxy", baseProxy)
function LuckyCardProxy:onRegisterEvent()
	print("=======LuckyCardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_DAILYLOGIN_NOTIFY_DAILYREWARD", handler(self, self.msgUpdate))
	SoraDAddMessage(self, "MESSAGE_DAILYLOGIN_RECEIVEREWARD_SUCCESS", handler(self, self.msgGetAwardBack))
end
function LuckyCardProxy:msgUpdate(target, data)
	self.view:updateView()
end
function LuckyCardProxy:msgGetAwardBack(target, data)
	self.view:playAnimation(data)
	self.view:updateView()
end
return LuckyCardProxy
