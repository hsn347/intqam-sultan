local baseProxy = require("fgui.base.baseProxy")
local WarframeStoreRoomProxy = class("WarframeStoreRoomProxy", baseProxy)
function WarframeStoreRoomProxy:onRegisterEvent()
	print("=======WarframeStoreRoomProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_FORG_WARFRAME_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WARFRAME_NOTIFY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_BACK", handler(self, self.updateView))
end
function WarframeStoreRoomProxy:updateView()
	self.view:initData()
end
return WarframeStoreRoomProxy
