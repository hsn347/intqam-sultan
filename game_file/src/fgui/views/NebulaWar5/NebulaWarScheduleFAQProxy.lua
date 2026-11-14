local baseProxy = require("fgui.base.baseProxy")
local NebulaWarScheduleFAQProxy = class("NebulaWarScheduleFAQProxy", baseProxy)
function NebulaWarScheduleFAQProxy:onRegisterEvent()
	print("=======NebulaWarScheduleFAQProxy:onRegisterEvent")
end
return NebulaWarScheduleFAQProxy
