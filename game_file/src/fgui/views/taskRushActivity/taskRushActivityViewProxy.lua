local baseProxy = require("fgui.base.baseProxy")
local taskRushActivityViewProxy = class("taskRushActivityViewProxy", baseProxy)
function taskRushActivityViewProxy:onRegisterEvent()
	print("=======taskRushActivityViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_TASKRUSH_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function taskRushActivityViewProxy:updateView(target, data)
	dump(data, "taskRushActivityViewProxy:updateView=====", 10)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateView()
end
function taskRushActivityViewProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(SoraDGetCtrl("taskRushActivityCtrl"):getActivityID()) then
		SoraDShowMsgTip(i18n("Bright_night_activity_tips_0004"))
		self.view:close()
	end
end
return taskRushActivityViewProxy
