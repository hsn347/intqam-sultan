local baseProxy = require("fgui.base.baseProxy")
local NebulaWarEnterActionProxy = class("NebulaWarEnterActionProxy", baseProxy)
function NebulaWarEnterActionProxy:onRegisterEvent()
	print("=======NebulaWarEnterActionProxy:onRegisterEvent")
end
return NebulaWarEnterActionProxy
