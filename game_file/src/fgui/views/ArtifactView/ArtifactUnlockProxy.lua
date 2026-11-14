local baseProxy = require("fgui.base.baseProxy")
local ArtifactUnlockProxy = class("ArtifactUnlockProxy", baseProxy)
function ArtifactUnlockProxy:onRegisterEvent()
	print("=======ArtifactUnlockProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function()
		self.view:updateView()
	end)
end
return ArtifactUnlockProxy
