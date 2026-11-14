local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameBattlefieldUnlockProxy = class("RoaringFlameBattlefieldUnlockProxy", baseProxy)
function RoaringFlameBattlefieldUnlockProxy:onRegisterEvent()
	print("=======RoaringFlameBattlefieldUnlockProxy:onRegisterEvent")
end
return RoaringFlameBattlefieldUnlockProxy
