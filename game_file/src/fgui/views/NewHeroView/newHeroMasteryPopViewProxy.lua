local baseProxy = require("fgui.base.baseProxy")
local newHeroMasteryPopViewProxy = class("newHeroMasteryPopViewProxy", baseProxy)
function newHeroMasteryPopViewProxy:onRegisterEvent()
	print("=======newHeroMasteryPopViewProxy:onRegisterEvent")
end
return newHeroMasteryPopViewProxy
