local baseProxy = require("fgui.base.baseProxy")
local gameInviteProxy = class("gameInviteProxy", baseProxy)
function gameInviteProxy:onRegisterEvent()
	print("=======gameInviteProxy:onRegisterEvent")
end
return gameInviteProxy
