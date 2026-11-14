local baseProxy = require("fgui.base.baseProxy")
local WorldMapFeastViewProxy = class("WorldMapFeastViewProxy", baseProxy)
function WorldMapFeastViewProxy:onRegisterEvent()
	print("=======WorldMapFeastViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.onMsgMapEventListInfoNew))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001625_UPDATE", handler(self, self.onMsgUpdateData))
end
function WorldMapFeastViewProxy:onMsgMapEventListInfoNew(...)
	self.view:onMsgMapEventListInfoNew(...)
end
function WorldMapFeastViewProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return WorldMapFeastViewProxy
