local baseProxy = require("fgui.base.baseProxy")
local skillStudyViewProxy = class("skillStudyViewProxy", baseProxy)
function skillStudyViewProxy:onRegisterEvent()
	print("=======skillStudyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_SKILL", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPGRADE_SKILL", handler(self, self.initData))
end
function skillStudyViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return skillStudyViewProxy
