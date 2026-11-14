local baseProxy = require("fgui.base.baseProxy")
local ArtifactViewProxy = class("ArtifactViewProxy", baseProxy)
function ArtifactViewProxy:onRegisterEvent()
	print("=======ArtifactViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_UNLOCK", handler(self, self.unlockSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_REFINE_BACK", handler(self, self.refineSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_AWAKE_BACK", handler(self, self.awakeSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_SKILL_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS", handler(self, self.downLoadSuccess))
	SoraDAddMessage(self, "MESSAGE_RUNE_UPDATE", handler(self, self.updateView))
end
function ArtifactViewProxy:unlockSuccess(target, data)
	SoraDPlaySound("artifactSound", "unlock")
	self.view:unlockAction()
	SoraDCloseLoading()
end
function ArtifactViewProxy:refineSuccess(target, data)
	if data.refineType and data.refineType == ARMS_REFINE_TYPE.ADVANCE_REFINE then
		SoraDPlaySound("artifactSound", "gjcl")
	else
		SoraDPlaySound("artifactSound", "ptcl")
	end
	self.view:updateView()
	local _ENV, add_history = self.view.updateView, self.view.updateView
	for i, v in ipairs(data.critData) do
		if v.times > 1 then
			table.insert(add_history, v)
		end
	end
	if next(add_history) then
		self.view:showFeedHitTimes(add_history)
	end
end
function ArtifactViewProxy:awakeSuccess(target, data)
	SoraDPlaySound("artifactSound", "awaken")
	self.view:awakeShader()
	SoraDCloseLoading()
end
function ArtifactViewProxy:updateView(target, data)
	self.view:updateView()
end
function ArtifactViewProxy:downLoadSuccess(target, data)
	if self.view.curData and self.view.curData.actionNode.png and data.file == self.view.curData.actionNode.png then
		self.view:updateArtifactAction()
	end
end
return ArtifactViewProxy
