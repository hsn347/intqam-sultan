local baseProxy = require("fgui.base.baseProxy")
local ManorDressActiveNumProxy = class("ManorDressActiveNumProxy", baseProxy)
function ManorDressActiveNumProxy:onRegisterEvent()
	print("=======ManorDressActiveNumProxy:onRegisterEvent")
end
return ManorDressActiveNumProxy
