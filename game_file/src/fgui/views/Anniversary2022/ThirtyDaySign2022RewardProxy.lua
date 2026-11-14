local baseProxy = require("fgui.base.baseProxy")
local ThirtyDaySign2022RewardProxy = class("ThirtyDaySign2022RewardProxy", baseProxy)
function ThirtyDaySign2022RewardProxy:onRegisterEvent()
	print("=======ThirtyDaySign2022RewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.dispatchFun))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.setGoldNum))
end
function ThirtyDaySign2022RewardProxy:dispatchFun(target, retData)
	if self.view then
		self.view:close()
	end
end
function ThirtyDaySign2022RewardProxy:setGoldNum()
	if self.view then
		self.view:setGoldNum()
	end
end
return ThirtyDaySign2022RewardProxy
