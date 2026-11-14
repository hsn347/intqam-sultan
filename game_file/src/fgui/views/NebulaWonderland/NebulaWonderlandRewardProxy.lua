local baseProxy = require("fgui.base.baseProxy")
local NebulaWonderlandRewardProxy = class("NebulaWonderlandRewardProxy", baseProxy)
function NebulaWonderlandRewardProxy:onRegisterEvent()
	print("=======NebulaWonderlandRewardProxy:onRegisterEvent")
end
return NebulaWonderlandRewardProxy
