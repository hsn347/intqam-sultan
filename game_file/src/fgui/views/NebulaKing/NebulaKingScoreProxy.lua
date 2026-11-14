local baseProxy = require("fgui.base.baseProxy")
local NebulaKingScoreProxy = class("NebulaKingScoreProxy", baseProxy)
function NebulaKingScoreProxy:onRegisterEvent()
	print("=======NebulaKingScoreProxy:onRegisterEvent")
end
return NebulaKingScoreProxy
