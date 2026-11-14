local baseProxy = require("fgui.base.baseProxy")
local Activity_9001738_PackageProxy = class("Activity_9001738_PackageProxy", baseProxy)
function Activity_9001738_PackageProxy:onRegisterEvent()
	print("=======Activity_9001738_PackageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001738_BUY_GIFT", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.onPackageUpdate))
end
function Activity_9001738_PackageProxy:onPackageUpdate()
	SoraDCloseLoading()
	if self.view and self.view.endShow then
		self.view:endShow()
	end
end
return Activity_9001738_PackageProxy
