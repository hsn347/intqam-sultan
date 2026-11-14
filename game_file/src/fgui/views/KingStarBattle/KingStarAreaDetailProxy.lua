local baseProxy = require("fgui.base.baseProxy")
local KingStarAreaDetailProxy = class("KingStarAreaDetailProxy", baseProxy)
function KingStarAreaDetailProxy:onRegisterEvent()
	print("=======KingStarAreaDetailProxy:onRegisterEvent")
end
return KingStarAreaDetailProxy
