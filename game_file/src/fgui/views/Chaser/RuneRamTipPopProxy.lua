local baseProxy = require("fgui.base.baseProxy")
local RuneRamTipPopProxy = class("RuneRamTipPopProxy", baseProxy)
function RuneRamTipPopProxy:onRegisterEvent()
	print("=======RuneRamTipPopProxy:onRegisterEvent")
end
return RuneRamTipPopProxy
