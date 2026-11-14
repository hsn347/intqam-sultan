local baseProxy = require("fgui.base.baseProxy")
local RadiantMsgTipProxy = class("RadiantMsgTipProxy", baseProxy)
function RadiantMsgTipProxy:onRegisterEvent()
	print("=======RadiantMsgTipProxy:onRegisterEvent")
end
return RadiantMsgTipProxy
