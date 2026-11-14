local baseProxy = require("fgui.base.baseProxy")
local HeroChipExchangeProxy = class("HeroChipExchangeProxy", baseProxy)
function HeroChipExchangeProxy:onRegisterEvent()
	print("=======HeroChipExchangeProxy:onRegisterEvent")
end
return HeroChipExchangeProxy
