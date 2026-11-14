local baseProxy = require("fgui.base.baseProxy")
local RamadanCalendarDetailProxy = class("RamadanCalendarDetailProxy", baseProxy)
function RamadanCalendarDetailProxy:onRegisterEvent()
	print("=======RamadanCalendarDetailProxy:onRegisterEvent")
end
return RamadanCalendarDetailProxy
