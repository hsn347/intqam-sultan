local baseProxy = require("fgui.base.baseProxy")
local RemindCheckPopBoxProxy = class("RemindCheckPopBoxProxy", baseProxy)
function RemindCheckPopBoxProxy:onRegisterEvent()
	print("=======RemindCheckPopBoxProxy:onRegisterEvent")
end
return RemindCheckPopBoxProxy
