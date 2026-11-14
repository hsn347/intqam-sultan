local baseProxy = require("fgui.base.baseProxy")
local MagicLampSkillExchangeProxy = class("MagicLampSkillExchangeProxy", baseProxy)
function MagicLampSkillExchangeProxy:onRegisterEvent()
	print("=======MagicLampSkillExchangeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SPECIALTIME_REFRESH", handler(self, self.setTime))
end
function MagicLampSkillExchangeProxy:initData(target, data)
	if self.view then
		self.view:initData(target, data)
	end
end
function MagicLampSkillExchangeProxy:closeLoading()
	print("maybe have some error")
	SoraDCloseLoading(display.object)
	self:initData()
end
function MagicLampSkillExchangeProxy:judgeClose()
	if self.view then
		self:close()
	end
end
function MagicLampSkillExchangeProxy:setTime()
	if self.view then
		self.view:setTime()
		self.view:initData()
	end
end
return MagicLampSkillExchangeProxy
