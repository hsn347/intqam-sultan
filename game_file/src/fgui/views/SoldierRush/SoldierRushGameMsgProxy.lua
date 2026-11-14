local baseProxy = require("fgui.base.baseProxy")
local SoldierRushGameMsgProxy = class("SoldierRushGameMsgProxy", baseProxy)
function SoldierRushGameMsgProxy:onRegisterEvent()
	print("=======SoldierRushGameMsgProxy:onRegisterEvent")
end
return SoldierRushGameMsgProxy
