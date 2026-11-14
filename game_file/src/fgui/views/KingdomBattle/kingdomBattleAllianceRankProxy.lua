local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleAllianceRankProxy = class("kingdomBattleAllianceRankProxy", baseProxy)
function kingdomBattleAllianceRankProxy:onRegisterEvent()
	print("=======kingdomBattleAllianceRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_ALLIANCE_RANKDATA", handler(self, self.initData))
end
function kingdomBattleAllianceRankProxy:initData(...)
	self.view:initData(...)
end
return kingdomBattleAllianceRankProxy
