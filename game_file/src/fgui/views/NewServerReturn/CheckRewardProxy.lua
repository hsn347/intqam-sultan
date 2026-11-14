local baseProxy = require("fgui.base.baseProxy")
local CheckRewardProxy = class("CheckRewardProxy", baseProxy)
function CheckRewardProxy:onRegisterEvent()
	print("=======CheckRewardProxy:onRegisterEvent")
end
return CheckRewardProxy
