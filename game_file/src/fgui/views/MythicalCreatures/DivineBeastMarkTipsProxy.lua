local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkTipsProxy = class("DivineBeastMarkTipsProxy", baseProxy)
function DivineBeastMarkTipsProxy:onRegisterEvent()
	print("=======DivineBeastMarkTipsProxy:onRegisterEvent")
end
return DivineBeastMarkTipsProxy
