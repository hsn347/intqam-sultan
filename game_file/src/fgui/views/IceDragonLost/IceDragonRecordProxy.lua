local baseProxy = require("fgui.base.baseProxy")
local IceDragonRecordProxy = class("IceDragonRecordProxy", baseProxy)
function IceDragonRecordProxy:onRegisterEvent()
	print("=======IceDragonRecordProxy:onRegisterEvent")
end
return IceDragonRecordProxy
