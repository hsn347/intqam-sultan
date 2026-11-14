local baseProxy = require("fgui.base.baseProxy")
local allianceBlackWhiteViewProxy = class("allianceBlackWhiteViewProxy", baseProxy)
function allianceBlackWhiteViewProxy:onRegisterEvent()
	print("=======allianceBlackWhiteViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_BWLIST_SUCCESS", handler(self, self.updateScrollWithData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_ADD_BWLIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DEL_BWLIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.updatePoint))
end
function allianceBlackWhiteViewProxy:updateScrollWithData(target, data)
	self.view:updateScrollWithData(target, data)
end
function allianceBlackWhiteViewProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function allianceBlackWhiteViewProxy:updatePoint(target, data)
	self.view:updatePoint(target, data)
end
return allianceBlackWhiteViewProxy
