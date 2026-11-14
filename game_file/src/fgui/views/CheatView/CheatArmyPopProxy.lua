local baseProxy = require("fgui.base.baseProxy")
local CheatArmyPopProxy = class("CheatArmyPopProxy", baseProxy)
function CheatArmyPopProxy:onRegisterEvent()
	print("=======CheatArmyPopProxy:onRegisterEvent")
end
return CheatArmyPopProxy
