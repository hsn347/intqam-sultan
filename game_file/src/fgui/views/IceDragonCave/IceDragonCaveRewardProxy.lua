local baseProxy = require("fgui.base.baseProxy")
local IceDragonCaveRewardProxy = class("IceDragonCaveRewardProxy", baseProxy)
function IceDragonCaveRewardProxy:onRegisterEvent()
	print("=======IceDragonCaveRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function IceDragonCaveRewardProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ICE_DRAGON_CAVE_ACTIVITY) then
		self.view:close()
	end
end
return IceDragonCaveRewardProxy
