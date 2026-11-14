local baseProxy = require("fgui.base.baseProxy")
local MagicLampHatchFireProxy = class("MagicLampHatchFireProxy", baseProxy)
function MagicLampHatchFireProxy:onRegisterEvent()
	print("=======MagicLampHatchFireProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_HATCH_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
end
function MagicLampHatchFireProxy:msgUpdateView(target, msgdata)
	self.view:updateView()
	if msgdata.extra ~= nil then
		if msgdata.extra.rate ~= 1 then
			_ENV = nil
			;(nil).extra = msgdata.extra
			uiManager:show("MagicLampHatchAward", nil)
		else
			SoraDMailGainItems(msgdata.extra.rewards, true)
		end
	end
end
return MagicLampHatchFireProxy
