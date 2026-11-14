local baseProxy = require("fgui.base.baseProxy")
local WorldMapBossViewProxy = class("WorldMapBossViewProxy", baseProxy)
function WorldMapBossViewProxy:onRegisterEvent()
	print("=======WorldMapBossViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MONSTERSEARCH_DATAARRIVE", handler(self, self.msgBackData))
end
function WorldMapBossViewProxy:serverMessage_RequestMapInstaceInfo(...)
	self.view:serverMessage_RequestMapInstaceInfo(...)
end
function WorldMapBossViewProxy:msgBackData(...)
	self.view:msgBackData(...)
end
return WorldMapBossViewProxy
