local baseProxy = require("fgui.base.baseProxy")
local RamadanSign2023Proxy = class("RamadanSign2023Proxy", baseProxy)
function RamadanSign2023Proxy:onRegisterEvent()
	print("=======RamadanSign2023Proxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RAMADAN_2023_SIGN", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.initData))
end
function RamadanSign2023Proxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
function RamadanSign2023Proxy:initData()
	if self.view then
		self.view:refreshPageInZero()
	end
end
function RamadanSign2023Proxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RamadanSign2023Proxy
