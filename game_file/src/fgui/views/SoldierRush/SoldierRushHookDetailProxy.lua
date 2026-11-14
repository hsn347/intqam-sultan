local baseProxy = require("fgui.base.baseProxy")
local SoldierRushHookDetailProxy = class("SoldierRushHookDetailProxy", baseProxy)
function SoldierRushHookDetailProxy:onRegisterEvent()
	print("=======SoldierRushHookDetailProxy:onRegisterEvent")
end
return SoldierRushHookDetailProxy
