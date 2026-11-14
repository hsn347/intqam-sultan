local baseProxy = require("fgui.base.baseProxy")
local Activity_9001729_PackageProxy = class("Activity_9001729_PackageProxy", baseProxy)
function Activity_9001729_PackageProxy:onRegisterEvent()
	print("=======Activity_9001729_PackageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001729_PACKAGE_UPDATE", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.onPackageUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.onPackageUpdate))
end
function Activity_9001729_PackageProxy:onPackageUpdate()
	print("=======Activity_9001729_PackageProxy:onPackageUpdate")
	SoraDCloseLoading()
	self.view:initData()
end
return Activity_9001729_PackageProxy
