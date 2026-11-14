local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamDetailProxy = class("NebulaWarTeamDetailProxy", baseProxy)
function NebulaWarTeamDetailProxy:onRegisterEvent()
	print("=======NebulaWarTeamDetailProxy:onRegisterEvent")
end
return NebulaWarTeamDetailProxy
