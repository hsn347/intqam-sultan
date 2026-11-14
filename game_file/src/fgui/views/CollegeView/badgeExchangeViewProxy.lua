local baseProxy = require("fgui.base.baseProxy")
local badgeExchangeViewProxy = class("badgeExchangeViewProxy", baseProxy)
function badgeExchangeViewProxy:onRegisterEvent()
	print("=======badgeExchangeViewProxy:onRegisterEvent")
end
return badgeExchangeViewProxy
