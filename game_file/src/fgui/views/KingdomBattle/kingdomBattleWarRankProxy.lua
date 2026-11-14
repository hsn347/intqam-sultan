local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleWarRankProxy = class("kingdomBattleWarRankProxy", baseProxy)
function kingdomBattleWarRankProxy:onRegisterEvent()
	print("=======kingdomBattleWarRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_RANKDATA", handler(self, self.initView))
end
function kingdomBattleWarRankProxy:initView(target, data)
	self.view:initView(target, data)
end
return kingdomBattleWarRankProxy
