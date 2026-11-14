local baseProxy = require("fgui.base.baseProxy")
local neckTechDetailViewProxy = class("neckTechDetailViewProxy", baseProxy)
function neckTechDetailViewProxy:onRegisterEvent()
	print("=======neckTechDetailViewProxy:onRegisterEvent")
end
return neckTechDetailViewProxy
