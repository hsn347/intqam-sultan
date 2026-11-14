local baseProxy = require("fgui.base.baseProxy")
local WarframeForgProxy = class("WarframeForgProxy", baseProxy)
function WarframeForgProxy:onRegisterEvent()
	print("=======WarframeForgProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMY_TRAIN_IMM_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_FORG_WARFRAME_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_FORGING_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WARFRAME_NOTIFY", handler(self, self.updateWearButtonVisible))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WARFRAME_PROMOTE_BACK", handler(self, self.updateData))
end
function WarframeForgProxy:updateData()
	self.view:updateData()
end
function WarframeForgProxy:updateWearButtonVisible()
	self.view:updateWearButtonVisible()
end
return WarframeForgProxy
