local baseProxy = require("fgui.base.baseProxy")
local NebulaRegionProxy = class("NebulaRegionProxy", baseProxy)
function NebulaRegionProxy:onRegisterEvent()
	print("=======NebulaRegionProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_KING_DATA_BACK", handler(self, self.updateKingStar))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateActivity))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_ALL_TITLE", handler(self, self.onMsgReqAllTitleBack))
end
function NebulaRegionProxy:updateKingStar()
	self.view:updateKingStar()
	self.view:updateLegendLord()
end
function NebulaRegionProxy:updateActivity(target, data)
	self.view:updateKingStar()
	self.view:updateLegendLord()
end
function NebulaRegionProxy:onMsgReqAllTitleBack(...)
	self.view:onMsgReqAllTitleBack(...)
end
return NebulaRegionProxy
