local baseProxy = require("fgui.base.baseProxy")
local NebulaWarCampDesProxy = class("NebulaWarCampDesProxy", baseProxy)
function NebulaWarCampDesProxy:onRegisterEvent()
	print("=======NebulaWarCampDesProxy:onRegisterEvent")
end
return NebulaWarCampDesProxy
