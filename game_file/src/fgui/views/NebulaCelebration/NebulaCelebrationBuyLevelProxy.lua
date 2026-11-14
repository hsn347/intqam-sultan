local baseProxy = require("fgui.base.baseProxy")
local NebulaCelebrationBuyLevelProxy = class("NebulaCelebrationBuyLevelProxy", baseProxy)
function NebulaCelebrationBuyLevelProxy:onRegisterEvent()
	print("=======NebulaCelebrationBuyLevelProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_CELEBRATION_BUY_STARLIGHT", handler(self, self.onBuyStarlight))
end
function NebulaCelebrationBuyLevelProxy:onBuyStarlight()
	self.view:close()
end
return NebulaCelebrationBuyLevelProxy
