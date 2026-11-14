local baseProxy = require("fgui.base.baseProxy")
local CheatRuneChooseProxy = class("CheatRuneChooseProxy", baseProxy)
function CheatRuneChooseProxy:onRegisterEvent()
	print("=======CheatRuneChooseProxy:onRegisterEvent")
end
return CheatRuneChooseProxy
