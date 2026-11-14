local baseProxy = require("fgui.base.baseProxy")
local kohMigratePreViewProxy = class("kohMigratePreViewProxy", baseProxy)
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function kohMigratePreViewProxy:onRegisterEvent()
	print("=======kohMigratePreViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		local eventState = activityShowCtrl:getStateByID(self.view.activityID)
		if eventState ~= gActivityState.PREPARE then
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMDATA", handler(self, self.refreshKingdomData))
end
function kohMigratePreViewProxy:refreshKingdomData(...)
	self.view:refreshKingdomData(...)
end
return kohMigratePreViewProxy
