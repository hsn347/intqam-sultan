local baseProxy = require("fgui.base.baseProxy")
local jerseyDonateProxy = class("jerseyDonateProxy", baseProxy)
function jerseyDonateProxy:onRegisterEvent()
	print("=======jerseyDonateProxy:onRegisterEvent")
end
return jerseyDonateProxy
