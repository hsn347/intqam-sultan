local baseProxy = require("fgui.base.baseProxy")
local NebulaTreasureAwardProxy = class("NebulaTreasureAwardProxy", baseProxy)
function NebulaTreasureAwardProxy:onRegisterEvent()
	print("=======NebulaTreasureAwardProxy:onRegisterEvent")
end
return NebulaTreasureAwardProxy
