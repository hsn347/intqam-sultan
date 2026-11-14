local baseProxy = require("fgui.base.baseProxy")
local IceShimmerProxy = class("IceShimmerProxy", baseProxy)
function IceShimmerProxy:onRegisterEvent()
	print("=======IceShimmerProxy:onRegisterEvent")
end
return IceShimmerProxy
