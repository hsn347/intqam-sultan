local baseProxy = require("fgui.base.baseProxy")
local rewardPopProxy = class("rewardPopProxy", baseProxy)
function rewardPopProxy:onRegisterEvent()
	print("=======rewardPopProxy:onRegisterEvent")
end
return rewardPopProxy
