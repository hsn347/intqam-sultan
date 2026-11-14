local baseProxy = require("fgui.base.baseProxy")
local ArenaPriceShowViewProxy = class("ArenaPriceShowViewProxy", baseProxy)
function ArenaPriceShowViewProxy:onRegisterEvent()
	print("=======ArenaPriceShowViewProxy:onRegisterEvent")
end
return ArenaPriceShowViewProxy
