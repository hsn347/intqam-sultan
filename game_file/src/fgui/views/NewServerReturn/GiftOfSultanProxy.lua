local baseProxy = require("fgui.base.baseProxy")
local GiftOfSultanProxy = class("GiftOfSultanProxy", baseProxy)
function GiftOfSultanProxy:onRegisterEvent()
	print("=======GiftOfSultanProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WEALTH_INHERIT_MENU", handler(self, self.closeMenu))
end
function GiftOfSultanProxy:closeMenu(target, data)
	if self.view then
		self.view:closeMenu()
	end
end
return GiftOfSultanProxy
