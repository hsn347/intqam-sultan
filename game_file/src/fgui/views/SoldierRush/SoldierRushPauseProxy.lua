local baseProxy = require("fgui.base.baseProxy")
local SoldierRushPauseProxy = class("SoldierRushPauseProxy", baseProxy)
function SoldierRushPauseProxy:onRegisterEvent()
	print("=======SoldierRushPauseProxy:onRegisterEvent")
end
return SoldierRushPauseProxy
