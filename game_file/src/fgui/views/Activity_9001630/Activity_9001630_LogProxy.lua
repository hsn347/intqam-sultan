local baseProxy = require("fgui.base.baseProxy")
local Activity_9001630_LogProxy = class("Activity_9001630_LogProxy", baseProxy)
function Activity_9001630_LogProxy:onRegisterEvent()
	print("=======Activity_9001630_LogProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001630_UPDATE", handler(self, self.msgRefreshView))
end
function Activity_9001630_LogProxy:msgRefreshView(target, data)
	SoraDCloseLoading(self.view)
	if data.subMsg == "log" then
		self.view:initData(data.logData)
	end
end
return Activity_9001630_LogProxy
