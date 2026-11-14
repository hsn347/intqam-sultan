local baseProxy = require("fgui.base.baseProxy")
local SoldierRushWinProxy = class("SoldierRushWinProxy", baseProxy)
function SoldierRushWinProxy:onRegisterEvent()
	print("=======SoldierRushWinProxy:onRegisterEvent")
end
return SoldierRushWinProxy
