local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkIllusionDetailProxy = class("DivineBeastMarkIllusionDetailProxy", baseProxy)
function DivineBeastMarkIllusionDetailProxy:onRegisterEvent()
	print("=======DivineBeastMarkIllusionDetailProxy:onRegisterEvent")
end
return DivineBeastMarkIllusionDetailProxy
