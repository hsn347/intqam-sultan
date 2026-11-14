local baseProxy = require("fgui.base.baseProxy")
local NebulaTreasurePopProxy = class("NebulaTreasurePopProxy", baseProxy)
function NebulaTreasurePopProxy:onRegisterEvent()
	print("=======NebulaTreasurePopProxy:onRegisterEvent")
end
return NebulaTreasurePopProxy
