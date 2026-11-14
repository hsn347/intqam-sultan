local baseProxy = require("fgui.base.baseProxy")
local CommonStageReward2Proxy = class("CommonStageReward2Proxy", baseProxy)
function CommonStageReward2Proxy:onRegisterEvent()
	print("=======CommonStageReward2Proxy:onRegisterEvent")
end
return CommonStageReward2Proxy
