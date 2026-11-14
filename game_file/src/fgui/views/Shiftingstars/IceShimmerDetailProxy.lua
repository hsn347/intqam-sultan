local baseProxy = require("fgui.base.baseProxy")
local IceShimmerDetailProxy = class("IceShimmerDetailProxy", baseProxy)
function IceShimmerDetailProxy:onRegisterEvent()
	print("=======IceShimmerDetailProxy:onRegisterEvent")
end
return IceShimmerDetailProxy
