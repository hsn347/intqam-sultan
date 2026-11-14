local baseProxy = require("fgui.base.baseProxy")
local equipOverduePreViewProxy = class("equipOverduePreViewProxy", baseProxy)
function equipOverduePreViewProxy:onRegisterEvent()
	print("=======equipOverduePreViewProxy:onRegisterEvent")
end
return equipOverduePreViewProxy
