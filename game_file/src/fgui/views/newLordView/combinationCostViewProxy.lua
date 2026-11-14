local baseProxy = require("fgui.base.baseProxy")
local combinationCostViewProxy = class("combinationCostViewProxy", baseProxy)
function combinationCostViewProxy:onRegisterEvent()
	print("=======combinationCostViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
end
function combinationCostViewProxy:resUpdate()
	self.view:resUpdate()
end
return combinationCostViewProxy
