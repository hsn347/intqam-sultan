local baseProxy = require("fgui.base.baseProxy")
local soldiersDetailViewProxy = class("soldiersDetailViewProxy", baseProxy)
function soldiersDetailViewProxy:onRegisterEvent()
	print("=======soldiersDetailViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMY_DISMISSAL", handler(self, self.updateOwn))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_ARMY", handler(self, self.updateOwn))
end
function soldiersDetailViewProxy:updateOwn()
	self.view:updateOwn()
end
return soldiersDetailViewProxy
