local baseProxy = require("fgui.base.baseProxy")
local MagicHerbIrrigateViewProxy = class("MagicHerbIrrigateViewProxy", baseProxy)
function MagicHerbIrrigateViewProxy:onRegisterEvent()
	print("=======MagicHerbIrrigateViewProxy:onRegisterEvent")
end
return MagicHerbIrrigateViewProxy
