local baseProxy = require("fgui.base.baseProxy")
local roadToGloryPopViewProxy = class("roadToGloryPopViewProxy", baseProxy)
function roadToGloryPopViewProxy:onRegisterEvent()
	print("=======roadToGloryPopViewProxy:onRegisterEvent")
end
return roadToGloryPopViewProxy
