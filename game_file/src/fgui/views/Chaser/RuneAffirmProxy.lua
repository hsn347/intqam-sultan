local baseProxy = require("fgui.base.baseProxy")
local RuneAffirmProxy = class("RuneAffirmProxy", baseProxy)
function RuneAffirmProxy:onRegisterEvent()
	print("=======RuneAffirmProxy:onRegisterEvent")
end
return RuneAffirmProxy
