local baseProxy = require("fgui.base.baseProxy")
local AlliancePetMainViewProxy = class("AlliancePetMainViewProxy", baseProxy)
local alliancePetCtrl = SoraDGetCtrl("alliancePetCtrl")
function AlliancePetMainViewProxy:onRegisterEvent()
	print("=======AlliancePetMainViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_NORMAL_ERR", function(...)
		SoraDCloseLoading(self.view)
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_DONATE_SUCCESS", handler(self, self.updateDonateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_DONATE_CD_CLEAN_SUCCESS", handler(self, self.updateDonateCD))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_UPDATE_INFO", handler(self, self.onMsgAlliancePetUpdateInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_REQ_INFO_BACK", function(target, data)
		SoraDCloseLoading(self.view)
		self.view:setPetInfo(alliancePetCtrl:getAlliancePetType())
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
function AlliancePetMainViewProxy:updateDonateData(...)
	self.view:updateDonateData(...)
end
function AlliancePetMainViewProxy:updateDonateCD(...)
	self.view:updateDonateCD(...)
end
function AlliancePetMainViewProxy:onMsgAlliancePetUpdateInfo(...)
	self.view:onMsgAlliancePetUpdateInfo(...)
end
return AlliancePetMainViewProxy
