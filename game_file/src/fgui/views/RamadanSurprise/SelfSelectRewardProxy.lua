local baseProxy = require("fgui.base.baseProxy")
local SelfSelectRewardProxy = class("SelfSelectRewardProxy", baseProxy)
function SelfSelectRewardProxy:onRegisterEvent()
	print("=======SelfSelectRewardProxy:onRegisterEvent")
end
return SelfSelectRewardProxy
