local baseProxy = require("fgui.base.baseProxy")
local MagicLampMagicPowerPreviewProxy = class("MagicLampMagicPowerPreviewProxy", baseProxy)
function MagicLampMagicPowerPreviewProxy:onRegisterEvent()
	print("=======MagicLampMagicPowerPreviewProxy:onRegisterEvent")
end
return MagicLampMagicPowerPreviewProxy
