local baseProxy = require("fgui.base.baseProxy")
local NebulaMileStoneUnlockProxy = class("NebulaMileStoneUnlockProxy", baseProxy)
function NebulaMileStoneUnlockProxy:onRegisterEvent()
	print("=======NebulaMileStoneUnlockProxy:onRegisterEvent")
end
return NebulaMileStoneUnlockProxy
