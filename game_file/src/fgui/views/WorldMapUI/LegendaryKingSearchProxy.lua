local baseProxy = require("fgui.base.baseProxy")
local LegendaryKingSearchProxy = class("LegendaryKingSearchProxy", baseProxy)
function LegendaryKingSearchProxy:onRegisterEvent()
	print("=======LegendaryKingSearchProxy:onRegisterEvent")
end
return LegendaryKingSearchProxy
