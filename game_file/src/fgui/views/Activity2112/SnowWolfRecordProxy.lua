local baseProxy = require("fgui.base.baseProxy")
local SnowWolfRecordProxy = class("SnowWolfRecordProxy", baseProxy)
function SnowWolfRecordProxy:onRegisterEvent()
	print("=======SnowWolfRecordProxy:onRegisterEvent")
end
return SnowWolfRecordProxy
