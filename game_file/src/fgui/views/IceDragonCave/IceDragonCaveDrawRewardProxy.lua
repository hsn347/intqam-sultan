local baseProxy = require("fgui.base.baseProxy")
local IceDragonCaveDrawRewardProxy = class("IceDragonCaveDrawRewardProxy", baseProxy)
function IceDragonCaveDrawRewardProxy:onRegisterEvent()
	print("=======IceDragonCaveDrawRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function IceDragonCaveDrawRewardProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ICE_DRAGON_CAVE_ACTIVITY) then
		self.view:close()
	end
end
return IceDragonCaveDrawRewardProxy
