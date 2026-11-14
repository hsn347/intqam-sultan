local baseProxy = require("fgui.base.baseProxy")
local allianceFirstJoinViewProxy = class("allianceFirstJoinViewProxy", baseProxy)
function allianceFirstJoinViewProxy:onRegisterEvent()
	print("=======allianceFirstJoinViewProxy:onRegisterEvent")
end
return allianceFirstJoinViewProxy
