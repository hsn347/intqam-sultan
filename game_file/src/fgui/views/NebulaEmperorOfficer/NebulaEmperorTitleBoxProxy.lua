local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorTitleBoxProxy = class("NebulaEmperorTitleBoxProxy", baseProxy)
function NebulaEmperorTitleBoxProxy:onRegisterEvent()
	print("=======NebulaEmperorTitleBoxProxy:onRegisterEvent")
end
return NebulaEmperorTitleBoxProxy
