local baseProxy = require("fgui.base.baseProxy")
local cityInfoResViewProxy = class("cityInfoResViewProxy", baseProxy)
function cityInfoResViewProxy:onRegisterEvent()
	print("=======cityInfoResViewProxy:onRegisterEvent")
end
return cityInfoResViewProxy
