local baseProxy = require("fgui.base.baseProxy")
local PetUnlockViewProxy = class("PetUnlockViewProxy", baseProxy)
function PetUnlockViewProxy:onRegisterEvent()
	print("=======PetUnlockViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_FCINFO", handler(self.view, self.view.onMsgUpdateFcInfo))
end
return PetUnlockViewProxy
