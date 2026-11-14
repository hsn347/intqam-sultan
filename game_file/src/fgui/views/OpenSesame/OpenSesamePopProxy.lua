local baseProxy = require("fgui.base.baseProxy")
local OpenSesamePopProxy = class("OpenSesamePopProxy", baseProxy)
function OpenSesamePopProxy:onRegisterEvent()
	print("=======OpenSesamePopProxy:onRegisterEvent")
end
return OpenSesamePopProxy
