local baseProxy = require("fgui.base.baseProxy")
local ManorLayoutSaveProxy = class("ManorLayoutSaveProxy", baseProxy)
function ManorLayoutSaveProxy:onRegisterEvent()
	print("=======ManorLayoutSaveProxy:onRegisterEvent")
end
return ManorLayoutSaveProxy
