local baseProxy = require("fgui.base.baseProxy")
local StarTreasuryAwardProxy = class("StarTreasuryAwardProxy", baseProxy)
function StarTreasuryAwardProxy:onRegisterEvent()
	print("=======StarTreasuryAwardProxy:onRegisterEvent")
end
return StarTreasuryAwardProxy
