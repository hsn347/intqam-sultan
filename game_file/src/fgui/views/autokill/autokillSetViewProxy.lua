local baseProxy = require("fgui.base.baseProxy")
local autokillSetViewProxy = class("autokillSetViewProxy", baseProxy)
function autokillSetViewProxy:onRegisterEvent()
	print("=======autokillSetViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMY_TEAMORGANIZE_BACKDATA", handler(self, self.adaptTeam))
	SoraDAddMessage(self, "MESSAGE_WALLS_TROOPNAME_CHANGENAME", handler(self, self.renameFunc))
	SoraDAddMessage(self, "MESSAGE_SERVER_AUTO_KILL_INIT_DATA", handler(self, self.reqSetDataRSP))
	SoraDAddMessage(self, "MESSAGE_UI_AUTO_KILL_ITEM_SETFINAL", handler(self, self.handleSetItem))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_INIT", handler(self, self.updateTroopList))
end
function autokillSetViewProxy:adaptTeam(target, data)
	self.view:adaptTeam(target, data)
end
function autokillSetViewProxy:renameFunc(target, data)
	self.view:renameFunc(target, data)
end
function autokillSetViewProxy:reqSetDataRSP(target, data)
	self.view:reqSetDataRSP(target, data)
end
function autokillSetViewProxy:handleSetItem(target, data)
	self.view:handleSetItem(target, data)
end
function autokillSetViewProxy:updateTroopList(target, data)
	self.view:updateTroopList(target, data)
end
return autokillSetViewProxy
