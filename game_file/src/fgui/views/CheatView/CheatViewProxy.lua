local baseProxy = require("fgui.base.baseProxy")
local CheatViewProxy = class("CheatViewProxy", baseProxy)
function CheatViewProxy:onRegisterEvent()
	print("=======CheatViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHEAT_ADDITEM_SUCCESS", handler(self, self.cheatSuccess))
end
function CheatViewProxy:cheatSuccess(target, data)
	self.view:cheatSuccess(target, data)
end
return CheatViewProxy
