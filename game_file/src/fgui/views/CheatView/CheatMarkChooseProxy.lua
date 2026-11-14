local baseProxy = require("fgui.base.baseProxy")
local CheatMarkChooseProxy = class("CheatMarkChooseProxy", baseProxy)
function CheatMarkChooseProxy:onRegisterEvent()
	print("=======CheatMarkChooseProxy:onRegisterEvent")
end
return CheatMarkChooseProxy
