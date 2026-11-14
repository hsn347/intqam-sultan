local baseProxy = require("fgui.base.baseProxy")
local EscortrewardProxy = class("EscortrewardProxy", baseProxy)
function EscortrewardProxy:onRegisterEvent()
	print("=======EscortrewardProxy:onRegisterEvent")
end
return EscortrewardProxy
