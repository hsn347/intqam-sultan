local baseProxy = require("fgui.base.baseProxy")
local LegendMPopRewardProxy = class("LegendMPopRewardProxy", baseProxy)
function LegendMPopRewardProxy:onRegisterEvent()
	print("=======LegendMPopRewardProxy:onRegisterEvent")
end
return LegendMPopRewardProxy
