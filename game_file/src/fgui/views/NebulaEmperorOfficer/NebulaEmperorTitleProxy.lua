local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorTitleProxy = class("NebulaEmperorTitleProxy", baseProxy)
function NebulaEmperorTitleProxy:onRegisterEvent()
	print("=======NebulaEmperorTitleProxy:onRegisterEvent")
end
return NebulaEmperorTitleProxy
