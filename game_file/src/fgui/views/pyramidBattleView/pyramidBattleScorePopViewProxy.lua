local baseProxy = require("fgui.base.baseProxy")
local pyramidBattleScorePopViewProxy = class("pyramidBattleScorePopViewProxy", baseProxy)
function pyramidBattleScorePopViewProxy:onRegisterEvent()
	print("=======pyramidBattleScorePopViewProxy:onRegisterEvent")
end
return pyramidBattleScorePopViewProxy
