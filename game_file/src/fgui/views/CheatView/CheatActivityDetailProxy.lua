local baseProxy = require("fgui.base.baseProxy")
local CheatActivityDetailProxy = class("CheatActivityDetailProxy", baseProxy)
function CheatActivityDetailProxy:onRegisterEvent()
	print("=======CheatActivityDetailProxy:onRegisterEvent")
end
return CheatActivityDetailProxy
