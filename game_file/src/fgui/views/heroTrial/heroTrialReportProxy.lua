local baseProxy = require("fgui.base.baseProxy")
local heroTrialReportProxy = class("heroTrialReportProxy", baseProxy)
function heroTrialReportProxy:onRegisterEvent()
	print("=======heroTrialReportProxy:onRegisterEvent")
end
return heroTrialReportProxy
