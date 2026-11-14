local baseProxy = require("fgui.base.baseProxy")
local heroTrialAreaProxy = class("heroTrialAreaProxy", baseProxy)
function heroTrialAreaProxy:onRegisterEvent()
	print("=======heroTrialAreaProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_AREA_SELECT", handler(self, self.areaSelect))
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_UPDATE_AREA", self.updateArea)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_END_BATTLE", self.updateArea)
end
function heroTrialAreaProxy:areaSelect(target, data)
	self.view:areaSelect(target, data)
end
function heroTrialAreaProxy:updateArea(target, data)
	self.view:updateArea(target, data)
end
return heroTrialAreaProxy
