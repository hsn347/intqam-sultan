local baseProxy = require("fgui.base.baseProxy")
local test3Proxy = class("test3Proxy", baseProxy)
function test3Proxy:onRegisterEvent()
	print("=======test3Proxy:onRegisterEvent")
end
return test3Proxy
