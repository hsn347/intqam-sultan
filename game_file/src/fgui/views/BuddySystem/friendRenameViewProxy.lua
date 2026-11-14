local baseProxy = require("fgui.base.baseProxy")
local friendRenameViewProxy = class("friendRenameViewProxy", baseProxy)
function friendRenameViewProxy:onRegisterEvent()
	print("=======friendRenameViewProxy:onRegisterEvent")
end
return friendRenameViewProxy
