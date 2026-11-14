local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorOfficerProxy = class("NebulaEmperorOfficerProxy", baseProxy)
function NebulaEmperorOfficerProxy:onRegisterEvent()
	print("=======NebulaEmperorOfficerProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_ALL_TITLE", handler(self, self.onMsgReqAllTitleBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_SINGLE_TITLE", handler(self, self.onMsgUpdateSingleTitle))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
end
function NebulaEmperorOfficerProxy:onMsgReqAllTitleBack(...)
	self.view:onMsgReqAllTitleBack(...)
end
function NebulaEmperorOfficerProxy:onMsgUpdateSingleTitle(...)
	self.view:onMsgUpdateSingleTitle(...)
end
function NebulaEmperorOfficerProxy:onMsgCommonRefresh(target, event)
	local nebulaEmperorUtil = include("nebulaEmperorUtil")
	local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
	if nebulaEmperorCtrl:checkActivityID(event) and not nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.SETTLE) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaEmperorOfficerProxy
