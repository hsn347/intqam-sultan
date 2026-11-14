local baseProxy = require("fgui.base.baseProxy")
local ForeignNpcIntroductionProxy = class("ForeignNpcIntroductionProxy", baseProxy)
function ForeignNpcIntroductionProxy:onRegisterEvent()
	print("=======ForeignNpcIntroductionProxy:onRegisterEvent")
end
return ForeignNpcIntroductionProxy
