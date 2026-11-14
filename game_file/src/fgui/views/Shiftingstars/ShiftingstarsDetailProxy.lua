local baseProxy = require("fgui.base.baseProxy")
local ShiftingstarsDetailProxy = class("ShiftingstarsDetailProxy", baseProxy)
function ShiftingstarsDetailProxy:onRegisterEvent()
	print("=======ShiftingstarsDetailProxy:onRegisterEvent")
end
return ShiftingstarsDetailProxy
