local baseProxy = require("fgui.base.baseProxy")
local MeteoriteUIProxy = class("MeteoriteUIProxy", baseProxy)
function MeteoriteUIProxy:onRegisterEvent()
	print("=======MeteoriteUIProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_INFO_UPGRADE", handler(self, self.judgeClose))
end
function MeteoriteUIProxy:updateView(target, data)
	self.view:updateView()
end
function MeteoriteUIProxy:judgeClose(target, data)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local nebulaPalaceCell = cityCtrl:getBuildCell(BUILDID.NEBULA_PALACE, 0)
	if nil == nebulaPalaceCell or tonumber(nebulaPalaceCell.info.state) == BUILD_STATE.LOCK then
		SoraDRemoveAllPanelFromManager()
	end
end
return MeteoriteUIProxy
