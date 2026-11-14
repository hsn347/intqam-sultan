local baseProxy = require("fgui.base.baseProxy")
local EndlessTreasureViewProxy = class("EndlessTreasureViewProxy", baseProxy)
function EndlessTreasureViewProxy:onRegisterEvent()
	print("=======EndlessTreasureViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_TREVIFOUNTAIN_ENDLESSTREASURE_REFRESH", handler(self, self.initData))
end
function EndlessTreasureViewProxy:initData(...)
	self.view:initData(...)
end
return EndlessTreasureViewProxy
