local baseProxy = require("fgui.base.baseProxy")
local gameSecondaryLockProxy = class("gameSecondaryLockProxy", baseProxy)
function gameSecondaryLockProxy:onRegisterEvent()
	print("=======gameSecondaryLockProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.gotoForeBackGroud))
end
function gameSecondaryLockProxy:gotoForeBackGroud()
	print("gameSecondaryLockProxy:gotoForeBackGroud")
end
return gameSecondaryLockProxy
