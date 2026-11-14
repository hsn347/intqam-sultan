local baseProxy = require("fgui.base.baseProxy")
local Activity_9001734_GiftProxy = class("Activity_9001734_GiftProxy", baseProxy)
function Activity_9001734_GiftProxy:onRegisterEvent()
	print("=======Activity_9001734_GiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001734_BUYGIFT", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.onPackageUpdate))
end
function Activity_9001734_GiftProxy:onPackageUpdate()
	SoraDCloseLoading()
	if self.view and self.view.endShow then
		self.view:endShow()
	end
end
return Activity_9001734_GiftProxy
