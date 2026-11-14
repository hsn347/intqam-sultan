local baseProxy = require("fgui.base.baseProxy")
local NebulaWarOtherVSProxy = class("NebulaWarOtherVSProxy", baseProxy)
function NebulaWarOtherVSProxy:onRegisterEvent()
	print("=======NebulaWarOtherVSProxy:onRegisterEvent")
end
return NebulaWarOtherVSProxy
