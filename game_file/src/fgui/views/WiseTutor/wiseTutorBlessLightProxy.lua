local baseProxy = require("fgui.base.baseProxy")
local wiseTutorBlessLightProxy = class("wiseTutorBlessLightProxy", baseProxy)
function wiseTutorBlessLightProxy:ctor(...)
	self.super.ctor(self, ...)
	self.addMode = UI_ADD_MODE.Single
end
function wiseTutorBlessLightProxy:onRegisterEvent()
end
function wiseTutorBlessLightProxy:judgeClose(target, data)
end
return wiseTutorBlessLightProxy
