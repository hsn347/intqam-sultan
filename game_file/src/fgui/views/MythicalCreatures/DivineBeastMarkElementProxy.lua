local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkElementProxy = class("DivineBeastMarkElementProxy", baseProxy)
function DivineBeastMarkElementProxy:onRegisterEvent()
	print("=======DivineBeastMarkElementProxy:onRegisterEvent")
end
return DivineBeastMarkElementProxy
