local baseProxy = require("fgui.base.baseProxy")
local StarGiftRewardProxy = class("StarGiftRewardProxy", baseProxy)
function StarGiftRewardProxy:onRegisterEvent()
	print("=======StarGiftRewardProxy:onRegisterEvent")
end
return StarGiftRewardProxy
