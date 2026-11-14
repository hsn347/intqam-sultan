local baseProxy = require("fgui.base.baseProxy")
local allianceMainViewProxy = class("allianceMainViewProxy", baseProxy)
function allianceMainViewProxy:onRegisterEvent()
	print("=======allianceMainViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_LOG_SUCCESS", handler(self, self.updateLogData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_LOG_ADD_SUCCESS", handler(self, self.updateLogData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_NOTICE_CHANGE_SUCCESS", handler(self, self.updateLogData))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateGreen))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.initActivityData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GUIDE_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SETTINGS_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CHANGE_FLAG_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(...)
		SoraDRemoveAllPanelFromManager()
	end)
end
function allianceMainViewProxy:updateLogData(target, data)
	self.view:setLogInfo(target, data)
end
function allianceMainViewProxy:updateGreen(target, data)
	self.view:updateGreen(target, data)
end
function allianceMainViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function allianceMainViewProxy:initActivityData(target, data)
	if data.eventID == gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY then
		self.view:initData(target, data)
	end
end
return allianceMainViewProxy
