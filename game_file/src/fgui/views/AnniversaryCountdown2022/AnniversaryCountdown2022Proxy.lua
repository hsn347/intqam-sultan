local baseProxy = require("fgui.base.baseProxy")
local AnniversaryCountdown2022Proxy = class("AnniversaryCountdown2022Proxy", baseProxy)
function AnniversaryCountdown2022Proxy:ctor(...)
	self.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_2022_ACTIVITY
end
function AnniversaryCountdown2022Proxy:onRegisterEvent()
	print("=======AnniversaryCountdown2022Proxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ANNIV_COUNTDOWN_2022", handler(self, self.refreshView))
end
function AnniversaryCountdown2022Proxy:refreshView(target, data)
	dump(data, "Fkdlfkl")
	if self.view then
		if data.subMsg == "init" then
			self.view:initData()
		elseif data.subMsg == "sign" then
			self.view:refreshRedPoint()
			self.view:refreshPage(data)
		elseif data.subMsg == "countdown" then
			self.view:refreshPage(data)
		end
	end
end
function AnniversaryCountdown2022Proxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return AnniversaryCountdown2022Proxy
