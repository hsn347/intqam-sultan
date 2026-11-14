local baseProxy = require("fgui.base.baseProxy")
local congratulations2Proxy = class("congratulations2Proxy", baseProxy)
function congratulations2Proxy:onRegisterEvent()
	print("=======congratulations2Proxy:onRegisterEvent")
end
return congratulations2Proxy
