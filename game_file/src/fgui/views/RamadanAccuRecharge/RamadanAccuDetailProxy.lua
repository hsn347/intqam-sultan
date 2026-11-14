local baseProxy = require("fgui.base.baseProxy")
local RamadanAccuDetailProxy = class("RamadanAccuDetailProxy", baseProxy)
function RamadanAccuDetailProxy:onRegisterEvent()
	print("=======RamadanAccuDetailProxy:onRegisterEvent")
end
return RamadanAccuDetailProxy
