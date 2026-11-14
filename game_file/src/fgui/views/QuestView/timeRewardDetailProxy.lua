local baseProxy = require("fgui.base.baseProxy")
local timeRewardDetailProxy = class("timeRewardDetailProxy", baseProxy)
function timeRewardDetailProxy:onRegisterEvent()
	print("=======timeRewardDetailProxy:onRegisterEvent")
end
return timeRewardDetailProxy
