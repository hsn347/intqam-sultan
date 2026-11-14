local baseProxy = require("fgui.base.baseProxy")
local allianceChangeFlagViewProxy = class("allianceChangeFlagViewProxy", baseProxy)
function allianceChangeFlagViewProxy:onRegisterEvent()
	print("=======allianceChangeFlagViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CHANGE_FLAG_SUCCESS", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_FLAG_SELECT", handler(self, self.selectFlagBack))
end
function allianceChangeFlagViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function allianceChangeFlagViewProxy:selectFlagBack(target, data)
	self.view:selectFlagBack(target, data)
end
return allianceChangeFlagViewProxy
