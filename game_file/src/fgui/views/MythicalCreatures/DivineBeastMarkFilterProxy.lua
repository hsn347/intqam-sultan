local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkFilterProxy = class("DivineBeastMarkFilterProxy", baseProxy)
function DivineBeastMarkFilterProxy:onRegisterEvent()
	print("=======DivineBeastMarkFilterProxy:onRegisterEvent")
end
return DivineBeastMarkFilterProxy
