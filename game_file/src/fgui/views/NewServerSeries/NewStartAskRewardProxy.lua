local baseProxy = require("fgui.base.baseProxy")
local NewStartAskRewardProxy = class("NewStartAskRewardProxy", baseProxy)
function NewStartAskRewardProxy:onRegisterEvent()
	print("=======NewStartAskRewardProxy:onRegisterEvent")
end
return NewStartAskRewardProxy
