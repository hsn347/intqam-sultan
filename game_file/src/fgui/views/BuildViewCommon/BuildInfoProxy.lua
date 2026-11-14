local baseProxy = require("fgui.base.baseProxy")
local BuildInfoProxy = class("BuildInfoProxy", baseProxy)
function BuildInfoProxy:onRegisterEvent()
	print("=======BuildInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END", handler(self.view, self.view.buildQueueCallback))
	SoraDAddMessage(self, "MESSAGE_BUILD_INFO_UPGRADE", handler(self.view, self.view.closeByBuildLock))
end
return BuildInfoProxy
