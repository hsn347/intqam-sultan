local baseProxy = require("fgui.base.baseProxy")
local CheatViewBuffPopProxy = class("CheatViewBuffPopProxy", baseProxy)
function CheatViewBuffPopProxy:onRegisterEvent()
	print("=======CheatViewBuffPopProxy:onRegisterEvent")
end
return CheatViewBuffPopProxy
