local baseProxy = require("fgui.base.baseProxy")
local EndlessTreasureDigViewProxy = class("EndlessTreasureDigViewProxy", baseProxy)
function EndlessTreasureDigViewProxy:onRegisterEvent()
	print("=======EndlessTreasureDigViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_TREVIFOUNTAIN_ENDLESSTREASURE_REFRESH", handler(self, self.updateData))
end
function EndlessTreasureDigViewProxy:updateData(...)
	self.view:updateData(...)
end
function EndlessTreasureDigViewProxy:initData(...)
	self.view:initData(...)
end
return EndlessTreasureDigViewProxy
