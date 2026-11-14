local baseProxy = require("fgui.base.baseProxy")
local OpenSesameAwardProxy = class("OpenSesameAwardProxy", baseProxy)
function OpenSesameAwardProxy:onRegisterEvent()
	print("=======OpenSesameAwardProxy:onRegisterEvent")
end
return OpenSesameAwardProxy
