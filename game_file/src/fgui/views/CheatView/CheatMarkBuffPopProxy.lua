local baseProxy = require("fgui.base.baseProxy")
local CheatMarkBuffPopProxy = class("CheatMarkBuffPopProxy", baseProxy)
function CheatMarkBuffPopProxy:onRegisterEvent()
	print("=======CheatMarkBuffPopProxy:onRegisterEvent")
end
return CheatMarkBuffPopProxy
