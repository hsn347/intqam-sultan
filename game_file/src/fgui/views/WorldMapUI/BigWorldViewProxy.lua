local baseProxy = require("fgui.base.baseProxy")
local BigWorldViewProxy = class("BigWorldViewProxy", baseProxy)
function BigWorldViewProxy:onRegisterEvent()
	print("=======BigWorldViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOM_STATUS", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOM_LV_CHANGE", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_CONQUESTWAR_FRESH", handler(self, self.initConquestWarData))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_KINGDOM_JUMP", handler(self, self.jumpToKingdom))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_KINGDOM_CHANGE", handler(self, self.changeToKingdom))
	SoraDAddMessage(self, "MESSAGE_NEBULA_GET_TOWER_GROUP", handler(self, self.onMsgGetTowerGroup))
	SoraDAddMessage(self, "MESSAGE_NEBULA_GET_TOWER_DATA", handler(self, self.onMsgGetTowerGroup))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.onNebulaRefreshData))
end
function BigWorldViewProxy:refreshData(...)
	self.view:refreshData(...)
end
function BigWorldViewProxy:initConquestWarData(...)
	self.view:initConquestWarData(...)
end
function BigWorldViewProxy:jumpToKingdom(...)
	self.view:jumpToKingdom(...)
end
function BigWorldViewProxy:changeToKingdom(...)
	self.view:changeToKingdom(...)
end
function BigWorldViewProxy:onMsgGetTowerGroup(...)
	self.view:onMsgGetTowerGroup(...)
end
function BigWorldViewProxy:onNebulaRefreshData(...)
	self.view:onNebulaRefreshData(...)
end
return BigWorldViewProxy
