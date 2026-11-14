local baseProxy = require("fgui.base.baseProxy")
local RuneRebornPopProxy = class("RuneRebornPopProxy", baseProxy)
function RuneRebornPopProxy:onRegisterEvent()
	print("=======RuneRebornPopProxy:onRegisterEvent")
end
return RuneRebornPopProxy
