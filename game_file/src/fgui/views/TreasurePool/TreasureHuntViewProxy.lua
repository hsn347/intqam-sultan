local baseProxy = require("fgui.base.baseProxy")
local TreasureHuntViewProxy = class("TreasureHuntViewProxy", baseProxy)
function TreasureHuntViewProxy:onRegisterEvent()
	print("=======TreasureHuntViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_TREVIFOUNTAIN_MULTIPLE_SUCCESS", handler(self, self.receiveData))
	SoraDAddMessage(self, "MESSAGE_TREVIFOUNTAIN_REFRESH_MULTIPLE", handler(self, self.refreshChance))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.harvestTime))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshChance))
	SoraDAddMessage(self, "MESSAGE_TREVIFOUNTAIN_ENDLESSTREASURE_REFRESH", handler(self, self.updateTreasureNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.addHarvestSeasonButton))
	SoraDAddMessage(self, "MESSAGE_HARVEST_SEASON_REDPOINT", handler(self, self.updateHarvestSeasonRedPoint))
end
function TreasureHuntViewProxy:receiveData(...)
	self.view:receiveData(...)
end
function TreasureHuntViewProxy:harvestTime(...)
	self.view:harvestTime(...)
end
function TreasureHuntViewProxy:refreshChance(...)
	self.view:refreshChance(...)
end
function TreasureHuntViewProxy:updateTreasureNum(...)
	self.view:updateTreasureNum(...)
end
function TreasureHuntViewProxy:addHarvestSeasonButton(...)
	self.view:addHarvestSeasonButton(...)
end
function TreasureHuntViewProxy:updateHarvestSeasonRedPoint(...)
	self.view:updateHarvestSeasonRedPoint(...)
end
function TreasureHuntViewProxy:setIsJumpFromEquip(...)
	self.view:setIsJumpFromEquip(...)
end
return TreasureHuntViewProxy
