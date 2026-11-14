local baseProxy = require("fgui.base.baseProxy")
local CheatCmdPopProxy = class("CheatCmdPopProxy", baseProxy)
function CheatCmdPopProxy:onRegisterEvent()
	print("=======CheatCmdPopProxy:onRegisterEvent")
end
return CheatCmdPopProxy
