local baseProxy = require("fgui.base.baseProxy")
local heroTrialViewProxy = class("heroTrialViewProxy", baseProxy)
function heroTrialViewProxy:onRegisterEvent()
	print("=======heroTrialViewProxy:onRegisterEvent")
end
return heroTrialViewProxy
