local baseProxy = require("fgui.base.baseProxy")
local gameMessageProxy = class("gameMessageProxy", baseProxy)
function gameMessageProxy:onRegisterEvent()
	print("=======gameMessageProxy:onRegisterEvent")
end
return gameMessageProxy
