local baseProxy = require("fgui.base.baseProxy")
local LegendOfPegasusRecordProxy = class("LegendOfPegasusRecordProxy", baseProxy)
function LegendOfPegasusRecordProxy:onRegisterEvent()
	print("=======LegendOfPegasusRecordProxy:onRegisterEvent")
end
return LegendOfPegasusRecordProxy
