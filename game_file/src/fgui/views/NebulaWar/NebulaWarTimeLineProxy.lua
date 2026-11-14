local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTimeLineProxy = class("NebulaWarTimeLineProxy", baseProxy)
function NebulaWarTimeLineProxy:onRegisterEvent()
	print("=======NebulaWarTimeLineProxy:onRegisterEvent")
end
return NebulaWarTimeLineProxy
