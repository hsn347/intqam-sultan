local baseProxy = require("fgui.base.baseProxy")
local mailBattleRoundDetailProxy = class("mailBattleRoundDetailProxy", baseProxy)
function mailBattleRoundDetailProxy:onRegisterEvent()
	print("=======mailBattleRoundDetailProxy:onRegisterEvent")
end
return mailBattleRoundDetailProxy
