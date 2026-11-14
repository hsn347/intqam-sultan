local baseProxy = require("fgui.base.baseProxy")
local MagicLampHatchProxy = class("MagicLampHatchProxy", baseProxy)
function MagicLampHatchProxy:onRegisterEvent()
	print("=======MagicLampHatchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_HATCH_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.onTimerUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.refreshItem))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshItem))
end
function MagicLampHatchProxy:refreshItem()
	self.view:updateRedPoint()
end
function MagicLampHatchProxy:msgUpdateView(target, msgdata)
	self.view:updateView()
	if msgdata.extra ~= nil then
		for i, v in ipairs(msgdata.extra) do
			if v.rate ~= 1 then
				_ENV = nil
				;(nil).extra = v
				uiManager:show("MagicLampHatchAward", nil)
			else
				SoraDMailGainItems(v.rewards, true)
			end
		end
	end
end
function MagicLampHatchProxy:onTimerUpdate()
	self.view:updateTimers()
end
return MagicLampHatchProxy
