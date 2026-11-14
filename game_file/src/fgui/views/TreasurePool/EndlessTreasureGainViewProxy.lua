local baseProxy = require("fgui.base.baseProxy")
local EndlessTreasureGainViewProxy = class("EndlessTreasureGainViewProxy", baseProxy)
function EndlessTreasureGainViewProxy:onRegisterEvent()
	print("=======EndlessTreasureGainViewProxy:onRegisterEvent")
end
function EndlessTreasureGainViewProxy:initData(tID)
	self.view:initData(tID)
end
return EndlessTreasureGainViewProxy
