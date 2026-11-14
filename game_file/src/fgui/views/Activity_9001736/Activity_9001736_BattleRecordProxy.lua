local baseProxy = require("fgui.base.baseProxy")
local Activity_9001736_BattleRecordProxy = class("Activity_9001736_BattleRecordProxy", baseProxy)
function Activity_9001736_BattleRecordProxy:onRegisterEvent()
	print("=======Activity_9001736_BattleRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_BATTLE_RECORD", handler(self, self.onMsgUpdateBattleRecord))
end
function Activity_9001736_BattleRecordProxy:onMsgUpdateBattleRecord(...)
	self.view:onMsgUpdateBattleRecord(...)
end
return Activity_9001736_BattleRecordProxy
