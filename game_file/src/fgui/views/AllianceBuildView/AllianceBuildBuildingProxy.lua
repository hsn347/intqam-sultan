local baseProxy = require("fgui.base.baseProxy")
local AllianceBuildBuildingProxy = class("AllianceBuildBuildingProxy", baseProxy)
function AllianceBuildBuildingProxy:onRegisterEvent()
	print("=======AllianceBuildBuildingProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_DESTROY", handler(self, self.judgeCloseView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.judgeBeQuit))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self.view:removeFromParent()
	end)
end
function AllianceBuildBuildingProxy:judgeCloseView(...)
	self.view:judgeCloseView(...)
end
function AllianceBuildBuildingProxy:updateData(...)
	self.view:updateData(...)
end
function AllianceBuildBuildingProxy:judgeBeQuit(...)
	self.view:judgeBeQuit(...)
end
function AllianceBuildBuildingProxy:serverMessage_RequestMapInstaceInfo(...)
	self.view:serverMessage_RequestMapInstaceInfo(...)
end
return AllianceBuildBuildingProxy
