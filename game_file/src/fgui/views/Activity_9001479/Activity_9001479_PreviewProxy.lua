local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
local baseProxy = require("fgui.base.baseProxy")
local Activity_9001479_PreviewProxy = class("Activity_9001479_PreviewProxy", baseProxy)
function Activity_9001479_PreviewProxy:onRegisterEvent()
	print("=======Activity_9001479_PreviewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001479_UPDATE_STAGE", handler(self, self.onMsgUpdateStage))
end
function Activity_9001479_PreviewProxy:onMsgUpdateStage(...)
	if activity_9001479_Ctrl:getCurRound() > 0 then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001479_PreviewProxy
