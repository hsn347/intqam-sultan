local baseProxy = require("fgui.base.baseProxy")
local gameInvitePriceDetailProxy = class("gameInvitePriceDetailProxy", baseProxy)
function gameInvitePriceDetailProxy:onRegisterEvent()
	print("=======gameInvitePriceDetailProxy:onRegisterEvent")
end
return gameInvitePriceDetailProxy
