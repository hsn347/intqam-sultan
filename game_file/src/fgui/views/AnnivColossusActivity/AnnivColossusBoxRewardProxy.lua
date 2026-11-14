local baseProxy = require("fgui.base.baseProxy")
local AnnivColossusBoxRewardProxy = class("AnnivColossusBoxRewardProxy", baseProxy)
function AnnivColossusBoxRewardProxy:onRegisterEvent()
	print("=======AnnivColossusBoxRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ANNIV_COLOSSUS_GET_REWARD", handler(self, self.onGetReward))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function AnnivColossusBoxRewardProxy:onGetReward(target, data)
	self.view:close()
end
function AnnivColossusBoxRewardProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY) then
		self.view:close()
	end
end
return AnnivColossusBoxRewardProxy
