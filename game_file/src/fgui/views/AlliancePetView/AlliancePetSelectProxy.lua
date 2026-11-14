local baseProxy = require("fgui.base.baseProxy")
local AlliancePetSelectProxy = class("AlliancePetSelectProxy", baseProxy)
function AlliancePetSelectProxy:onRegisterEvent()
	print("=======AlliancePetSelectProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_CALLBACK", function(target, data)
		SoraDRemoveAllAfterPanelFromManager(self.view)
		uiManager:show("AlliancePetMainView")
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(target, data)
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", function(target, data)
		if gAllianceBuilding.ALTAR ~= data.bid then
			return
		end
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end)
end
return AlliancePetSelectProxy
