local baseProxy = require("fgui.base.baseProxy")
local CheatRuneBuffPopProxy = class("CheatRuneBuffPopProxy", baseProxy)
function CheatRuneBuffPopProxy:onRegisterEvent()
	print("=======CheatRuneBuffPopProxy:onRegisterEvent")
end
return CheatRuneBuffPopProxy
