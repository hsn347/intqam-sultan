local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleRankProxy = class("kingdomBattleRankProxy", baseProxy)
function kingdomBattleRankProxy:onRegisterEvent()
	print("=======kingdomBattleRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_RANKDATA", handler(self, self.initData))
end
function kingdomBattleRankProxy:initData(...)
	self.view:initData(...)
end
return kingdomBattleRankProxy
