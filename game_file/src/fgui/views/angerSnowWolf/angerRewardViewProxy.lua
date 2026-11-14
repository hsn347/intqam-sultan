local baseProxy = require("fgui.base.baseProxy")
local angerRewardViewProxy = class("angerRewardViewProxy", baseProxy)
function angerRewardViewProxy:onRegisterEvent()
	print("=======angerRewardViewProxy:onRegisterEvent")
end
return angerRewardViewProxy
