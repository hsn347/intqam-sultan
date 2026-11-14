local baseProxy = require("fgui.base.baseProxy")
local testpetProxy = class("testpetProxy", baseProxy)
function testpetProxy:onRegisterEvent()
	print("=======testpetProxy:onRegisterEvent")
end
return testpetProxy
