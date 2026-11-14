local baseProxy = require("fgui.base.baseProxy")
local HeroNewTrialHook2Proxy = class("HeroNewTrialHook2Proxy", baseProxy)
function HeroNewTrialHook2Proxy:onRegisterEvent()
	print("=======HeroNewTrialHook2Proxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_NEW_TRIAL_UPDATE", handler(self, self.onMsgUpdateView))
end
function HeroNewTrialHook2Proxy:onMsgUpdateView(...)
	self.view:onMsgUpdateView(...)
end
return HeroNewTrialHook2Proxy
