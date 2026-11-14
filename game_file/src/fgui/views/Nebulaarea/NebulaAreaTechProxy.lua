local baseProxy = require("fgui.base.baseProxy")
local NebulaAreaTechProxy = class("NebulaAreaTechProxy", baseProxy)
function NebulaAreaTechProxy:onRegisterEvent()
	print("=======NebulaAreaTechProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_INFO_UPGRADE", handler(self, self.judgeClose))
end
function NebulaAreaTechProxy:updateView(target, data)
	self.view:updateView()
end
function NebulaAreaTechProxy:judgeClose(target, data)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local nebulaPalaceCell = cityCtrl:getBuildCell(BUILDID.NEBULA_PALACE, 0)
	if nil == nebulaPalaceCell or tonumber(nebulaPalaceCell.info.state) == BUILD_STATE.LOCK then
		SoraDRemoveAllPanelFromManager()
	end
end
return NebulaAreaTechProxy
