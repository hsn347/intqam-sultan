local baseProxy = require("fgui.base.baseProxy")
local RuneAttrTotalProxy = class("RuneAttrTotalProxy", baseProxy)
function RuneAttrTotalProxy:onRegisterEvent()
	print("=======RuneAttrTotalProxy:onRegisterEvent")
end
return RuneAttrTotalProxy
