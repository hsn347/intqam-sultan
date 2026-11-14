local baseProxy = require("fgui.base.baseProxy")
local friendApplyViewProxy = class("friendApplyViewProxy", baseProxy)
function friendApplyViewProxy:onRegisterEvent()
	print("=======friendApplyViewProxy:onRegisterEvent")
end
return friendApplyViewProxy
