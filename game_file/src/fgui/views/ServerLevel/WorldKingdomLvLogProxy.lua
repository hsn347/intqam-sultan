local baseProxy = require("fgui.base.baseProxy")
local WorldKingdomLvLogProxy = class("WorldKingdomLvLogProxy", baseProxy)
function WorldKingdomLvLogProxy:onRegisterEvent()
	print("=======WorldKingdomLvLogProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLDKINGDOM_LOG_BACK", handler(self, self.msgLogBack))
end
function WorldKingdomLvLogProxy:msgLogBack(target, data)
	dump("日志记录----------")
	SoraDCloseLoading(self.view)
	self.view:updateLogView(data.data)
end
return WorldKingdomLvLogProxy
