local baseProxy = require("fgui.base.baseProxy")
local KingdomBattleTargetProxy = class("KingdomBattleTargetProxy", baseProxy)
function KingdomBattleTargetProxy:onRegisterEvent()
	print("=======KingdomBattleTargetProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_STAGE", handler(self, self.initData))
end
function KingdomBattleTargetProxy:initData(...)
	self.view:initData(...)
end
return KingdomBattleTargetProxy
