local baseProxy = require("fgui.base.baseProxy")
local testFullViewProxy = class("testFullViewProxy", baseProxy)
function testFullViewProxy:onRegisterView()
	print("=======testFullViewProxy:onRegisterEvent")
end
function testFullViewProxy:onRemoveView()
	print("=======testFullViewProxy:onRemoveView")
end
return testFullViewProxy
