local baseProxy = require("fgui.base.baseProxy")
local CheatArmsChooseProxy = class("CheatArmsChooseProxy", baseProxy)
function CheatArmsChooseProxy:onRegisterEvent()
	print("=======CheatArmsChooseProxy:onRegisterEvent")
end
return CheatArmsChooseProxy
