local baseProxy = require("fgui.base.baseProxy")
local BeastCanyonSweepProxy = class("BeastCanyonSweepProxy", baseProxy)
function BeastCanyonSweepProxy:onRegisterEvent()
	print("=======BeastCanyonSweepProxy:onRegisterEvent")
end
return BeastCanyonSweepProxy
