local baseProxy = require("fgui.base.baseProxy")
local gotPrivilegePopViewProxy = class("gotPrivilegePopViewProxy", baseProxy)
function gotPrivilegePopViewProxy:onRegisterEvent()
	print("=======gotPrivilegePopViewProxy:onRegisterEvent")
end
return gotPrivilegePopViewProxy
