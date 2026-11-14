local baseProxy = require("fgui.base.baseProxy")
local allianceRelationApplyViewProxy = class("allianceRelationApplyViewProxy", baseProxy)
function allianceRelationApplyViewProxy:onRegisterEvent()
	print("=======allianceRelationApplyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_RELATION_CHECK_SELECT", handler(self, self.updateCheck))
end
function allianceRelationApplyViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function allianceRelationApplyViewProxy:updateCheck(target, data)
	self.view:updateCheck(target, data)
end
return allianceRelationApplyViewProxy
