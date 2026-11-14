local baseProxy = require("fgui.base.baseProxy")
local SnowmanCelebrationShopProxy = class("SnowmanCelebrationShopProxy", baseProxy)
function SnowmanCelebrationShopProxy:onRegisterEvent()
	print("=======SnowmanCelebrationShopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_DONATE", handler(self, self.refreshView))
end
function SnowmanCelebrationShopProxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
return SnowmanCelebrationShopProxy
