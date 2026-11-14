local baseProxy = require("fgui.base.baseProxy")
local IceDragonLostRewardProxy = class("IceDragonLostRewardProxy", baseProxy)
function IceDragonLostRewardProxy:onRegisterEvent()
	print("=======IceDragonLostRewardProxy:onRegisterEvent")
end
return IceDragonLostRewardProxy
