local baseProxy = require("fgui.base.baseProxy")
local MeteoriteSkillProxy = class("MeteoriteSkillProxy", baseProxy)
function MeteoriteSkillProxy:onRegisterEvent()
	print("=======MeteoriteSkillProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC_SKILL", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_INFO_UPGRADE", handler(self, self.judgeClose))
end
function MeteoriteSkillProxy:updateView(target, data)
	self.view:updateView()
end
function MeteoriteSkillProxy:judgeClose(target, data)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local nebulaPalaceCell = cityCtrl:getBuildCell(BUILDID.NEBULA_PALACE, 0)
	if nil == nebulaPalaceCell or tonumber(nebulaPalaceCell.info.state) == BUILD_STATE.LOCK then
		SoraDRemoveAllPanelFromManager()
	end
end
return MeteoriteSkillProxy
