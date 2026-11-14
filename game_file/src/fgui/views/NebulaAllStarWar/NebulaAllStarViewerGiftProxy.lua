local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarViewerGiftProxy = class("NebulaAllStarViewerGiftProxy", baseProxy)
function NebulaAllStarViewerGiftProxy:onRegisterEvent()
	print("=======NebulaAllStarViewerGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_VIEWER_GIFT_INFO", handler(self, self.onMsgUpdateGiftInfo))
end
function NebulaAllStarViewerGiftProxy:onMsgUpdateGiftInfo(...)
	self.view:onMsgUpdateGiftInfo(...)
end
return NebulaAllStarViewerGiftProxy
