local baseProxy = require("fgui.base.baseProxy")
local PetOneKeyViewProxy = class("PetOneKeyViewProxy", baseProxy)
function PetOneKeyViewProxy:onRegisterEvent()
	print("=======PetOneKeyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_PET_ONKEY_BACK", handler(self.view, self.view.sMsgOnKeyBack))
end
return PetOneKeyViewProxy
