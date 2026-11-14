local baseProxy = require("fgui.base.baseProxy")
local ManorDressDetailProxy = class("ManorDressDetailProxy", baseProxy)
function ManorDressDetailProxy:onRegisterEvent()
	print("=======ManorDressDetailProxy:onRegisterEvent")
end
return ManorDressDetailProxy
