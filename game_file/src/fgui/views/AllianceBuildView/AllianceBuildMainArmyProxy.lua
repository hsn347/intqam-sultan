local baseProxy = require("fgui.base.baseProxy")
local AllianceBuildMainArmyProxy = class("AllianceBuildMainArmyProxy", baseProxy)
function AllianceBuildMainArmyProxy:onRegisterEvent()
	print("=======AllianceBuildMainArmyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_DESTROY", handler(self, self.judgeCloseView))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ADD", handler(self, self.OnMapMoveLineChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_REMOVE", handler(self, self.OnMapMoveLineChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.judgeBeQuit))
end
function AllianceBuildMainArmyProxy:judgeCloseView(...)
	self.view:judgeCloseView(...)
end
function AllianceBuildMainArmyProxy:OnMapMoveLineChange(...)
	self.view:OnMapMoveLineChange(...)
end
function AllianceBuildMainArmyProxy:serverMessage_RequestMapInstaceInfo(...)
	self.view:serverMessage_RequestMapInstaceInfo(...)
end
function AllianceBuildMainArmyProxy:judgeBeQuit(...)
	self.view:judgeBeQuit(...)
end
return AllianceBuildMainArmyProxy
