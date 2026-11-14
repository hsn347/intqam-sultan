local baseProxy = require("fgui.base.baseProxy")
local SpecializeCritResultProxy = class("SpecializeCritResultProxy", baseProxy)
function SpecializeCritResultProxy:onRegisterEvent()
	print("=======SpecializeCritResultProxy:onRegisterEvent")
end
return SpecializeCritResultProxy
