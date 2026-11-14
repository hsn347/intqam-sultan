local baseProxy = require("fgui.base.baseProxy")
local IceDragonLostTaskProxy = class("IceDragonLostTaskProxy", baseProxy)
function IceDragonLostTaskProxy:onRegisterEvent()
	print("=======IceDragonLostTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ICEDRAGON_LOST_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function IceDragonLostTaskProxy:onUpdateView()
	self.view:updateView()
end
function IceDragonLostTaskProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.ICE_DRAGON_LOST)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
return IceDragonLostTaskProxy
