local baseProxy = require("fgui.base.baseProxy")
local NebulaWonderlandDonateProxy = class("NebulaWonderlandDonateProxy", baseProxy)
function NebulaWonderlandDonateProxy:onRegisterEvent()
	print("=======NebulaWonderlandDonateProxy:onRegisterEvent")
end
return NebulaWonderlandDonateProxy
