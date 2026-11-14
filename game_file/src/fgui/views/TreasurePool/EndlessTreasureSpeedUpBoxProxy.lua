local baseProxy = require("fgui.base.baseProxy")
local EndlessTreasureSpeedUpBoxProxy = class("EndlessTreasureSpeedUpBoxProxy", baseProxy)
function EndlessTreasureSpeedUpBoxProxy:onRegisterEvent()
	print("=======EndlessTreasureSpeedUpBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.initData))
end
function EndlessTreasureSpeedUpBoxProxy:initData(...)
	self.view:initData(...)
end
return EndlessTreasureSpeedUpBoxProxy
