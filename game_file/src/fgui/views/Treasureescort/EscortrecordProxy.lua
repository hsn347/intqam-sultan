local baseProxy = require("fgui.base.baseProxy")
local EscortrecordProxy = class("EscortrecordProxy", baseProxy)
function EscortrecordProxy:onRegisterEvent()
	print("=======EscortrecordProxy:onRegisterEvent")
end
return EscortrecordProxy
