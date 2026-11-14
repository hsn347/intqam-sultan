local baseProxy = require("fgui.base.baseProxy")
local troopFlagTeamsProxy = class("troopFlagTeamsProxy", baseProxy)
function troopFlagTeamsProxy:onRegisterEvent()
	print("=======troopFlagTeamsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMY_TEAMORGANIZE_BACKDATA", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_WALLS_TROOPNAME_CHANGENAME", handler(self, self.renameFunc))
	SoraDAddMessage(self, "MESSAGE_ARMY_SELECT_TYPE", handler(self, self.selectArmyType))
	SoraDAddMessage(self, "MESSAGE_ARMY_TEAMSET_BACK", handler(self, self.setTeamBack))
end
function troopFlagTeamsProxy:initData(target, data)
	self.view:initData(target, data)
end
function troopFlagTeamsProxy:renameFunc(target, data)
	self.view:renameFunc(target, data)
end
function troopFlagTeamsProxy:selectArmyType(target, data)
	self.view:selectArmyType(target, data)
end
function troopFlagTeamsProxy:setTeamBack(target, data)
	self.view:setTeamBack(target, data)
end
return troopFlagTeamsProxy
