local baseProxy = require("fgui.base.baseProxy")
local EscortSignUpProxy = class("EscortSignUpProxy", baseProxy)
function EscortSignUpProxy:onRegisterEvent()
	print("=======EscortSignUpProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMY_TEAMORGANIZE_BACKDATA", handler(self.view, self.view.adaptTeam))
end
return EscortSignUpProxy
