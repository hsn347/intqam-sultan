local baseProxy = require("fgui.base.baseProxy")
local RuneChooseItemProxy = class("RuneChooseItemProxy", baseProxy)
function RuneChooseItemProxy:onRegisterEvent()
	print("=======RuneChooseItemProxy:onRegisterEvent")
end
return RuneChooseItemProxy
