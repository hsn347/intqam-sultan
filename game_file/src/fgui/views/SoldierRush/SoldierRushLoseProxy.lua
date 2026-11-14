local baseProxy = require("fgui.base.baseProxy")
local SoldierRushLoseProxy = class("SoldierRushLoseProxy", baseProxy)
function SoldierRushLoseProxy:onRegisterEvent()
	print("=======SoldierRushLoseProxy:onRegisterEvent")
end
return SoldierRushLoseProxy
