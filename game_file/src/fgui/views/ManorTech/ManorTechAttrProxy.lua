local baseProxy = require("fgui.base.baseProxy")
local ManorTechAttrProxy = class("ManorTechAttrProxy", baseProxy)
function ManorTechAttrProxy:onRegisterEvent()
	print("=======ManorTechAttrProxy:onRegisterEvent")
end
return ManorTechAttrProxy
