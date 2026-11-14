local baseProxy = require("fgui.base.baseProxy")
local WarframeForgDetailProxy = class("WarframeForgDetailProxy", baseProxy)
function WarframeForgDetailProxy:onRegisterEvent()
	print("=======WarframeForgDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_FORG_WARFRAME_BACK", handler(self, self.forgBack))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_BACK", handler(self, self.updateUIInfo))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_ARMY", handler(self, self.updateUIInfo))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateTrain))
	SoraDAddMessage(self, "MESSAGE_ARMY_TRAIN_IMM_BACK", handler(self, self.updateUIInfo))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateUIInfo))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_FORGING_SUCCESS", handler(self, self.successBack))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WARFRAME_PROMOTE_BACK", handler(self, self.successBack))
end
function WarframeForgDetailProxy:successBack(target, data)
	if tonumber(data.armorId) == self.view.armorId then
		self.view:initData(data.armorId)
	end
end
function WarframeForgDetailProxy:forgBack(target, data)
	if tonumber(data.armorId) == self.view.armorId then
		SoraDCloseLoading(self.view)
		self.view:initData(data.armorId)
	end
end
function WarframeForgDetailProxy:updateTrain()
	self.view:updateTrain()
end
function WarframeForgDetailProxy:updateUIInfo()
	self.view:updateItemNum()
end
return WarframeForgDetailProxy
