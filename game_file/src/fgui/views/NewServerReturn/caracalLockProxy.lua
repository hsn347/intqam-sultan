local baseProxy = require("fgui.base.baseProxy")
local caracalLockProxy = class("caracalLockProxy", baseProxy)
function caracalLockProxy:onRegisterEvent()
	print("=======caracalLockProxy:onRegisterEvent")
end
return caracalLockProxy
