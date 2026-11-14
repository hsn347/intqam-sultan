local baseProxy = require("fgui.base.baseProxy")
local allianceManageViewProxy = class("allianceManageViewProxy", baseProxy)
function allianceManageViewProxy:onRegisterEvent()
	print("=======allianceManageViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CHANGE_FLAG_SUCCESS", handler(self, self.updateFlag))
end
function allianceManageViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function allianceManageViewProxy:updateFlag(target, data)
	self.view:updateFlag(target, data)
end
return allianceManageViewProxy
