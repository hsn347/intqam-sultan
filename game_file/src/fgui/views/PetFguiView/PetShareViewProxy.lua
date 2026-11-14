local baseProxy = require("fgui.base.baseProxy")
local PetShareViewProxy = class("PetShareViewProxy", baseProxy)
function PetShareViewProxy:onRegisterEvent()
	print("=======PetShareViewProxy:onRegisterEvent")
end
return PetShareViewProxy
