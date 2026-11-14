local baseProxy = require("fgui.base.baseProxy")
local TestTowerdefendProxy = class("TestTowerdefendProxy", baseProxy)
function TestTowerdefendProxy:onRegisterEvent()
	print("=======TestTowerdefendProxy:onRegisterEvent")
end
return TestTowerdefendProxy
