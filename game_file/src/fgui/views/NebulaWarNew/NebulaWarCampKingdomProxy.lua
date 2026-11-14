local baseProxy = require("fgui.base.baseProxy")
local NebulaWarCampKingdomProxy = class("NebulaWarCampKingdomProxy", baseProxy)
function NebulaWarCampKingdomProxy:onRegisterEvent()
	print("=======NebulaWarCampKingdomProxy:onRegisterEvent")
end
return NebulaWarCampKingdomProxy
