local baseProxy = require("fgui.base.baseProxy")
local AtlantisBriefEditProxy = class("AtlantisBriefEditProxy", baseProxy)
function AtlantisBriefEditProxy:onRegisterEvent()
	print("=======AtlantisBriefEditProxy:onRegisterEvent")
end
return AtlantisBriefEditProxy
