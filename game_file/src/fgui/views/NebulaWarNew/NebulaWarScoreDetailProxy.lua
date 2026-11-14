local baseProxy = require("fgui.base.baseProxy")
local NebulaWarScoreDetailProxy = class("NebulaWarScoreDetailProxy", baseProxy)
function NebulaWarScoreDetailProxy:onRegisterEvent()
	print("=======NebulaWarScoreDetailProxy:onRegisterEvent")
end
return NebulaWarScoreDetailProxy
