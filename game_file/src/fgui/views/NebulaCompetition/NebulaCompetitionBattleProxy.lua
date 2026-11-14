local baseProxy = require("fgui.base.baseProxy")
local NebulaCompetitionBattleProxy = class("NebulaCompetitionBattleProxy", baseProxy)
function NebulaCompetitionBattleProxy:onRegisterEvent()
	print("=======NebulaCompetitionBattleProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_CAMPSCORE_DATA", handler(self, self.onUpdateView))
end
function NebulaCompetitionBattleProxy:onUpdateView()
	self.view:updateView()
end
return NebulaCompetitionBattleProxy
