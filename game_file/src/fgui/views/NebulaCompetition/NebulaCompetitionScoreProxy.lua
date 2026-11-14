local baseProxy = require("fgui.base.baseProxy")
local NebulaCompetitionScoreProxy = class("NebulaCompetitionScoreProxy", baseProxy)
function NebulaCompetitionScoreProxy:onRegisterEvent()
	print("=======NebulaCompetitionScoreProxy:onRegisterEvent")
end
return NebulaCompetitionScoreProxy
