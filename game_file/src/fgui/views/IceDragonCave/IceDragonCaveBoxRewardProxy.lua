local baseProxy = require("fgui.base.baseProxy")
local IceDragonCaveBoxRewardProxy = class("IceDragonCaveBoxRewardProxy", baseProxy)
function IceDragonCaveBoxRewardProxy:onRegisterEvent()
	print("=======IceDragonCaveBoxRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function IceDragonCaveBoxRewardProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ICE_DRAGON_CAVE_ACTIVITY) then
		self.view:close()
	end
end
return IceDragonCaveBoxRewardProxy
