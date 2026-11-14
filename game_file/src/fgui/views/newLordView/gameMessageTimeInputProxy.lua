local baseProxy = require("fgui.base.baseProxy")
local gameMessageTimeInputProxy = class("gameMessageTimeInputProxy", baseProxy)
function gameMessageTimeInputProxy:onRegisterEvent()
	print("=======gameMessageTimeInputProxy:onRegisterEvent")
end
return gameMessageTimeInputProxy
