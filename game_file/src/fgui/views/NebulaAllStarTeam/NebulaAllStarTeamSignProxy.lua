local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarTeamSignProxy = class("NebulaAllStarTeamSignProxy", baseProxy)
function NebulaAllStarTeamSignProxy:onRegisterEvent()
	print("=======NebulaAllStarTeamSignProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SIGN_RANK", handler(self, self.onMsgSignRankBack))
end
function NebulaAllStarTeamSignProxy:onMsgSignRankBack(...)
	self.view:onMsgSignRankBack(...)
end
return NebulaAllStarTeamSignProxy
