local baseProxy = require("fgui.base.baseProxy")
local RomanPointExplainProxy = class("RomanPointExplainProxy", baseProxy)
function RomanPointExplainProxy:onRegisterEvent()
	print("=======RomanPointExplainProxy:onRegisterEvent")
end
return RomanPointExplainProxy
