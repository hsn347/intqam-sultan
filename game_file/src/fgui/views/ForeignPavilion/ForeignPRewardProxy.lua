local baseProxy = require("fgui.base.baseProxy")
local ForeignPRewardProxy = class("ForeignPRewardProxy", baseProxy)
function ForeignPRewardProxy:onRegisterEvent()
	print("=======ForeignPRewardProxy:onRegisterEvent")
end
return ForeignPRewardProxy
