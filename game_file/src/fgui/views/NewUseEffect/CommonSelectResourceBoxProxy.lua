local baseProxy = require("fgui.base.baseProxy")
local CommonSelectResourceBoxProxy = class("CommonSelectResourceBoxProxy", baseProxy)
function CommonSelectResourceBoxProxy:onRegisterEvent()
	print("=======CommonSelectResourceBoxProxy:onRegisterEvent")
end
return CommonSelectResourceBoxProxy
