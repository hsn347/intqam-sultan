local baseProxy = require("fgui.base.baseProxy")
local Activity_9001736_BattleListProxy = class("Activity_9001736_BattleListProxy", baseProxy)
function Activity_9001736_BattleListProxy:onRegisterEvent()
	print("=======Activity_9001736_BattleListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_BATTLE_LIST", handler(self, self.onMsgUpdateBattleList))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_UPDATE_DATA", handler(self, self.onMsgUpdateData))
end
function Activity_9001736_BattleListProxy:onMsgUpdateBattleList(...)
	self.view:onMsgUpdateBattleList(...)
end
function Activity_9001736_BattleListProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001736_BattleListProxy
