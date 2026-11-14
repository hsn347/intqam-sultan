local baseProxy = require("fgui.base.baseProxy")
local allianceMobAwardViewProxy = class("allianceMobAwardViewProxy", baseProxy)
function allianceMobAwardViewProxy:onRegisterEvent()
	print("=======allianceMobAwardViewProxy:onRegisterEvent")
end
return allianceMobAwardViewProxy
