local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkIllusionProxy = class("DivineBeastMarkIllusionProxy", baseProxy)
function DivineBeastMarkIllusionProxy:onRegisterEvent()
	print("=======DivineBeastMarkIllusionProxy:onRegisterEvent")
end
return DivineBeastMarkIllusionProxy
