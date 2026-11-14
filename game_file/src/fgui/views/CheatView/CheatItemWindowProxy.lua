local baseProxy = require("fgui.base.baseProxy")
local CheatItemWindowProxy = class("CheatItemWindowProxy", baseProxy)
function CheatItemWindowProxy:onRegisterEvent()
	print("=======CheatItemWindowProxy:onRegisterEvent")
end
return CheatItemWindowProxy
