local baseProxy = require("fgui.base.baseProxy")
local WorldStrongPointProxy = class("WorldStrongPointProxy", baseProxy)
function WorldStrongPointProxy:onRegisterEvent()
	print("=======WorldStrongPointProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self.view:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_WORLDMAPHOLD_UPDATE", handler(self, self.updateData))
end
function WorldStrongPointProxy:sMsgReqInfoBack(...)
	self.view:sMsgReqInfoBack(...)
end
function WorldStrongPointProxy:updateData(...)
	self.view:updateData(...)
end
return WorldStrongPointProxy
