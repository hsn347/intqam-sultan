local baseProxy = require("fgui.base.baseProxy")
local LifeSpringsViewProxy = class("LifeSpringsViewProxy", baseProxy)
function LifeSpringsViewProxy:onRegisterEvent()
	print("=======LifeSpringsViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SPRINGS_RESURGENCE_ARMY", handler(self, self.resurgenceBack))
	SoraDAddMessage(self, "MESSAGE_SPRINGS_RESURGENCE_STATE_CHANGE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.updateView))
end
function LifeSpringsViewProxy:resurgenceBack(target, data)
	self.view:resurgenceBack(target, data)
end
function LifeSpringsViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return LifeSpringsViewProxy
