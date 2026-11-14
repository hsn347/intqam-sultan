local baseProxy = require("fgui.base.baseProxy")
local NebulaCompetitionKingdomsProxy = class("NebulaCompetitionKingdomsProxy", baseProxy)
function NebulaCompetitionKingdomsProxy:onRegisterEvent()
	print("=======NebulaCompetitionKingdomsProxy:onRegisterEvent")
end
return NebulaCompetitionKingdomsProxy
