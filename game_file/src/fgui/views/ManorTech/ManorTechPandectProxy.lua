local baseProxy = require("fgui.base.baseProxy")
local ManorTechPandectProxy = class("ManorTechPandectProxy", baseProxy)
function ManorTechPandectProxy:onRegisterEvent()
	print("=======ManorTechPandectProxy:onRegisterEvent")
end
return ManorTechPandectProxy
