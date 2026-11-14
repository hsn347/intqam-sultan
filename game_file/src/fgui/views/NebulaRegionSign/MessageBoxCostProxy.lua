local baseProxy = require("fgui.base.baseProxy")
local MessageBoxCostProxy = class("MessageBoxCostProxy", baseProxy)
function MessageBoxCostProxy:onRegisterEvent()
	print("=======MessageBoxCostProxy:onRegisterEvent")
end
return MessageBoxCostProxy
