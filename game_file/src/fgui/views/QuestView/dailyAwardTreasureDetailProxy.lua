local baseProxy = require("fgui.base.baseProxy")
local dailyAwardTreasureDetailProxy = class("dailyAwardTreasureDetailProxy", baseProxy)
function dailyAwardTreasureDetailProxy:onRegisterEvent()
	print("=======dailyAwardTreasureDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_DAILYAWARD_REFRESH_TREASURE", handler(self, self.sMsgRefreshTreasure))
	SoraDAddMessage(self, "MESSAGE_SERVER_DAILYAWARD_GET_TREASURE", handler(self, self.sMsgGetTreasure))
end
function dailyAwardTreasureDetailProxy:sMsgRefreshTreasure(target, data)
	self.view:sMsgRefreshTreasure(target, data)
end
function dailyAwardTreasureDetailProxy:sMsgGetTreasure(target, data)
	self.view:sMsgGetTreasure(target, data)
end
return dailyAwardTreasureDetailProxy
