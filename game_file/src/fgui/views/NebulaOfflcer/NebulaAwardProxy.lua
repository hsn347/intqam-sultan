local baseProxy = require("fgui.base.baseProxy")
local NebulaAwardProxy = class("NebulaAwardProxy", baseProxy)
function NebulaAwardProxy:onRegisterEvent()
	print("=======NebulaAwardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_PRIVILEGE_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaAwardProxy:updateView()
	if self.view then
		self.view:updateView()
	end
end
function NebulaAwardProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_PRIVILEGE) and self.view then
		self.view:close()
	end
end
return NebulaAwardProxy
