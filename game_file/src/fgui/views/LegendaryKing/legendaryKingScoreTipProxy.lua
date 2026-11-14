local baseProxy = require("fgui.base.baseProxy")
local legendaryKingScoreTipProxy = class("legendaryKingScoreTipProxy", baseProxy)
function legendaryKingScoreTipProxy:onRegisterEvent()
	print("=======legendaryKingScoreTipProxy:onRegisterEvent")
end
return legendaryKingScoreTipProxy
