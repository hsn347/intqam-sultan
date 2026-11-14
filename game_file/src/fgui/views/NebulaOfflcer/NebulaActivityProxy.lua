local baseProxy = require("fgui.base.baseProxy")
local NebulaActivityProxy = class("NebulaActivityProxy", baseProxy)
function NebulaActivityProxy:onRegisterEvent()
	print("=======NebulaActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaActivityProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_PRIVILEGE) and self.view then
		self.view:close()
	end
end
return NebulaActivityProxy
