local baseProxy = require("fgui.base.baseProxy")
local MagicLampMagicPowerPopProxy = class("MagicLampMagicPowerPopProxy", baseProxy)
function MagicLampMagicPowerPopProxy:onRegisterEvent()
	print("=======MagicLampMagicPowerPopProxy:onRegisterEvent")
end
return MagicLampMagicPowerPopProxy
