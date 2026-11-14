local baseProxy = require("fgui.base.baseProxy")
local StarTreasuryBoxProxy = class("StarTreasuryBoxProxy", baseProxy)
function StarTreasuryBoxProxy:onRegisterEvent()
	print("=======StarTreasuryBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_STAR_TREASURY", handler(self, self.onUpdateView))
end
function StarTreasuryBoxProxy:onUpdateView()
	self.view:updateView()
end
return StarTreasuryBoxProxy
