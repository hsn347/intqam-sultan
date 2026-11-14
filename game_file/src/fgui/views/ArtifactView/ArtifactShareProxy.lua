local baseProxy = require("fgui.base.baseProxy")
local ArtifactShareProxy = class("ArtifactShareProxy", baseProxy)
function ArtifactShareProxy:onRegisterEvent()
	print("=======ArtifactShareProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS", handler(self, self.downLoadSuccess))
end
function ArtifactShareProxy:downLoadSuccess(target, data)
	if self.view.curData and self.view.curData.actionNode.png and data.file == self.view.curData.actionNode.png then
		self.view:updateArtifactAction()
	end
end
return ArtifactShareProxy
