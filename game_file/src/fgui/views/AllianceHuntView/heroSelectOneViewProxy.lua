local baseProxy = require("fgui.base.baseProxy")
local heroSelectOneViewProxy = class("heroSelectOneViewProxy", baseProxy)
function heroSelectOneViewProxy:onRegisterEvent()
	print("=======heroSelectOneViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEMYHERO", handler(self, self.sMsgHeroStateChanged))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.sMsgHeroStateChanged))
end
function heroSelectOneViewProxy:sMsgHeroStateChanged(...)
	self.view:sMsgHeroStateChanged(...)
end
return heroSelectOneViewProxy
