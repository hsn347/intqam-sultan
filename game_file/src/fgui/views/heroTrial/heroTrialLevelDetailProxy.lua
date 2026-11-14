local baseProxy = require("fgui.base.baseProxy")
local heroTrialLevelDetailProxy = class("heroTrialLevelDetailProxy", baseProxy)
function heroTrialLevelDetailProxy:onRegisterEvent()
	print("=======heroTrialLevelDetailProxy:onRegisterEvent")
end
return heroTrialLevelDetailProxy
