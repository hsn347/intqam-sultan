local baseProxy = require("fgui.base.baseProxy")
local newYearSignInProxy = class("newYearSignInProxy", baseProxy)
function newYearSignInProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_NEW_YEAR_SIGN_IN_REFRESH", handler(self, self.updateView))
end
function newYearSignInProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_YEAR_CARNIVAL_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function newYearSignInProxy:updateView(target, data)
	if data.day and data.day < 7 then
		self.view:runSignSuccessEffect(data.day)
		return
	end
	self.view:updateView()
end
return newYearSignInProxy
