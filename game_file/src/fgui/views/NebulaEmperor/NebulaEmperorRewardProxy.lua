local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorRewardProxy = class("NebulaEmperorRewardProxy", baseProxy)
function NebulaEmperorRewardProxy:onRegisterEvent()
	print("=======NebulaEmperorRewardProxy:onRegisterEvent")
end
return NebulaEmperorRewardProxy
