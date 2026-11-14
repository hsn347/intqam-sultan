local baseProxy = require("fgui.base.baseProxy")
local troopFlagViewProxy = class("troopFlagViewProxy", baseProxy)
function troopFlagViewProxy:onRegisterEvent()
	print("=======troopFlagViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMY_DISMISSAL", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ARMY_TRAIN_IMM_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_COOLING_PANEL", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_ARMY", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_WALLS_TROOPNAME_CHANGENAME", handler(self, self.renameFunc))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_INIT", handler(self, self.renameFunc))
end
function troopFlagViewProxy:refreshData(target, data)
	self.view:refreshData(target, data)
end
function troopFlagViewProxy:renameFunc(target, data)
	self.view:renameFunc(target, data)
end
return troopFlagViewProxy
