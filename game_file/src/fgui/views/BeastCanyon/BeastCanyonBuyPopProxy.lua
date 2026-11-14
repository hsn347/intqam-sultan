local baseProxy = require("fgui.base.baseProxy")
local BeastCanyonBuyPopProxy = class("BeastCanyonBuyPopProxy", baseProxy)
function BeastCanyonBuyPopProxy:onRegisterEvent()
	print("=======BeastCanyonBuyPopProxy:onRegisterEvent")
end
return BeastCanyonBuyPopProxy
