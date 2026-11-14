local baseProxy = require("fgui.base.baseProxy")
local worldDispatchArmySelectViewProxy = class("worldDispatchArmySelectViewProxy", baseProxy)
function worldDispatchArmySelectViewProxy:onRegisterEvent()
	print("=======worldDispatchArmySelectViewProxy:onRegisterEvent")
end
return worldDispatchArmySelectViewProxy
