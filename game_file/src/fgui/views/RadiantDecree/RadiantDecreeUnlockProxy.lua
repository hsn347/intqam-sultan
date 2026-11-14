local baseProxy = require("fgui.base.baseProxy")
local RadiantDecreeUnlockProxy = class("RadiantDecreeUnlockProxy", baseProxy)
function RadiantDecreeUnlockProxy:onRegisterEvent()
	print("=======RadiantDecreeUnlockProxy:onRegisterEvent")
end
return RadiantDecreeUnlockProxy
