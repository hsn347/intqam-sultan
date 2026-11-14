local baseProxy = require("fgui.base.baseProxy")
local flowerOwnViewProxy = class("flowerOwnViewProxy", baseProxy)
function flowerOwnViewProxy:onRegisterEvent()
	print("=======flowerOwnViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_FLOWER_INFO", handler(self, self.initData))
end
function flowerOwnViewProxy:initData()
	self.view:initData()
end
return flowerOwnViewProxy
