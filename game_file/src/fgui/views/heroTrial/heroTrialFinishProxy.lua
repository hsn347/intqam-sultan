local baseProxy = require("fgui.base.baseProxy")
local heroTrialFinishProxy = class("heroTrialFinishProxy", baseProxy)
function heroTrialFinishProxy:onRegisterEvent()
	print("=======heroTrialFinishProxy:onRegisterEvent")
end
return heroTrialFinishProxy
