local baseProxy = require("fgui.base.baseProxy")
local IceDragonLostMainProxy = class("IceDragonLostMainProxy", baseProxy)
function IceDragonLostMainProxy:onRegisterEvent()
	print("=======IceDragonLostMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ICEDRAGON_LOST_REFRESH", handler(self, self.updateView))
end
function IceDragonLostMainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function IceDragonLostMainProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.ICE_DRAGON_LOST)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
return IceDragonLostMainProxy
