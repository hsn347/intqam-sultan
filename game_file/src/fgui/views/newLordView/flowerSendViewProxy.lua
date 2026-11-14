local baseProxy = require("fgui.base.baseProxy")
local flowerSendViewProxy = class("flowerSendViewProxy", baseProxy)
function flowerSendViewProxy:onRegisterEvent()
	print("=======flowerSendViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_FLOWER_NUM", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_FLOWER_SEND", handler(self, self.sendFlower))
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.initScroll))
end
function flowerSendViewProxy:initView(target, data)
	self.view:initView(target, data)
end
function flowerSendViewProxy:refreshData(target, data)
	self.view:refreshData(target, data)
end
function flowerSendViewProxy:sendFlower(target, data)
	self.view:sendFlower(target, data)
end
function flowerSendViewProxy:initScroll()
	self.view:initScroll()
end
return flowerSendViewProxy
