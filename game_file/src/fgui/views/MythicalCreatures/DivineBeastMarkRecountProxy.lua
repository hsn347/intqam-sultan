local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkRecountProxy = class("DivineBeastMarkRecountProxy", baseProxy)
function DivineBeastMarkRecountProxy:onRegisterEvent()
	print("=======DivineBeastMarkRecountProxy:onRegisterEvent")
end
return DivineBeastMarkRecountProxy
