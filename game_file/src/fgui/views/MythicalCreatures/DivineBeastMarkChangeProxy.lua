local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkChangeProxy = class("DivineBeastMarkChangeProxy", baseProxy)
function DivineBeastMarkChangeProxy:onRegisterEvent()
	print("=======DivineBeastMarkChangeProxy:onRegisterEvent")
end
return DivineBeastMarkChangeProxy
