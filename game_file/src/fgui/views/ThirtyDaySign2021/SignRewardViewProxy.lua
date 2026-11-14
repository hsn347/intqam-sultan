local baseProxy = require("fgui.base.baseProxy")
local SignRewardViewProxy = class("SignRewardViewProxy", baseProxy)
function SignRewardViewProxy:onRegisterEvent()
	print("=======SignRewardViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.dispatchFun))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.setGoldNum))
end
function SignRewardViewProxy:dispatchFun(target, retData)
	if self.view then
		self.view:close()
	end
end
function SignRewardViewProxy:setGoldNum()
	if self.view then
		self.view:setGoldNum()
	end
end
return SignRewardViewProxy
