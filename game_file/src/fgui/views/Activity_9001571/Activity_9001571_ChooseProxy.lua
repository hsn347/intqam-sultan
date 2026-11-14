local baseProxy = require("fgui.base.baseProxy")
local Activity_9001571_ChooseProxy = class("Activity_9001571_ChooseProxy", baseProxy)
function Activity_9001571_ChooseProxy:onRegisterEvent()
	print("=======Activity_9001571_ChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001571_UPDATE", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001571_ChooseProxy:msgCallBack(target, data)
	if data.subMsg == "changeGroup" then
		SoraDCloseLoading()
		self.view:removeFromParent()
		uiManager:show("Activity_9001571_Main")
	end
end
function Activity_9001571_ChooseProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001571) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001571_ChooseProxy
