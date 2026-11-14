local baseProxy = require("fgui.base.baseProxy")
local NewStartInheritProxy = class("NewStartInheritProxy", baseProxy)
function NewStartInheritProxy:onRegisterEvent()
	print("=======NewStartInheritProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_NEW_START_CORRELTION_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_NEW_START_INITNEW", handler(self, self.refreshView))
end
function NewStartInheritProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NewStartInheritProxy:refreshView(target, event)
	self.view:refreshView(target, event)
end
return NewStartInheritProxy
