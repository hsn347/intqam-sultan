local baseProxy = require("fgui.base.baseProxy")
local testViewProxy = class("testViewProxy", baseProxy)
function testViewProxy:onRegisterEvent()
	print("=======testViewProxy:onRegisterEvent")
end
function testViewProxy:onRemoveView()
	print("=======testViewProxy:onRemoveView")
end
return testViewProxy
