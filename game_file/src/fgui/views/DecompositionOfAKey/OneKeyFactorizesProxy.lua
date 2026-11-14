local baseProxy = require("fgui.base.baseProxy")
local OneKeyFactorizesProxy = class("OneKeyFactorizesProxy", baseProxy)
function OneKeyFactorizesProxy:onRegisterEvent()
	print("=======OneKeyFactorizesProxy:onRegisterEvent")
end
return OneKeyFactorizesProxy
