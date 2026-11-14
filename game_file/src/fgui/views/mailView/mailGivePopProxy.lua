local baseProxy = require("fgui.base.baseProxy")
local mailGivePopProxy = class("mailGivePopProxy", baseProxy)
function mailGivePopProxy:onRegisterEvent()
	print("=======mailGivePopProxy:onRegisterEvent")
end
return mailGivePopProxy
