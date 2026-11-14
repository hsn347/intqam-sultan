local baseProxy = require("fgui.base.baseProxy")
local RunePandectAttrProxy = class("RunePandectAttrProxy", baseProxy)
function RunePandectAttrProxy:onRegisterEvent()
	print("=======RunePandectAttrProxy:onRegisterEvent")
end
return RunePandectAttrProxy
