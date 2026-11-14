local baseProxy = require("fgui.base.baseProxy")
local RuneAdvancePopProxy = class("RuneAdvancePopProxy", baseProxy)
function RuneAdvancePopProxy:onRegisterEvent()
	print("=======RuneAdvancePopProxy:onRegisterEvent")
end
return RuneAdvancePopProxy
