local baseProxy = require("fgui.base.baseProxy")
local NewStartInheritSureProxy = class("NewStartInheritSureProxy", baseProxy)
function NewStartInheritSureProxy:onRegisterEvent()
	print("=======NewStartInheritSureProxy:onRegisterEvent")
end
return NewStartInheritSureProxy
