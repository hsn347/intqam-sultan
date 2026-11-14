local baseProxy = require("fgui.base.baseProxy")
local NewYearCarnival2022Proxy = class("NewYearCarnival2022Proxy", baseProxy)
function NewYearCarnival2022Proxy:onRegisterEvent()
	print("=======NewYearCarnival2022Proxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NewYearCarnival2022Proxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_YEAR_CARNIVAL_2022) and self.view then
		self.view:closeView()
	end
end
return NewYearCarnival2022Proxy
