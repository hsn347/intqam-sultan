local baseProxy = require("fgui.base.baseProxy")
local ManorBuildInfoProxy = class("ManorBuildInfoProxy", baseProxy)
function ManorBuildInfoProxy:onRegisterEvent()
	print("=======ManorBuildInfoProxy:onRegisterEvent")
end
return ManorBuildInfoProxy
