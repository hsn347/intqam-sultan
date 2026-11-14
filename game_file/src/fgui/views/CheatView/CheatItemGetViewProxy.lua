local baseProxy = require("fgui.base.baseProxy")
local CheatItemGetViewProxy = class("CheatItemGetViewProxy", baseProxy)
function CheatItemGetViewProxy:onRegisterEvent()
	print("=======CheatItemGetViewProxy:onRegisterEvent")
end
return CheatItemGetViewProxy
