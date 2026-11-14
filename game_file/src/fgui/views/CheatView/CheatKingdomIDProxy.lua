local baseProxy = require("fgui.base.baseProxy")
local CheatKingdomIDProxy = class("CheatKingdomIDProxy", baseProxy)
function CheatKingdomIDProxy:onRegisterEvent()
	print("=======CheatKingdomIDProxy:onRegisterEvent")
end
return CheatKingdomIDProxy
