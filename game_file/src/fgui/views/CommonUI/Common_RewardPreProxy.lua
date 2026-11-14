local baseProxy = require("fgui.base.baseProxy")
local Common_RewardPreProxy = class("Common_RewardPreProxy", baseProxy)
function Common_RewardPreProxy:onRegisterEvent()
	print("=======Common_RewardPreProxy:onRegisterEvent")
end
return Common_RewardPreProxy
