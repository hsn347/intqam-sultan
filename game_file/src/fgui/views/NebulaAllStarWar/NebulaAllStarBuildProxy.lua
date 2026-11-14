local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarBuildProxy = class("NebulaAllStarBuildProxy", baseProxy)
function NebulaAllStarBuildProxy:onRegisterEvent()
	print("=======NebulaAllStarBuildProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_ENERGY_DATA", handler(self, self.onMsgEnergyDataBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_BUILD_UPDATE", handler(self, self.onMsgUpdateBuild))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
end
function NebulaAllStarBuildProxy:onMsgEnergyDataBack(...)
	self.view:onMsgEnergyDataBack()
end
function NebulaAllStarBuildProxy:onMsgUpdateBuild(target, event)
	self.view:onMsgUpdateBuild(target, event)
end
function NebulaAllStarBuildProxy:serverMessage_RequestMapInstaceInfo(...)
	self.view:serverMessage_RequestMapInstaceInfo(...)
end
return NebulaAllStarBuildProxy
