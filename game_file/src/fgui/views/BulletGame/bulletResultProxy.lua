local baseProxy = require("fgui.base.baseProxy")
local bulletResultProxy = class("bulletResultProxy", baseProxy)
function bulletResultProxy:onRegisterEvent()
	print("=======bulletResultProxy:onRegisterEvent")
end
return bulletResultProxy
