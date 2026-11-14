local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorBuildProxy = class("NebulaEmperorBuildProxy", baseProxy)
function NebulaEmperorBuildProxy:onRegisterEvent()
	print("=======NebulaEmperorBuildProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_ENERGY_DATA", handler(self, self.onMsgEnergyDataBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_GET_RANK", handler(self, self.onMsgGetPlayerRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_BUILD_UPDATE", handler(self, self.onMsgUpdateBuild))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
end
function NebulaEmperorBuildProxy:onMsgEnergyDataBack(...)
	self.view:onMsgEnergyDataBack()
end
function NebulaEmperorBuildProxy:onMsgGetPlayerRank(...)
	self.view:onMsgGetPlayerRank(...)
end
function NebulaEmperorBuildProxy:onMsgUpdateBuild(target, event)
	self.view:onMsgUpdateBuild(target, event)
end
function NebulaEmperorBuildProxy:serverMessage_RequestMapInstaceInfo(...)
	self.view:serverMessage_RequestMapInstaceInfo(...)
end
return NebulaEmperorBuildProxy
