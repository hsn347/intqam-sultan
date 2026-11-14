local baseProxy = require("fgui.base.baseProxy")
local HeroNewTrialTaskProxy = class("HeroNewTrialTaskProxy", baseProxy)
function HeroNewTrialTaskProxy:onRegisterEvent()
	print("=======HeroNewTrialTaskProxy:onRegisterEvent")
end
return HeroNewTrialTaskProxy
