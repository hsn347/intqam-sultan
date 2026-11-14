local baseProxy = require("fgui.base.baseProxy")
local testFillProxy = class("testFillProxy", baseProxy)
function testFillProxy:onRegisterEvent()
	print("=======testFillProxy:onRegisterEvent")
end
return testFillProxy
