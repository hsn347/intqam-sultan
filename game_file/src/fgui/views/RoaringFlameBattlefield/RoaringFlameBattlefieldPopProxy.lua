local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameBattlefieldPopProxy = class("RoaringFlameBattlefieldPopProxy", baseProxy)
function RoaringFlameBattlefieldPopProxy:onRegisterEvent()
	print("=======RoaringFlameBattlefieldPopProxy:onRegisterEvent")
end
return RoaringFlameBattlefieldPopProxy
