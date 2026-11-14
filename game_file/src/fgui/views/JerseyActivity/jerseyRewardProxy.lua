local baseProxy = require("fgui.base.baseProxy")
local jerseyRewardProxy = class("jerseyRewardProxy", baseProxy)
function jerseyRewardProxy:onRegisterEvent()
	print("=======jerseyRewardProxy:onRegisterEvent")
end
return jerseyRewardProxy
