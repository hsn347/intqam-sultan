local baseProxy = require("fgui.base.baseProxy")
local equipOverdueGainViewProxy = class("equipOverdueGainViewProxy", baseProxy)
function equipOverdueGainViewProxy:onRegisterEvent()
	print("=======equipOverdueGainViewProxy:onRegisterEvent")
end
return equipOverdueGainViewProxy
