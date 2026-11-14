local baseProxy = require("fgui.base.baseProxy")
local BeastCanyonResultProxy = class("BeastCanyonResultProxy", baseProxy)
function BeastCanyonResultProxy:onRegisterEvent()
	print("=======BeastCanyonResultProxy:onRegisterEvent")
end
return BeastCanyonResultProxy
