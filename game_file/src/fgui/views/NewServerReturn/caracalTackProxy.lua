local baseProxy = require("fgui.base.baseProxy")
local caracalTackProxy = class("caracalTackProxy", baseProxy)
function caracalTackProxy:onRegisterEvent()
	print("=======caracalTackProxy:onRegisterEvent")
end
return caracalTackProxy
