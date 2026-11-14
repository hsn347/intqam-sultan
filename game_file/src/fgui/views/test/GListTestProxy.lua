local baseProxy = require("fgui.base.baseProxy")
local GListTestProxy = class("GListTestProxy", baseProxy)
function GListTestProxy:onRegisterEvent()
	print("=======GListTestProxy:onRegisterEvent")
end
return GListTestProxy
