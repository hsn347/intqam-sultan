local baseProxy = require("fgui.base.baseProxy")
local radianceWarChangeNoticeProxy = class("radianceWarChangeNoticeProxy", baseProxy)
function radianceWarChangeNoticeProxy:onRegisterEvent()
	print("=======radianceWarChangeNoticeProxy:onRegisterEvent")
end
return radianceWarChangeNoticeProxy
