local baseProxy = require("fgui.base.baseProxy")
local AtlantisTreasureProxy = class("AtlantisTreasureProxy", baseProxy)
function AtlantisTreasureProxy:onRegisterEvent()
	print("=======AtlantisTreasureProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_TREASUREINFO_REFRESH", handler(self, self.msgRefreshView))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SENDTREASURE_REFRESH", handler(self, self.msgRefreshTreasure))
end
function AtlantisTreasureProxy:msgRefreshView(target, data)
	self.view:refreshView()
end
function AtlantisTreasureProxy:msgRefreshTreasure(target, data)
	self.view:refreshTreasureData()
end
return AtlantisTreasureProxy
