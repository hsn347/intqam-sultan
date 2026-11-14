local baseProxy = require("fgui.base.baseProxy")
local KingStarWinPopProxy = class("KingStarWinPopProxy", baseProxy)
function KingStarWinPopProxy:onRegisterEvent()
	print("=======KingStarWinPopProxy:onRegisterEvent")
end
return KingStarWinPopProxy
