local baseProxy = require("fgui.base.baseProxy")
local rechargeDailyPopViewProxy = class("rechargeDailyPopViewProxy", baseProxy)
function rechargeDailyPopViewProxy:onRegisterEvent()
	print("=======rechargeDailyPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFT_REFRESH", handler(self, self.dailySpecialGiftRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", handler(self, self.dailyFreeGiftRefresh))
end
function rechargeDailyPopViewProxy:dailySpecialGiftRefresh(target, data)
	self.view:dailySpecialGiftRefresh(target, data)
end
function rechargeDailyPopViewProxy:dailyFreeGiftRefresh(target, data)
	self.view:dailyFreeGiftRefresh(target, data)
end
return rechargeDailyPopViewProxy
