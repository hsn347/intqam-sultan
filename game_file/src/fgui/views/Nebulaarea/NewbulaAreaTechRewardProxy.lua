local baseProxy = require("fgui.base.baseProxy")
local NewbulaAreaTechRewardProxy = class("NewbulaAreaTechRewardProxy", baseProxy)
function NewbulaAreaTechRewardProxy:onRegisterEvent()
	print("=======NewbulaAreaTechRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_LOGIN_REWARD", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_INFO_UPGRADE", handler(self, self.judgeClose))
end
function NewbulaAreaTechRewardProxy:updateView()
	self.view:updateView()
end
function NewbulaAreaTechRewardProxy:judgeClose(target, data)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local nebulaPalaceCell = cityCtrl:getBuildCell(BUILDID.NEBULA_PALACE, 0)
	if nil == nebulaPalaceCell or tonumber(nebulaPalaceCell.info.state) == BUILD_STATE.LOCK then
		SoraDRemoveAllPanelFromManager()
	end
end
return NewbulaAreaTechRewardProxy
