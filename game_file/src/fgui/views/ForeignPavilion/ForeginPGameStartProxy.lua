local baseProxy = require("fgui.base.baseProxy")
local ForeginPGameStartProxy = class("ForeginPGameStartProxy", baseProxy)
function ForeginPGameStartProxy:onRegisterEvent()
	print("=======ForeginPGameStartProxy:onRegisterEvent")
end
return ForeginPGameStartProxy
