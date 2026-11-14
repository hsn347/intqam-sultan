local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarTeamCommanderProxy = class("NebulaAllStarTeamCommanderProxy", baseProxy)
function NebulaAllStarTeamCommanderProxy:onRegisterEvent()
	print("=======NebulaAllStarTeamCommanderProxy:onRegisterEvent")
end
return NebulaAllStarTeamCommanderProxy
