local baseProxy = require("fgui.base.baseProxy")
local LegendOfPegasusRewardProxy = class("LegendOfPegasusRewardProxy", baseProxy)
function LegendOfPegasusRewardProxy:onRegisterEvent()
	print("=======LegendOfPegasusRewardProxy:onRegisterEvent")
end
return LegendOfPegasusRewardProxy
