local baseProxy = require("fgui.base.baseProxy")
local CommonStageRewardProxy = class("CommonStageRewardProxy", baseProxy)
function CommonStageRewardProxy:onRegisterEvent()
	print("=======CommonStageRewardProxy:onRegisterEvent")
end
return CommonStageRewardProxy
