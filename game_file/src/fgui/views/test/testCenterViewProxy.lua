local baseProxy = require("fgui.base.baseProxy")
local testCenterViewProxy = class("testCenterViewProxy", baseProxy)
function testCenterViewProxy:onRegisterView()
	print("=======testCenterViewProxy:onRegisterEvent")
end
function testCenterViewProxy:onRemoveView()
	print("=======testCenterViewProxy:onRemoveView")
end
return testCenterViewProxy
