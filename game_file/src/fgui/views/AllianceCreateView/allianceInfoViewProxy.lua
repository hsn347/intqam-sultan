local baseProxy = require("fgui.base.baseProxy")
local allianceInfoViewProxy = class("allianceInfoViewProxy", baseProxy)
function allianceInfoViewProxy:onRegisterEvent()
	print("=======allianceInfoViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_APPLY_JOIN", handler(self, self.updateApplyBtn))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_APPLY_REJECT", handler(self, self.updateApplyBtn))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CANCEL_APPLY_JOIN", handler(self, self.updateApplyBtn))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.memberUpdate))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_ADD_BWLIST_SUCCESS", handler(self, self.bwlistUpdate))
end
function allianceInfoViewProxy:updateApplyBtn(target, data)
	self.view:updateApplyBtn(target, data)
end
function allianceInfoViewProxy:memberUpdate(target, data)
	self.view:memberUpdate(target, data)
end
function allianceInfoViewProxy:bwlistUpdate(target, data)
	self.view:bwlistUpdate(target, data)
end
return allianceInfoViewProxy
