local baseProxy = require("fgui.base.baseProxy")
local footballRewardProxy = class("footballRewardProxy", baseProxy)
function footballRewardProxy:onRegisterEvent()
	print("=======footballRewardProxy:onRegisterEvent")
end
return footballRewardProxy
