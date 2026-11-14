local baseProxy = require("fgui.base.baseProxy")
local RamadanWorldExplorerGetAwardProxy = class("RamadanWorldExplorerGetAwardProxy", baseProxy)
function RamadanWorldExplorerGetAwardProxy:onRegisterEvent()
	print("=======RamadanWorldExplorerGetAwardProxy:onRegisterEvent")
end
return RamadanWorldExplorerGetAwardProxy
