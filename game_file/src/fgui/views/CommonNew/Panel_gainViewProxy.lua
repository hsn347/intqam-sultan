local baseProxy = require("fgui.base.baseProxy")
local Panel_gainViewProxy = class("Panel_gainViewProxy", baseProxy)
function Panel_gainViewProxy:onRegisterEvent()
	print("=======Panel_gainViewProxy:onRegisterEvent")
end
return Panel_gainViewProxy
