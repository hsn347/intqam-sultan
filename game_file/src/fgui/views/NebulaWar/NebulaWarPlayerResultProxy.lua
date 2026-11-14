local baseProxy = require("fgui.base.baseProxy")
local NebulaWarPlayerResultProxy = class("NebulaWarPlayerResultProxy", baseProxy)
function NebulaWarPlayerResultProxy:onRegisterEvent()
	print("=======NebulaWarPlayerResultProxy:onRegisterEvent")
end
return NebulaWarPlayerResultProxy
