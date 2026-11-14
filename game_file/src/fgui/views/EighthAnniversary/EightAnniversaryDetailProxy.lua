local baseProxy = require("fgui.base.baseProxy")
local EightAnniversaryDetailProxy = class("EightAnniversaryDetailProxy", baseProxy)
function EightAnniversaryDetailProxy:onRegisterEvent()
	print("=======EightAnniversaryDetailProxy:onRegisterEvent")
end
return EightAnniversaryDetailProxy
