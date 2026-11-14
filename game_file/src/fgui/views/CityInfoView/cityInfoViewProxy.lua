local baseProxy = require("fgui.base.baseProxy")
local cityInfoViewProxy = class("cityInfoViewProxy", baseProxy)
function cityInfoViewProxy:onRegisterEvent()
	print("=======cityInfoViewProxy:onRegisterEvent")
end
return cityInfoViewProxy
