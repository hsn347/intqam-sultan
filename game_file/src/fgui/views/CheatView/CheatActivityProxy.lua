local baseProxy = require("fgui.base.baseProxy")
local CheatActivityProxy = class("CheatActivityProxy", baseProxy)
function CheatActivityProxy:onRegisterEvent()
	print("=======CheatActivityProxy:onRegisterEvent")
end
return CheatActivityProxy
