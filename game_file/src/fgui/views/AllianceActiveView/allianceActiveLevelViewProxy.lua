local baseProxy = require("fgui.base.baseProxy")
local allianceActiveLevelViewProxy = class("allianceActiveLevelViewProxy", baseProxy)
function allianceActiveLevelViewProxy:onRegisterEvent()
	print("=======allianceActiveLevelViewProxy:onRegisterEvent")
end
return allianceActiveLevelViewProxy
