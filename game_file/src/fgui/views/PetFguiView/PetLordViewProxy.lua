local baseProxy = require("fgui.base.baseProxy")
local PetLordViewProxy = class("PetLordViewProxy", baseProxy)
function PetLordViewProxy:onRegisterEvent()
	print("=======PetLordViewProxy:onRegisterEvent")
end
return PetLordViewProxy
