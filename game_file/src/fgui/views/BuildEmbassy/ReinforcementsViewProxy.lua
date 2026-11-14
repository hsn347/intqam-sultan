local baseProxy = require("fgui.base.baseProxy")
local ReinforcementsViewProxy = class("ReinforcementsViewProxy", baseProxy)
function ReinforcementsViewProxy:onRegisterEvent()
	print("=======ReinforcementsViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_REINFORCEMENTS_ADD", handler(self.view, self.view.bindData))
	SoraDAddMessage(self, "MESSAGE_REINFORCEMENTS_SUB", handler(self.view, self.view.delTroop))
end
return ReinforcementsViewProxy
