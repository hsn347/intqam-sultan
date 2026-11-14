local baseProxy = require("fgui.base.baseProxy")
local KingdomBattleTargetBoxDetailProxy = class("KingdomBattleTargetBoxDetailProxy", baseProxy)
function KingdomBattleTargetBoxDetailProxy:onRegisterEvent()
	print("=======KingdomBattleTargetBoxDetailProxy:onRegisterEvent")
end
return KingdomBattleTargetBoxDetailProxy
