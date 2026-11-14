local baseProxy = require("fgui.base.baseProxy")
local MailManorRecountProxy = class("MailManorRecountProxy", baseProxy)
function MailManorRecountProxy:onRegisterEvent()
	print("=======MailManorRecountProxy:onRegisterEvent")
end
return MailManorRecountProxy
