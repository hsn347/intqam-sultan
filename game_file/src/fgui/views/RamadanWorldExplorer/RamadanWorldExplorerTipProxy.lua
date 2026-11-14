local baseProxy = require("fgui.base.baseProxy")
local RamadanWorldExplorerTipProxy = class("RamadanWorldExplorerTipProxy", baseProxy)
function RamadanWorldExplorerTipProxy:onRegisterEvent()
	print("=======RamadanWorldExplorerTipProxy:onRegisterEvent")
end
return RamadanWorldExplorerTipProxy
