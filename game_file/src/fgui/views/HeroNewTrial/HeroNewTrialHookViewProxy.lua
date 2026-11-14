local baseProxy = require("fgui.base.baseProxy")
local HeroNewTrialHookViewProxy = class("HeroNewTrialHookViewProxy", baseProxy)
function HeroNewTrialHookViewProxy:onRegisterEvent()
	print("=======HeroNewTrialHookViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_HERO_NEW_TRIAL_UPDATE", handler(self, self.onMsgUpdateView))
end
function HeroNewTrialHookViewProxy:onMsgUpdateView(...)
	self.view:onMsgUpdateView(...)
end
return HeroNewTrialHookViewProxy
