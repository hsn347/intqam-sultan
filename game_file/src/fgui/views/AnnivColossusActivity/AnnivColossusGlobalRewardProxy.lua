local baseProxy = require("fgui.base.baseProxy")
local AnnivColossusGlobalRewardProxy = class("AnnivColossusGlobalRewardProxy", baseProxy)
function AnnivColossusGlobalRewardProxy:onRegisterEvent()
	print("=======AnnivColossusGlobalRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function AnnivColossusGlobalRewardProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY) then
		self.view:close()
	end
end
return AnnivColossusGlobalRewardProxy
