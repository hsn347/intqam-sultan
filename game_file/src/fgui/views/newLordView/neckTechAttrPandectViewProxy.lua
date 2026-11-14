local baseProxy = require("fgui.base.baseProxy")
local neckTechAttrPandectViewProxy = class("neckTechAttrPandectViewProxy", baseProxy)
function neckTechAttrPandectViewProxy:onRegisterEvent()
	print("=======neckTechAttrPandectViewProxy:onRegisterEvent")
end
return neckTechAttrPandectViewProxy
