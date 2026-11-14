local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameMapViewProxy = class("RoaringFlameMapViewProxy", baseProxy)
function RoaringFlameMapViewProxy:onRegisterEvent()
	print("=======RoaringFlameMapViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUILD_LOG", handler(self, self.onMsgUpdateBuildLog))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUILDING_OWNER", handler(self, self.onMsgBuildingInfo))
end
function RoaringFlameMapViewProxy:onMsgUpdateBuildLog(...)
	self.view:onMsgUpdateBuildLog(...)
end
function RoaringFlameMapViewProxy:onMsgBuildingInfo(...)
	self.view:onMsgBuildingInfo(...)
end
return RoaringFlameMapViewProxy
