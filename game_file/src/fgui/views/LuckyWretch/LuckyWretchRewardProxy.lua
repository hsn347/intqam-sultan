local baseProxy = require("fgui.base.baseProxy")
local LuckyWretchRewardProxy = class("LuckyWretchRewardProxy", baseProxy)
function LuckyWretchRewardProxy:onRegisterEvent()
	print("=======LuckyWretchRewardProxy:onRegisterEvent")
end
return LuckyWretchRewardProxy
