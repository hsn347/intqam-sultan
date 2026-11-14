local baseProxy = require("fgui.base.baseProxy")
local NebulaWarRewardShowProxy = class("NebulaWarRewardShowProxy", baseProxy)
function NebulaWarRewardShowProxy:onRegisterEvent()
	print("=======NebulaWarRewardShowProxy:onRegisterEvent")
end
return NebulaWarRewardShowProxy
