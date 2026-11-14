local baseProxy = require("fgui.base.baseProxy")
local allianceStoreHouseViewProxy = class("allianceStoreHouseViewProxy", baseProxy)
function allianceStoreHouseViewProxy:onRegisterEvent()
	print("=======allianceStoreHouseViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_LIST_REFRESH", handler(self, self.showTreasureListView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_DIGLIST_REFRESH", handler(self, self.showMyTreasureView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH", handler(self, self.showHelpListView))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.refreshGreenPoint))
end
function allianceStoreHouseViewProxy:showTreasureListView(target, data)
	self.view:showTreasureListView(target, data)
end
function allianceStoreHouseViewProxy:showMyTreasureView(target, data)
	self.view:showMyTreasureView(target, data)
end
function allianceStoreHouseViewProxy:showHelpListView(target, data)
	self.view:showHelpListView(target, data)
end
function allianceStoreHouseViewProxy:refreshGreenPoint(target, data)
	self.view:refreshGreenPoint(target, data)
end
return allianceStoreHouseViewProxy
