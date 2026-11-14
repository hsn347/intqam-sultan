local baseProxy = require("fgui.base.baseProxy")
local mailGivePersentHelpProxy = class("mailGivePersentHelpProxy", baseProxy)
function mailGivePersentHelpProxy:onRegisterEvent()
	print("=======mailGivePersentHelpProxy:onRegisterEvent")
end
return mailGivePersentHelpProxy
