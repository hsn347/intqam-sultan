local baseProxy = require("fgui.base.baseProxy")
local dailyAwardPassViewProxy = class("dailyAwardPassViewProxy", baseProxy)
function dailyAwardPassViewProxy:onRegisterEvent()
	print("=======dailyAwardPassViewProxy:onRegisterEvent")
end
return dailyAwardPassViewProxy
